//
//  TestWCDBViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestWCDBViewController.h"
#import "MessageService.h"
#import "WCDB_Message.h"

@interface TestWCDBViewController ()


@end

@implementation TestWCDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ndl_randomColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MessageService *service = [[MessageService alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray<WCDB_Message *> *arr = [NSMutableArray array];
        for (NSInteger i = 100; i < 120; i++) {
            WCDB_Message *msg = [[WCDB_Message alloc] init];
            msg.messageName = [@"yxx" stringByAppendingString:[NSString stringWithFormat:@"%ld", i]];
            msg.messageValue = (i + 10);
            msg.createDate = [NSDate date];
            [arr addObject:msg];
        }
        
        [service insertMessages:[arr copy]];
    });
}

@end
