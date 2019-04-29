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
#import "BinaryTree.h"

@implementation CommonUtils
- (void)dealloc
{
    NSLog(@"===CommonUtils Dealloc===");
}

+ (NSInteger)integerCeil:(NSInteger)value
{
    if (value == 0) {
        return value;
    }
    NSInteger divisor = value / 10;
    NSInteger remainder = value % 10;
    
    if (remainder <= 0) {
        return divisor * 10;
    } else {
        return (divisor + 1) * 10;
    }
}

+ (CGFloat)transitionValueWithPercent:(CGFloat)percent fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    return (fromValue + (toValue - fromValue) * percent);
}

+ (UIColor *)transitionColorWithPercent:(CGFloat)percent fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    CGFloat fromRed = 0.0, fromGreen = 0.0, fromBlue = 0.0, fromAlpha = 0.0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0.0, toGreen = 0.0, toBlue = 0.0, toAlpha = 0.0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat transitionRed = [self transitionValueWithPercent:percent fromValue:fromRed toValue:toRed];
    CGFloat transitionGreen = [self transitionValueWithPercent:percent fromValue:fromGreen toValue:toGreen];
    CGFloat transitionBlue = [self transitionValueWithPercent:percent fromValue:fromBlue toValue:toBlue];
    CGFloat transitionAlpha = [self transitionValueWithPercent:percent fromValue:fromAlpha toValue:toAlpha];
    return [UIColor colorWithRed:transitionRed green:transitionGreen blue:transitionBlue alpha:transitionAlpha];
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

+ (void)logInstanceMethodListForClass:(Class)className
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(className, &count);
    
    NSLog(@"==========begin==========");
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSString *selectorStr = NSStringFromSelector(selector);
        NSLog(@"selectorStr = %@", selectorStr);
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

+ (NSArray *)bubbleSort:(NSArray *)array
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:array];
    NSUInteger length = resultArray.count;
    for (NSInteger i = 0; i < length; i++) {
        for (NSInteger j = 0; j < length - 1 - i; j++) {
            if (resultArray[j] > resultArray[j + 1]) {
                // swap
                
            }
        }
    }
    
    return [resultArray copy];
}

/*
 将数组作为参数进行传递
 有两种传递方法，一种是function(int a[]); 另一种是function(int *a)
 这两种两种方法在函数中对数组参数的修改都会影响到实参本身的值
 
 对于第一种:
 形参是实参的一份拷贝，是局部变量。
 但是数组是个例外，因为数组的数据太多了，将其一一赋值既麻烦又浪费空间，所以数组作为参数传递给函数的只是数组首元素的地址，数据还是在内存里的，函数在需要用到后面元素时再按照这个地址和数组下标去内存查找。也就是说后面的元素根本没到函数里来
 
 这里也不能在函数内部用sizeof求数组的大小，必须在外面算好了再传进来
 
 对于第二种:
 则是传址调用
 */
// {5, 18, 8 , 12, 25};
void bubbleSort_C(int array[], int arrayLength)
{
    int swapFlag = 0;// 交换标记 (用于优化)
    for (int i = 0; i < arrayLength; i++) {// 控制内层循环次数
        for (int j = 0; j < arrayLength - 1 - i; j++) {
            if (array[j] > array[j + 1]) {// 最大的值放最后面
                int temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
                swapFlag = 1;
            }
        }
        
        if (swapFlag == 0) {// 一遍循环下来没有数据交换 表示已排序好
            break;
        } else {
            swapFlag = 0;
        }
    }
}

/*
1. 设数组内存放了n个待排数字，数组下标从1开始，到n结束。
2. i=1
3. 从数组的第i个元素开始到第n个元素，寻找最小的元素。（具体过程为:先设arr[i]为最小，逐一比较，若遇到比之小的则交换）
4. 将上一步找到的最小元素和第i位元素交换。
5. 如果i=n－1算法结束，否则回到第3步
 */
void selectionSort_C(int array[], int arrayLength)
{
    int min = 0;// min下标
    int temp = 0;
    for (int i = 0; i < arrayLength; i++) {
        min = i;
        
        for (int j = i + 1; j < arrayLength; j++) {
            if (array[min] > array[j]) {
                min = j;// 下标赋值
            }
        }
        
        // 交换
        if (min != i) {
            temp = array[min];
            array[min] = array[i];
            array[i] = temp;
        }
    }
}

/*
1. 从数列中挑出一个元素，称为 "基准"（pivot），
2. 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分割之后，该基准是它的最后位置。这个称为分割（partition）操作。
3. 递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。
 */
// O(nlogn)
void quickSort_C(int array[], int minIndex, int maxIndex)
{
    if (minIndex < maxIndex) {
        int midIndex = partition(array, minIndex, maxIndex);
        quickSort_C(array, minIndex, midIndex - 1);
        quickSort_C(array, midIndex + 1, maxIndex);
    }
}

