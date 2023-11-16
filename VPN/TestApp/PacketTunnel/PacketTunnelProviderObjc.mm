//
//  PacketTunnelProviderObjc.m
//  PacketTunnel
//
//  Created by youdun on 2023/9/27.
//

#import "PacketTunnelProviderObjc.h"

#include <fvcore/fvlib.h>
#include <fvcore/fvclient.h>
#include <fvcore/tundev.h>
#include <fvcore/fvcore.h>
#include <fvcore/fvclientproxy.h>

static dispatch_queue_t dqClient;
static FVClient fvClient;

typedef NS_ENUM(NSInteger, PacketTunnelProviderErrorCode) {
    PacketTunnelProviderErrorCodeStopped = 0,
    PacketTunnelProviderErrorCodeBadState = 1,
    PacketTunnelProviderErrorCodeInvalidOptions = 2,
};

// MARK: - TunDev::write
static NSArray<NSNumber *> *protocolsAfInet = @[@AF_INET];

// TunDev: TunnelDevice
ssize_t TunDev::write(const uint8_t *buf, size_t size) {
    @autoreleasepool {
        PacketTunnelProviderObjc *provider = (__bridge PacketTunnelProviderObjc *)context;
        NSArray<NSData *> *packets = @[[NSData dataWithBytesNoCopy:(void *)buf length:size freeWhenDone:NO]];
        
        [provider.packetFlow writePackets:packets withProtocols:protocolsAfInet];
        return size;
    }
}

// MARK: - PacketTunnelProviderObjc
static bool inited = false;

@interface PacketTunnelProviderObjc ()
@end

@implementation PacketTunnelProviderObjc

@synthesize pendingStartCompletion;

// MARK: - static methods
static NSString * String2NSString(const std::string &s) {
    return [NSString stringWithUTF8String:s.c_str()];
}

static std::string GetOption(NSDictionary<NSString *, NSObject *> *options, NSString *key) {
    NSString *s = (NSString *)[options valueForKey:key];
    return s ? [s UTF8String] : "";
}

// MARK: - init
- (id)init {
    self = [super init];
    self.pendingStartCompletion = nil;

    if (!inited) {
        signal(SIGPIPE, SIG_IGN);
        FVCoreInitialize();
    }
    return self;
}

- (void)cancelTunnelWithErrorCode:(NSInteger)errorCode errorUserInfo:(NSDictionary *)errorUserInfo {
    NSError *error = [NSError errorWithDomain:NETunnelProviderErrorDomain
                                         code:errorCode
                                     userInfo:errorUserInfo];
    
    fv::logger.d("cancelTunnel ...");
    [self cancelTunnelWithError:error];
}

- (void)clientWork
{
    dispatch_async(dqClient, ^{
        fvClient.work(5);
        
        int state = fvClient.getState();
        
        // MARK: - FVClient::State_Connected 进行路由设置
        if(fvClient.isWorkStateChanged() && state == FVClient::State_Connected) {
            [self configureAndComplete];
        }
        
        // MARK: - FVClient::State_Stopped
        if(state == FVClient::State_Stopped) {
            NSString *ft = [NSString stringWithUTF8String:fvClient.failureType.c_str()];
            NSString *fm = [NSString stringWithUTF8String:fvClient.failureMessage.c_str()];
            
            fv::logger.d("clientWork_FVClient::State_Stopped: ft=%s, fm=%s",
                         fvClient.failureType.c_str(),
                         fvClient.failureMessage.c_str());
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *errorUserInfo = @{@"failureType": ft, @"failureMessage": fm};
                
                [self cancelTunnelWithErrorCode:PacketTunnelProviderErrorCodeStopped errorUserInfo:errorUserInfo];
            });
            return;
        }
        
        [self clientWork];
    });
}

