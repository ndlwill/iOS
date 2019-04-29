//
//  ThreeDTouchViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/4/9.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "ThreeDTouchViewController.h"

@interface ThreeDTouchViewController ()

@end

@implementation ThreeDTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
}

#pragma mark - overrides
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"action1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"previewViewController = %@", previewViewController);
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"previewViewController = %@", previewViewController);
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"action3" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"previewViewController = %@", previewViewController);
    }];
    
    return @[action1, action2, action3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
