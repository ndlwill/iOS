//
//  PacketTunnelProviderObjc.h
//  PacketTunnel
//
//  Created by youdun on 2023/9/27.
//

#import <NetworkExtension/NetworkExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface PacketTunnelProviderObjc : NEPacketTunnelProvider

@property (nonatomic, readwrite) void (^ _Nullable pendingStartCompletion)(NSError * __nullable error);

@end

NS_ASSUME_NONNULL_END
