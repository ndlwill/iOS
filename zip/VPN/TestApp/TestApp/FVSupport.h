#import <Foundation/Foundation.h>

@interface FVSupport: NSObject

+ (void)fvInit;

+ (NSString *)FVCoreVersion;
+ (NSString *)FVCoreSysEnvId;
+ (NSString *)deviceType;

@end