// eg:length = 10, maxIndex = length - 1
int partition(int array[], int minIndex, int maxIndex)
{
    int pivot = array[maxIndex];// 最后个value为基准
    int index = minIndex - 1;
    int temp = 0;
    for (int j = minIndex; j < maxIndex; j++) {
        // array[j] > pivot的跳过
        if (array[j] < pivot) {
            temp = array[++index];// ++index是 > pivot的index
            array[index] = array[j];// j 是 < pivot的index
            array[j] = temp;
        }
    }
    
    // index为最后个minValue的index ++index即为大于pivot的第一个maxValue的index
    temp = array[++index];
    array[index] = array[maxIndex];
    array[maxIndex] = temp;
    // 这边的index即为pivot的index
    return index;
}

// 假设数据是按升序排序的，对于给定值x，从序列的中间位置开始比较，如果当前位置值等于x，则查找成功；若x小于当前位置值，则在数列的前半段 中查找；若x大于当前位置值则在数列的后半段中继续查找，直到找到为止。
// 采用二分法查找时，数据需是排好序的


// ========================================
+ (void)logBinaryTree
{
    BinaryTreeNode *rootNode = [BinaryTree createBinarySortTreeWithValues:@[@(50), @(25), @(75), @(28), @(10), @(8), @(12), @(30), @(60), @(80), @(100)]];
    
    
    NSMutableArray *traversalArray = [NSMutableArray array];
    // 前序 中序 后序
//    [BinaryTree preOrderTraversalTree:rootNode handler:^(BinaryTreeNode * _Nonnull node) {
//        [traversalArray addObject:@(node.value)];
//    }];
//    NSLog(@"preOrderTraversal: traversalArray = %@", traversalArray);
    
//    [BinaryTree inOrderTraversalTree:rootNode handler:^(BinaryTreeNode * _Nonnull node) {
//        [traversalArray addObject:@(node.value)];
//    }];
//    NSLog(@"inOrderTraversal: traversalArray = %@", traversalArray);
    
//    [BinaryTree postOrderTraversalTree:rootNode handler:^(BinaryTreeNode * _Nonnull node) {
//        [traversalArray addObject:@(node.value)];
//    }];
//    NSLog(@"postOrderTraversal: traversalArray = %@", traversalArray);
    
    // DFS
//    [BinaryTree DFSNonRecursiveTraversalTree:rootNode handler:^(BinaryTreeNode * _Nonnull node) {
//        [traversalArray addObject:@(node.value)];
//    }];
//    NSLog(@"DFSNonRecursiveTraversal: traversalArray = %@", traversalArray);
    
    [BinaryTree DFSRecursionTraversalTree:rootNode handler:^(BinaryTreeNode * _Nonnull node) {
        [traversalArray addObject:@(node.value)];
    }];
    NSLog(@"DFSRecursionTraversalTree: traversalArray = %@", traversalArray);
    
    // depth
//    NSLog(@"depth = %ld", [BinaryTree depthOfTree:rootNode]);
    
}

// ========================================


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

+ (void)logTimeZone:(NSTimeZone *)timeZone
{
    // 时区获取
    NSLog(@"systemTimeZone = %@ localTimeZone = %@ defaultTimeZone = %@", [NSTimeZone systemTimeZone], [NSTimeZone localTimeZone], [NSTimeZone defaultTimeZone]);
    // 时区名称和缩写
    NSLog(@"name = %@ abbreviation = %@ date_abbreviation = %@", timeZone.name, timeZone.abbreviation, [timeZone abbreviationForDate:[NSDate date]]);
    // 获取与零时区的间隔秒数
    NSInteger secondOffset = [timeZone secondsFromGMT];// 28800 = 8 * 60 * 60
    NSInteger date_secondOffset = [timeZone secondsFromGMTForDate:[NSDate date]];
    NSLog(@"secondOffset = %ld date_secondOffset = %ld", secondOffset, date_secondOffset);
    
    // 不建议用下面的方式获取本地时间
    // 在GMT时间基础上追加时间差值，得到本地时间
    NSDate *nowDate = [NSDate date];// 获取的是零时区的时间（格林尼治的时间: 年-月-日 时:分:秒: +时区）
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    NSDate *nowLocalDate = [nowDate dateByAddingTimeInterval:[systemTimeZone secondsFromGMT]];
    NSLog(@"nowDate = %@ nowLocalDate = %@", nowDate, nowLocalDate);
    CLog(@"nowDate = %@ nowLocalDate = %@", nowDate, nowLocalDate);
}

+ (void)logDate
{
    NSDate *nowDate = [NSDate date];
    NSLog(@"nowDate = %@", nowDate);
    
    // 时间戳
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    NSLog(@"timestamp = %lf", timestamp);
    
    // 北京时区时间
    NSDate *beijingDate = [nowDate dateByAddingTimeInterval:[NSTimeZone systemTimeZone].secondsFromGMT];
    NSLog(@"beijingDate = %@", beijingDate);
    
    // 未来的一个时间
    NSDate *futureDate = [NSDate distantFuture];
    NSLog(@"futureDate = %@", futureDate);
    
    // 远古的一个时间
    NSDate *pastDate = [NSDate distantPast];
    NSLog(@"pastDate = %@", pastDate);
    
    // 时间戳->date
    NSString *timestampStr = [NSString stringWithFormat:@"%d", (20 * 60 * 60)];
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:[timestampStr doubleValue]];
    NSLog(@"testDate = %@", testDate);
    
    // NSDateFormatter 设置 NSTimeZone
    // 设置时区
