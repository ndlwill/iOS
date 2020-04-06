

#import <Foundation/Foundation.h>
#import "KCDownloadNetwork.h"


typedef void (^KCRequestHandleBlock)(id result,NSString* msg, NSInteger errorCode);

@interface KCNetwork : NSObject

+ (instancetype)shared;

- (NSURLSessionDataTask *)post:(NSString*)url token:(NSString*)token reqData:(NSDictionary*)params handle:(KCRequestHandleBlock)handleblock;

@end