// MARK: - FVClient::State_Connected时调用
- (void)configureAndComplete {
    fv::logger.d("configureAndComplete: serverIp=%s, clientDevVirtualIp=%s, serverVirtualIp=%s, mtu=%d",
                 fvClient.serverIp.c_str(),
                 fvClient.clientDevVirtualIp.c_str(),
                 fvClient.serverVirtualIp.c_str(),
                 fvClient.devMtu);
    
   
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:String2NSString(fvClient.serverIp)];
    
    settings.IPv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[String2NSString(fvClient.clientDevVirtualIp)]
                                                          subnetMasks:@[@"255.255.255.255"]];

    settings.IPv4Settings.includedRoutes = @[];

    settings.IPv4Settings.excludedRoutes = @[];
    
    NSMutableArray *includedRoutes = [settings.IPv4Settings.includedRoutes mutableCopy];
    NSMutableArray *dnsServers = [[NSMutableArray alloc] init];
    
    for(size_t i = 0; i < fvClient.dnsServers.size(); i++ ) {
        fv::logger.d("add dns %s", fvClient.dnsServers[i].c_str());
        NSString *dns = String2NSString(fvClient.dnsServers[i]);
        [dnsServers addObject: dns];
    }
    
    [includedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:String2NSString(fvClient.serverVirtualIp) subnetMask:@"255.255.255.255"]];
    [includedRoutes addObject:[NEIPv4Route defaultRoute]];

    
    settings.IPv4Settings.includedRoutes = includedRoutes;
    
    // MARK: - excludedRoutes
    NSMutableArray *excludedRoutes = [settings.IPv4Settings.excludedRoutes mutableCopy];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"10.0.0.0" subnetMask:@"255.0.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"100.64.0.0" subnetMask:@"255.192.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"127.0.0.0" subnetMask:@"255.0.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"169.254.0.0" subnetMask:@"255.255.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"172.16.0.0" subnetMask:@"255.240.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"192.0.0.0" subnetMask:@"255.255.255.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"192.0.2.0" subnetMask:@"255.255.255.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"192.88.99.0" subnetMask:@"255.255.255.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"192.168.0.0" subnetMask:@"255.255.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"198.18.0.0" subnetMask:@"255.254.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"198.51.100.0" subnetMask:@"255.255.255.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"203.0.113.0" subnetMask:@"255.255.255.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"224.0.0.0" subnetMask:@"240.0.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"240.0.0.0" subnetMask:@"240.0.0.0"]];
    [excludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:@"255.255.255.255" subnetMask:@"255.255.255.255"]];
    
    settings.IPv4Settings.excludedRoutes = excludedRoutes;
    
    // MARK: - DNSSettings
    // Network connections to hosts in the tunnel’s internal network will use these DNS settings when resolving host names.
    settings.DNSSettings = [[NEDNSSettings alloc] initWithServers:dnsServers];
    // Maximum Transmission Unit (MTU)
    settings.MTU = [NSNumber numberWithInt:fvClient.devMtu];
    
    std::shared_ptr<TunDev> dev(new TunDev());
    dev->context = (__bridge void *)self;
    fvClient.attachDev(dev);
    
    NSLog(@"=====333");

    fv::logger.d("setTunnelNetworkSettings ...");
    __weak typeof(self) weakSelf = self;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError * __nullable error) {
        // thread: 2
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if(strongSelf.pendingStartCompletion != nil) {
                // error = nil: the tunnel was successfully established
                strongSelf.pendingStartCompletion(error);
                strongSelf.pendingStartCompletion = nil;
            }
            
            // FIXME: - crash sometimes
            fvClient.onClientNetReady();
            
            [strongSelf tunRead];
            
            NSLog(@"=====444 error = %@", error);
            
            fv::logger.d("setTunnelNetworkSettings completion ...");
        }
    }];
}

- (void)tunRead {
    fv::logger.d("tunRead ...");
    [self.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> * __nonnull packets, NSArray<NSNumber *> * __nonnull protocols) {
        // thread: 2 4 6
        NSUInteger count = [packets count];

        @autoreleasepool {
            for (NSUInteger i = 0; i < count; i++) {
                int state = fvClient.getState();
                
                NSData *packet = [packets objectAtIndex:i];
                NSNumber *protocol = [protocols objectAtIndex:i];

                if([protocol intValue] == AF_INET && state == FVClient::State_Connected) {
                    if(fvClient.implType == FVClient::ImplType::ProxyTun) {// tcp
                        fvClient.impl->queueDevInPacketPushActive((uint8_t *)[packet bytes], packet.length);
                    } else {
                        fvClient.impl->processDevInPacket((uint8_t *)[packet bytes], packet.length);
                    }
                }
            }
        }
        
        [self tunRead];
    }];
}

