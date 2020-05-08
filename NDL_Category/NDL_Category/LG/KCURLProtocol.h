
#import <Foundation/Foundation.h>

@interface KCURLProtocol : NSURLProtocol<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;

+ (void)hookNSURLSessionConfiguration;
@end
