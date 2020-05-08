

#import <Foundation/Foundation.h>

@protocol KCDownLoadDelegate <NSObject>
@optional
- (void)backDownprogress:(float)progress tag:(NSInteger)tag;
- (void)downSucceed:(NSURL*)url tag:(NSInteger)tag;
- (void)downError:(NSError*)error tag:(NSInteger)tag;
@end


@interface KCDownloadNetwork : NSObject

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic, strong) NSData* resumeData;
@property (nonatomic, weak) id<KCDownLoadDelegate> myDeleate;
@property (nonatomic, assign) NSInteger tag;//某个文件下载的的标记

-(void)downFile:(NSString*)fileUrl isBreakpoint:(BOOL)breakpoint;

//暂停 继续 取消 文件下载
-(void)suspendDownload;
-(void)cancelDownload;

@end
