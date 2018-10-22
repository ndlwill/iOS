//
//  CommonUtils.m
//  NDL_Category
//
//  Created by ndl on 2017/10/18.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "CommonUtils.h"
#import <objc/runtime.h>
#import <AudioToolbox/AudioToolbox.h>

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation CommonUtils
- (void)dealloc
{
    NSLog(@"===CommonUtils Dealloc===");
}

+ (UIWindow *)keyboardWindow
{
    UIWindow *keyboardWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    BOOL isVersionIOS_9 = [[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0;
    
    // iOS9的系统中多了一个UIRemoteKeyboardWindow
    for (UIWindow *window in windows) {
        if (isVersionIOS_9) {
            NSLog(@">= iOS9.0");
            if ([NSStringFromClass([window class]) isEqualToString:@"UIRemoteKeyboardWindow"]) {
                keyboardWindow = window;
                break;
            }
        } else {
            NSLog(@"< iOS9.0");
            if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"]) {
                keyboardWindow = window;
                break;
            }
        }
    }
    return keyboardWindow;
}

+ (BOOL)haveExtensionInputMode
{
    NSArray<UITextInputMode *> *modes = [UITextInputMode activeInputModes];
    for (UITextInputMode *mode in modes) {
        if ([NSStringFromClass([mode class]) isEqualToString:@"UIKeyboardExtensionInputMode"]) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)onePixel
{
    return (1.0 / [UIScreen mainScreen].scale);
}

+ (void)logIvarListForClass:(Class)className
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(className, &count);
    
    NSLog(@"==========begin==========");
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString *objcName = [NSString stringWithUTF8String:name];
        
        const char * typeEncoding = ivar_getTypeEncoding(ivar);
        NSString* objcType = [NSString stringWithUTF8String:typeEncoding];
        NSLog(@"ivar_name = %@ ivar_typeEncoding = %@", objcName, objcType);
    }
    NSLog(@"==========end==========");
}

+ (void)logPropertyListForClass:(Class)className
{
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList(className, &count);
    
    NSLog(@"==========begin==========");
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char* name = property_getName(property);
        NSString *objcName = [NSString stringWithUTF8String:name];
        
        const char * attribute = property_getAttributes(property);
        NSString* objcAttribute = [NSString stringWithUTF8String:attribute];
        NSLog(@"property_name = %@ property_attribute = %@", objcName, objcAttribute);
    }
    NSLog(@"==========end==========");
}

+ (void)openAppSettingURL
{
    if (@available(iOS 8.0, *)) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if (@available(iOS 10.0, *)) {
            [Application openURL:settingURL options:@{} completionHandler:nil];
        } else {
            [Application openURL:settingURL];
        }
    }
}

+ (NSUInteger)totalDataCountsForScrollView:(UIScrollView *)scrollView
{
    NSUInteger totalCount = 0;
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        
        for (NSInteger i = 0; i < tableView.numberOfSections; i++) {
            totalCount += [tableView numberOfRowsInSection:i];
        }
    } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        
        for (NSInteger i = 0; i < collectionView.numberOfSections; i++) {
            totalCount += [collectionView numberOfItemsInSection:i];
        }
    }
    return totalCount;
}

+ (void)playCustomSoundWithPath:(NSString *)resourcePath
{
    SystemSoundID soundID = 0;
    if (resourcePath) {
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL URLWithString:resourcePath]), &soundID);
        if (status != kAudioServicesNoError) {
            NSLog(@"status = %d", status);
        }
    }
    // 声音和振动
    AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
        
    });
    
    // 声音
//    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
//        
//    });
}

+ (void)logStackInfo
{
    NDLLog(@"stack info = %@", [NSThread callStackSymbols]);
}

+ (void)testForSubTitles:(NSString *)subTitle,...NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *subTitleArray = [NSMutableArray array];
    va_list argumentList;
    
    NSString *paramTitle = @"";
    if (subTitle) {
        [subTitleArray addObject:subTitle];
        va_start(argumentList, subTitle);
        while ((paramTitle = va_arg(argumentList, id))) {
            [subTitleArray addObject:paramTitle];
        }
        va_end(argumentList);
    }
    NSLog(@"subTitles = %@", subTitleArray);
}

@end