// MARK: - startTunnelWithOptions
- (void)startTunnelWithOptions:(nullable NSDictionary<NSString *,NSObject *> *)options
             completionHandler:(void (^)(NSError * __nullable error))completionHandler
{
    NSLog(@"=====start=====");
    
    if(fvClient.getState() != FVClient::State_Stopped) {
        fv::logger.d("Starting tunnel but bad state");
        NSError *newError = [NSError errorWithDomain:NETunnelProviderErrorDomain
                                                code:PacketTunnelProviderErrorCodeBadState
                                            userInfo:@{NSLocalizedDescriptionKey: @"bad state"}];
        if(completionHandler != nil) {
            completionHandler(newError);
        }
        return;
    }
    NSLog(@"=====111");
    
    // queue
    if (!dqClient) {
        fv::logger.d("Create dispatch queue for client ...");
        dqClient = dispatch_queue_create("dqClient", NULL);
    }
    else {
        fv::logger.d("Use existing dispatch queue for client ...");
    }
    
    fvClient.osPlatform = "ios";
    fvClient.osDevice = GetOption(options, @"OsDevice");
    fvClient.osVersion = GetOption(options, @"OsVersion");
    fvClient.osDeviceId = GetOption(options, @"OsDeviceId");
    fvClient.osDeviceIdMap = GetOption(options, @"OsDeviceIdMap");
    fvClient.userName = GetOption(options, @"UserName");
    fvClient.password = GetOption(options, @"Password");
    fvClient.implType = (FVClient::ImplType)strtol(GetOption(options, @"ImplType").c_str(), NULL, 0);
    if(fvClient.implType == FVClient::ImplType::ProxyTun) {
        fvClient.useLwip = true;
    }

    // serverIp && serverPort
    fvClient.serverIp = GetOption(options, @"ServerAddress");
    if(fvClient.implType == FVClient::ImplType::ProxyTun || fvClient.implType == FVClient::ImplType::ProxySocks)
        fvClient.serverPort = (int)strtol(GetOption(options, @"ServerPortProxy").c_str(), NULL, 0);
    else
        fvClient.serverPort = (int)strtol(GetOption(options, @"ServerPortUdp").c_str(), NULL, 0);
    
    NSNumber *networkLockFlag = (NSNumber *)[options objectForKey:@"NetworkLock"];
    fvClient.networkLock = networkLockFlag.boolValue;
    
    fvClient.clientUniqueId = GetOption(options, @"ClientUniqueId");
    fvClient.clientSite = GetOption(options, @"ClientSite");
    fvClient.clientVersion = GetOption(options, @"ClientVersion");
    fvClient.clientExtra = GetOption(options, @"ClientExtra");
    
    fvClient.rsaKeyPubN = "141601187905926909444644730286409666755495300050721564398199769080746616339148556683219048017120018748016428099359153205651362664001287890722535799466700786136519566714160932079339659299698611914846217596226121056961277268141789905486380539961102053398435632146710731361922836526658451793921073088741138357721";
    fvClient.rsaKeyE = "65537";
    
    // MARK: - prepare
    if (!fvClient.prepare()) {
        fv::logger.d("Starting tunnel but invalid options");
        NSError *newError = [NSError errorWithDomain:NETunnelProviderErrorDomain
                                                code:PacketTunnelProviderErrorCodeInvalidOptions
                                            userInfo:@{NSLocalizedDescriptionKey: @"options invalid"}];
        
        if(completionHandler != nil) {
            completionHandler(newError);
        }
        return;
    }
    NSLog(@"=====222");
    
    fv::logger.d("Work with dispatch queue");
    self.pendingStartCompletion = completionHandler;
    [self clientWork];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason
           completionHandler:(void (^)(void))completionHandler
{
    fvClient.switchStateStopped(FVClient::FailureType_None);
    
    completionHandler();
}

@end
