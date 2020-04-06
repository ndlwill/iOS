

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^KCFileHandleBlock)(NSURL* fileUrl, NSString *progress);

@interface KCFileStreamNetwork : NSObject

- (NSURLSessionDataTask*)getDownFileUrl:(NSString*)fileUrl backBlock:(KCFileHandleBlock)handleBlock;
@property(nonatomic,strong)UILabel *proLab;

@end