//    NSLog(@"abbreviationDictionary = %@", [NSTimeZone abbreviationDictionary]);
    NSTimeZone *timeZone1 = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSLog(@"knownTimeZoneNames = %@", [NSTimeZone knownTimeZoneNames]);
    NSTimeZone *timeZone2 = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone3 = [NSTimeZone timeZoneForSecondsFromGMT:28800];
    
    // dateStr->date
    NSDate *curDate = [NSDate date];
    NDLLog(@"curDate = %@", curDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *curStr = [formatter stringFromDate:curDate];
    NSLog(@"curStr = %@", curStr);// 8时区的时间
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];// 设置时区:0时区
    NSDate *zeroTimeZoneDate = [formatter dateFromString:curStr];
    NSLog(@"zeroTimeZoneDate = %@", zeroTimeZoneDate);
    
    // compare
    NSDate *oneDate = [NSDate date];
    NSDate *otherDate = [NSDate date];
    NSComparisonResult result = [oneDate compare:otherDate];
    if (result == NSOrderedSame) {
        NSLog(@"NSOrderedSame");
    } else if (result == NSOrderedAscending) {
        NSLog(@"NSOrderedAscending");
    } else if (result == NSOrderedDescending) {
        NSLog(@"NSOrderedDescending");
    }
}

+ (void)logCalendar
{
    NSCalendar *curCalendar = [NSCalendar currentCalendar];
    NSLog(@"calendarIdentifier = %@ timeZone = %@ localeIdentifier = %@", curCalendar.calendarIdentifier, curCalendar.timeZone, curCalendar.locale.localeIdentifier);// 通用-语言与地区-地区localeIdentifierlocaleIdentifier = en_US(美国) en_CN(中国)
    
    
}

+ (void)logLocal:(NSLocale *)local
{
    NSLocale *sysLocal = [NSLocale systemLocale];
    NSLog(@"sysLocal.localeIdentifier = %@", sysLocal.localeIdentifier);
    NSLocale *curLocal = [NSLocale currentLocale];
    NSLog(@"curLocal.localeIdentifier = %@", curLocal.localeIdentifier);
    NSLocale *autoupdatingCurrentLocale = [NSLocale autoupdatingCurrentLocale];
    NSLog(@"autoupdatingCurrentLocale.localeIdentifier = %@", autoupdatingCurrentLocale.localeIdentifier);
    
}

+ (void)testDate
{
    // DateTools
    NSDate *date = [NSDate date];// 06:35 UTC
    NSInteger hour = date.hour;// 6 + 8 = 14
    
    // 10-20 02:20 UTC
    NSDate *testDate = [NSDate dateWithYear:2018 month:10 day:20 hour:10 minute:20 second:30];
    NSInteger testhour = testDate.hour;// 10
    // 10-17 18:20 UTC
    NSDate *otherDate = [NSDate dateWithYear:2018 month:10 day:18 hour:2 minute:20 second:30];
    NSInteger delta = [testDate daysFrom:otherDate];// 2.x (天delta) = 2   1.x = 1
    
    NSInteger laterThanDay = [testDate daysLaterThan:otherDate];// 2
    double laterThanHour = [testDate hoursLaterThan:otherDate];// 56 = 48 + 8
    
    // log方式不同 显示不同
    NSLog(@"testDate: date = %@", testDate);// 10:20
    NSLog(@"testDate: str = %@", [NSString stringWithFormat:@"%@", testDate]);// 02:20
    
}

+ (void)testFont:(UIFont *)font
{
    // [UIFont fontWithName:@"PingFangSC-Semibold" size:28]
    
    // ascender:小写字体中超出x字母高度部分 descender:下行字母
    /*
     fontLabel.text = @"TextFont";
     label size = {118, 39.5}
     */
    
    /*
     fontLabel.text = @"测试字体";
     label size = {112, 39.5}
     */
    
    /*
     font.pointSize = 28.000000
     font.ascender = 29.680000
     font.descender = -9.520000
     font.capHeight = 24.080000
     font.xHeight = 16.800000
     font.lineHeight = 39.200000
     font.leading = 0.000000
     */
    NSLog(@"\nfont.pointSize = %lf\nfont.ascender = %lf\nfont.descender = %lf\nfont.capHeight = %lf\nfont.xHeight = %lf\nfont.lineHeight = %lf\nfont.leading = %lf", font.pointSize, font.ascender, font.descender, font.capHeight, font.xHeight, font.lineHeight, font.leading);
    
    // str size = {112, 39.200000000000003}
    NSLog(@"str size = %@", NSStringFromCGSize([@"测试字体" ndl_sizeForSingleLineStringWithFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:28]]));
}

@end
