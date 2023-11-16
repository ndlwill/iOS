#import "FVSupport.h"
#import <sys/utsname.h>
#import <fvcore/fvclient.h>
#import <fvcore/fvcore.h>

static int fvLogger(char prioChar, const char *tag, const char *fmt, va_list ap) {
#ifndef DEBUG
    if(prioChar == 'D' || prioChar == 'V')
        return 0;
#endif
    
    char logMsgBuf[2000];
    fv::BufferedString logMsg(logMsgBuf, sizeof(logMsgBuf));
    if(fv::logger_format(logMsg, 0, prioChar, tag, fmt, ap)) {
        fprintf(stderr, "%s\n", logMsg.str);
    }
    return 0;
}


@implementation FVSupport

+ (void)fvInit {
#ifdef DEBUG
    NSLog(@"test fvcore:%s", fv::bin2hex((const uint8_t *)"1234", 4).c_str());
#endif

    FVCoreInitialize();
    fv::logger.setCallback(fvLogger);
    NSLog(@"FVCoreVersion = %@", [FVSupport FVCoreVersion]);
}

+ (NSString *)FVCoreVersion {
    return [NSString stringWithCString:FVCORE_BUILD_VERSION encoding:NSUTF8StringEncoding];
}

+ (NSString *)FVCoreSysEnvId
{
    return [NSString stringWithCString:FVCoreGetSysEnvId().c_str() encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
