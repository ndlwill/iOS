//
//  ViewController.m
//  NDL_Category
//
//  Created by ndl on 2017/9/14.
//  Copyright © 2017年 ndl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "ChildObject.h"
#import "SystemInfo.h"
#import "TestLifeCircleController.h"
#import "UIView+NDLExtension.h"
#import "TestView.h"
#import "TestView1.h"
#import "LongPressLabel.h"
#import "NavController.h"
#import "GestureViewController.h"
#import "UINavigationBar+NDLExtension.h"
#import "Masonry.h"
#import <Photos/Photos.h>
#import <CoreText/CoreText.h>
#import "MyTableViewController.h"
#import "CustomViewController.h"
#import "TestTVViewController.h"
#import "NSArray+NDLExtension.h"
#import "TestRotateViewController.h"
#import "CommonDefines.h"
#import "NDLFloatLayoutView.h"
#import "NSString+NDLExtension.h"
#import "TestAVFoundationViewController.h"
#import "AutoSizingView.h"

#import "PieView.h"
#import "CommonUtils.h"
#import "PlaceholderTextView.h"
#import "TestLifeCircleAutoLayoutViewController.h"
#import "TestWCDBViewController.h"
#import "PopoverView.h"

#import "DrawUtils.h"
#import "Aspects.h"

#import "ArcToCircleLayer.h"

#import "UIImage+NDLExtension.h"

#import "LoadingView.h"
#import "PhotoCell.h"
#import "HorizontalLinearMiddleScaleLayout.h"
#import "TestTabBarController.h"

#import "TestXibView.h"
#import "TextStrokeLabel.h"

#import "RedEnvelopeLoadingView.h"
#import "AlipayPaymentAnimationView.h"

#import "SpeechRecognitionAnimationView.h"
#import "AlipayPaymentSuccessAnimationView.h"

#import "FirstViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

#import <CommonCrypto/CommonCryptor.h>

#import "NSString+NDLSecurity.h"

#import "OpenUDID.h"

#import <AdSupport/AdSupport.h>

#import "TestModel.h"

#import <objc/runtime.h>

//#import <DrawLib/DrawLib.h>
#import <DrawLib.h>

#import "NDLLabel.h"
#import "UIView+NDLTapGesture.h"

#import "MarqueeLabel.h"

#import "WaveView.h"
#import "TieBaLoadingView.h"

#import "BounceView.h"
#import <PinYin4Objc.h>

#import "YouKuPlayButton.h"

#import "Book.h"

#import "SQLiteManager.h"

#import "PersonAll.pbobjc.h"

#import "NSDate+NDLExtension.h"
#import <CoreLocation/CoreLocation.h>

#import "UIApplication+NDLExtension.h"

#import "TestNavBarAlphaViewController.h"
#import "BaseNavigationController.h"

#import "NSData+NDLExtension.h"

#import <CoreML/CoreML.h>
#import "HomeTranViewController.h"

#import "TestMaskView.h"
#import "TestBubbleView.h"

// iOS4.0-iOS10.0
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
// iOS10.0
#import <CallKit/CallKit.h>

#import "LocalNotificationUtils.h"

#import "TestPresentViewController.h"

#import "NextRootViewController.h"

#import "ThreeDTouchViewController.h"
#import "InterviewViewController.h"

#import "TestOpenGLESViewController.h"
#import "OpenGLES1Controller.h"
#import "OpenGLES2Controller.h"
#import "CCViewController.h"

#import "NDL_Category-Swift.h"

typedef id (^WeakReference)(void);

// TODO: Import
@interface ViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ABPeoplePickerNavigationControllerDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate, UIViewControllerPreviewingDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) UIView *touchView;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, weak) UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet NDLFloatLayoutView *floatLayoutView;


@property (nonatomic, strong) UILabel *testView;

@property (nonatomic, strong) NDLFloatLayoutView *floatView;

@property (nonatomic, strong) AutoSizingView *v;

@property (nonatomic, strong) PlaceholderTextView *placeholderTextView;

@property (nonatomic, strong) PopoverView *popoverView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomViewLeft;
@property (nonatomic, strong) NSMutableArray *bottomViews;

@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) TestXibView *xibView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) RedEnvelopeLoadingView *redView;
@property (nonatomic, weak) AlipayPaymentAnimationView *alipayView;

@property (nonatomic, weak) Person *testPerson;

@property (nonatomic, weak) Person *p_ndl;
@property (nonatomic, strong) NSMutableDictionary *p_dic;

@property (nonatomic, strong) Book *bookModel;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, weak) id<UIViewControllerPreviewing> previewingContext;

@property (nonatomic, strong) BaseObject *baseObj;
@property (nonatomic, strong) ChildObject *childObj;

@end

static NSInteger cc = 0;

static NSDateFormatter *dateFormatter_ = nil;

@implementation ViewController


- (NSMutableDictionary *)p_dic
{
    if (!_p_dic) {
        _p_dic = [NSMutableDictionary dictionary];
    }
    return _p_dic;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"didUpdateLocations");
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    // CFTypeRef : Base "type" of all "CF objects"
    
//    如果是多重属性，那么ABRecordCopyValue函数返回的就是ABMultiValueRef类型的数据
    
//    ABRecordCopyValue(<#ABRecordRef record#>, <#ABPropertyID property#>)
    
    /*
     // 取电话号码
     ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
     // 取记录数量
     NSInteger phoneCount = ABMultiValueGetCount(phones);
     // 遍历所有的电话号码
     for (NSInteger i = 0; i < phoneCount; i++) {...}
     获取多重属性的方法
     // 电话标签
     CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
     // 本地化电话标签
     CFStringRef phoneLocalLabel = ABAddressBookCopyLocalizedLabel(phoneLabel);
     // 电话号码
     CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phones, i);
     */
    
    /*
     CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
     NSString *lastNameStr = (__bridge NSString *)(lastName);
     CFRelease(lastName); // 使用__bridge type 方法记得释放！
     */
    
    /*
     // 获取电话，电话是多数据类型
     ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
     // 获取电话的个数
     CFIndex count = ABMultiValueGetCount(phones);
     // 遍历联系人，取出每个电话标签和电话号码，CF框架必须用for i循环
     for (CFIndex i = 0 ; i < count; i++) {
     // 获取联系电话的标签，使用__bridge_transfer方法不用释放  CF->Foundation
     NSString *label = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones,  i);
     NSLog(@"label: %@",label);
     // 获取联系电话，使用CFBridgingRelease方法和上面功能一样也不需要释放
     NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones,  i));
     NSLog(@"value: %@",value);
     }
     //phones 对象需要被释放
     CFRelease(phones);
     */
}
/*
 该方法可以获取具体的哪个电话号码，例如使用充值话费时不能使用上面方法，因为无法确定具体充值哪个号码
 - (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0);
 */

/*
 不需要弹出联系人控制器就可以获取联系人信息的方法
 #pragma mark - 点击屏幕获取所有联系人信息，记得授权
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 //1. 判断是否授权成功, 授权成功才能获取数据
 if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
 //2. 创建通讯录
 ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
 //3. 获取所有联系人
 CFArrayRef peosons = ABAddressBookCopyArrayOfAllPeople(addressBook);
 //4. 遍历所有联系人来获取数据(姓名和电话)
 CFIndex count = CFArrayGetCount(peosons);
 for (CFIndex i = 0 ; i < count; i++) {
 //5. 获取单个联系人
 ABRecordRef person = CFArrayGetValueAtIndex(peosons, i);
 //6. 获取姓名
 NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
 NSString *firstName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
 NSLog(@"lastName: %@, firstName: %@", lastName, firstName);
 //7. 获取电话
 ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
 //7.1 获取电话的count数
 CFIndex phoneCount = ABMultiValueGetCount(phones);
 //7.2 遍历所有电话号码
 for (CFIndex i = 0; i < phoneCount; i++) {
 NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
 NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
 // 打印标签和电话号
 NSLog(@"label: %@, value: %@",label, value);
 }
 NSLog(@"\\n\\n");
 //8.1 释放 CF 对象
 CFRelease(phones);
 }
 //8.1 释放 CF 对象
 CFRelease(peosons);
 CFRelease(addressBook);
 }
 }
 */

- (PopoverView *)popoverView
{
    if (!_popoverView) {
        CGFloat popoverViewHeight = 114 + kBigCircleRadius + 2 * kSmallCircleRadius;
        CGFloat popoverViewY =  _bottomView.y - popoverViewHeight;
        
        CGFloat referenceViewRightPointX = _bottomView.x - 25 + _bottomView.width;
        
        _popoverView = [[PopoverView alloc] initWithFrame:CGRectMake(25, popoverViewY, self.view.width - 50, popoverViewHeight) superViewRightPointX:referenceViewRightPointX titles:@[@"加个鸡腿", @"给他加油", @"健康基金"] subTitles:@[@"¥3", @"¥5", @"¥10"] images:@[@"鸡腿.png", @"加油.png", @"基金.png"]];
        [self.view addSubview:_popoverView];
        
        
        //
//        CGFloat bigCircleCenterX = referenceViewRightPointX + 2 * kSmallCircleRadius + kBigCircleRadius;
//        CGFloat anchorX = bigCircleCenterX / _popoverView.width;
//        _popoverView.layer.anchorPoint = CGPointMake(anchorX, 0.5);
//        _popoverView.layer.position = CGPointMake(25 + bigCircleCenterX, popoverViewY + _popoverView.size.height * 0.5);
        
        // anchor(1,1)
//        _popoverView.layer.anchorPoint = CGPointMake(1, 1);
//        _popoverView.layer.position = CGPointMake(25 + _popoverView.width, _bottomView.y);
        
        // 大圆
//        CGFloat bigCircleCenterX = referenceViewRightPointX + 2 * kSmallCircleRadius + kBigCircleRadius;
//        CGFloat anchorX = bigCircleCenterX / _popoverView.width;
//        _popoverView.layer.anchorPoint = CGPointMake(anchorX, 1);
//        _popoverView.layer.position = CGPointMake(25 + bigCircleCenterX, _bottomView.y);
        
        // 小圆
        CGFloat smallCircleCenterX = referenceViewRightPointX + kSmallCircleRadius;
        CGFloat anchorX = smallCircleCenterX / _popoverView.width;
        _popoverView.layer.anchorPoint = CGPointMake(anchorX, 1);
        _popoverView.layer.position = CGPointMake(25 + smallCircleCenterX, _bottomView.y);
    }
    return _popoverView;
}

-(void)earthquake:(UIView*)itemView
{
    CGFloat t =2.0;
    
    CGAffineTransform leftQuake  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,-t);
    CGAffineTransform rightQuake =CGAffineTransformTranslate(CGAffineTransformIdentity,-t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];// important更平滑
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.07];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake;// end here & auto-reverse
    
    [UIView commitAnimations];
}

- (NSString* )disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

// TODO:viewWillLayoutSubviews
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"===viewWillLayoutSubviews===");
//    NSLog(@"viewWillLayoutSubviews button Frame = %@", NSStringFromCGRect(self.rightButton.frame));
//    self.xibView.width = NDLScreenW;
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
}

- (void)timeCallback
{
    cc++;
//    NSLog(@"###===NStimer: timeCallback=%ld==##########", cc);
    
//    if (cc == 15) {
//        [self.view setNeedsLayout];
//    }
}

//
- (NSString *)convertSimpleUnicodeStr:(NSString *)str{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"U+" withString:@""];
    unsigned long  unicodeIntValue= strtoul([strUrl UTF8String],0,16);
//       UTF32Char inputChar = unicodeIntValue ;// 变成utf32
    unsigned long inputChar = unicodeIntValue ;// 变成utf32
    //    inputChar = NSSwapHostIntToLittle(inputChar); // 转换成Little 如果需要
    inputChar = NSSwapHostLongToLittle(inputChar); // 转换成Little 如果需要
    NSString *sendStr = [[NSString alloc] initWithBytes:&inputChar length:4 encoding:NSUTF32LittleEndianStringEncoding];
    return sendStr;
}
// TODO:right button clicked
- (IBAction)rightButtonClicked:(UIButton *)sender {
    NSLog(@"===person = %@", self.testPerson);
    
    [self.redView startAnimation];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        // pause
        [self.timer setFireDate:[NSDate distantFuture]];
        
        [self.alipayView pauseAnimation];
    } else {
        [self.timer setFireDate:[NSDate distantPast]];
//        [self.timer setFireDate:[NSDate date]];
        
        [self.alipayView resumeAnimation];
    }
    
    [self presentViewController:[FirstViewController new] animated:YES completion:nil];
}
// TODO:testNavBarAlpha
- (IBAction)presentNavVC:(id)sender {
    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[TestNavBarAlphaViewController new]] animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif
    
    NSLog(@"===Home viewDidAppear p_ndl = %@ dic_ndl = %@", self.p_ndl, [self.p_dic objectForKey:@"ndl"]);
    
}


// =====弱=====
WeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id weakReferenceNonretainedObjectValue(WeakReference ref) {
    return ref ? ref() : nil;
}

//==================================================protobuf
// 解决读取每条数据的头部字节，根据头部字节读取这条数据的内容长度
/** 关键代码：获取data数据的内容长度和头部长度: index --> 头部占用长度 (头部占用长度1-4个字节) */
- (int32_t)getContentLength:(NSData *)data withHeadLength:(int32_t *)index{
    
    int8_t tmp = [self readRawByte:data headIndex:index];
    
    if (tmp >= 0) return tmp;
    
    int32_t result = tmp & 0x7f;
    if ((tmp = [self readRawByte:data headIndex:index]) >= 0) {
        result |= tmp << 7;
    } else {
        result |= (tmp & 0x7f) << 7;
        if ((tmp = [self readRawByte:data headIndex:index]) >= 0) {
            result |= tmp << 14;
        } else {
            result |= (tmp & 0x7f) << 14;
            if ((tmp = [self readRawByte:data headIndex:index]) >= 0) {
                result |= tmp << 21;
            } else {
                result |= (tmp & 0x7f) << 21;
                result |= (tmp = [self readRawByte:data headIndex:index]) << 28;
                if (tmp < 0) {
                    for (int i = 0; i < 5; i++) {
                        if ([self readRawByte:data headIndex:index] >= 0) {
                            return result;
                        }
                    }
                    
                    result = -1;
                }
            }
        }
    }
    return result;
}


/** 读取字节 */
- (int8_t)readRawByte:(NSData *)data headIndex:(int32_t *)index{
    
    if (*index >= data.length) return -1;
    
    *index = *index + 1;
    
    return ((int8_t *)data.bytes)[*index - 1];
}

//==================================================

- (void)currentLocaleDidChanged:(NSNotification *)notification
{
    NSLog(@"currentLocaleDidChanged");
}

- (NSDate *)dateFromTime:(int)year setMonth:(int)month setDay:(int)day setHour:(int)hour setMinute:(int)minute
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:00];
    
    NSDate *date = [calendar dateFromComponents:dateComps];
    
    return date;
}

- (void)testArr:(NSMutableArray *)arr
{
    arr[0] = @(100);// 这边改变，实参也会改变
}
- (IBAction)tranBtnClicked:(id)sender {
    
    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[HomeTranViewController alloc] init]] animated:YES completion:nil];
}

- (void)viewDidLoad {
    Person *person111 = nil;
    NSLog(@"age = %ld", person111.age);// 0
    
    Person *person222 = [[Person alloc] init];
    NSLog(@"age = %ld", person222.age);// 0
    
    [self aspect_hookSelector:@selector(testHook) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        NSLog(@"###ViewController After testHook###");
    } error:nil];
    
    NSLog(@"===ViewController viewDidLoad===");
    NSLog(@"date = %@ ceil = %lf", [NSDate date], ceil(6.3));// 7.0
    
#pragma mark - crash
    // ###crash###
    //-[__NSPlaceholderDictionary initWithObjects:forKeys:count:]
    // 字典初始化:这种初始化方式value为nil会崩溃，数组同理
//    NSString *value111 = nil;
//    NSDictionary *crashDic = @{@"key": value111};
    
    // 升序排序
    int array[5] = {5, 18, 8 , 12, 25};
    //    array[0] = 100;// 能修改
    int length = sizeof(array) / sizeof(int);
//    bubbleSort_C(array, length);
//    selectionSort_C(array, length);
    insertionSort_C(array, length);
//    quickSort_C(array, 0, length - 1);
    for (int i = 0; i < length; i++) {
        printf("%d\n", array[i]);
    }
    
    
    // 1
    NSLog(@"cur = %@", [NSThread currentThread]);// main
    // 2
    dispatch_sync(dispatch_queue_create("serial1", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"sync-ser = %@", [NSThread currentThread]);// main
    });
    // 4
    dispatch_async(dispatch_queue_create("serial2", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"async-ser = %@", [NSThread currentThread]);// new thread
    });
    // 3
    NSLog(@"thread end");
    
    
    NSLog(@"test set target");
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    dispatch_async(queue1, ^{
        NSLog(@"1 in");
        [NSThread sleepForTimeInterval:8.f];
        NSLog(@"1 out");
    });
    dispatch_async(queue2, ^{
        NSLog(@"2 in");
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"2 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"3 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3 out");
    });
    
    // location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    
    NSLog(@"date = %@ ndl_date = %@", [NSDate date], [NSDate ndl_currentDate]);
    
    // gregorian
    NSLog(@"calendarIdentifier = %@", [[NSDateFormatter alloc] init].calendar.calendarIdentifier);

    // test dateTools
    // second:满60自己进minute
    NSLog(@"date from calendar = %@", [NSDate dateWithYear:2018 month:10 day:30 hour:12 minute:58 second:126]);
    NSDate *ddate = [NSDate date];
    NSLog(@"NSdate = %@", ddate);
    // weekend:(1表示周日) 周日是1 周一2 。。。。。7
    // weekdayOrdinal: 周六是1 。。。。。7
    NSLog(@"weekday = %ld, weekdayOrdinal = %ld", [ddate weekday], [ddate weekdayOrdinal]);// Wed Oct 31 14:41:46 2018 打印(4, 5)
    
    
//    NSDate *curDate = [NSDate date];// 0时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSTimeInterval interval = [zone secondsFromGMTForDate:curDate];
//    NSDate *correctDate = [curDate dateByAddingTimeInterval:interval];// b东8区date
//    NSLog(@"curDate = %@ correctDate = %@", curDate, correctDate);
    
    
    // yyyy-MM-dd HH:mm:ss
    NSDate *customDate = [NSDate dateWithString:@"2018-3-8 00:25" format:@"yyyy-MM-dd HH:mm"];
    NSLog(@"customDate = %@", customDate);
    NSLog(@"dayInMonth = %ld", [[NSDate date] daysInMonth]);// 2018-10-26 -> 31
    
    
    dateFormatter_ = [[NSDateFormatter alloc] init];
    NSLocale *dateFormatterLocale = dateFormatter_.locale;
    NSLog(@"%@", dateFormatterLocale.localeIdentifier);// 默认系统locale
    
    // 监听用户本地化的设置信息
    [NotificationCenter addObserver:self selector:@selector(currentLocaleDidChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    
    // 获取当前系统设置语言的标识符
    NSLocale *locale = [NSLocale currentLocale];
    // 这些标识符包含一个语言码（例如en代表英语）和一个地区码（例如US代表美国）
    NSLog(@"localeIdentifier = %@", locale.localeIdentifier);// 模拟器默认en_US （中文en_CN）
    
    SQLiteManager *sqliteManager = [SQLiteManager sharedSQLiteManager];
    [sqliteManager openDB:@"test.sqlite"];
    
//    StartTime
//    for (NSInteger i = 0; i < 1000; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *text = [NSString stringWithFormat:@"NO-%ld", i];
//            [sqliteManager insertWithSQL:@"INSERT INTO t_test (testID, testText) VALUES (?, ?);" valueArray:@[@(i), text]];
//        });
////        NSString *text = [NSString stringWithFormat:@"NO-%ld", i];
////        [sqliteManager insertWithSQL:@"INSERT INTO t_test (testID, testText) VALUES (?, ?);" valueArray:@[@(i), text]];
//    }
//    EndTime
    
    // test str
//    NSString *str1 = @"123";
//    NSString *str2 = [NSString stringWithFormat:@"123"];
//
//    NSLog(@"str1 = %p str2 = %p", str1, str2);// 地址不一样
//
//    if (str1 == str2) {
//        NSLog(@"str1 == str2");// 不走
//    }
//
//    if ([str1 isEqual:str2]) {
//        NSLog(@"str1 isEqual:str2");// 走
//    }
    
    NSDictionary *json = @{
                       @"id": @(1),
                       @"name": @"jojo",
                       @"email": @"123@qq.com",
                       };
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSLog(@"data = %@ length = %ld", data, data.length);
    
    Person *p_ndl = [[Person alloc] init];
    self.p_ndl = p_ndl;// 弱引用
    NSLog(@"p_ndl = %@", self.p_ndl);
    [self.p_dic setObject:self.p_ndl forKey:@"ndl"];// 强引用了self.p_ndl
    
    NSLog(@"==========protobuf============");
    // protobuf
    PersonAll *pAll = [[PersonAll alloc] init];
    pAll.id_p = 1;
    pAll.name = @"personAll";
    pAll.email = @"ndl@126.com";
    NSLog(@"person = %@", pAll);
    // encode
    NSData *pAllData = [pAll data];
    NSLog(@"data = %@ length = %lu", pAllData, pAllData.length);
    // decode
    PersonAll *newPAll = [[PersonAll alloc] initWithData:pAllData error:nil];
    NSLog(@"decode = %@", newPAll);
    
    NSLog(@"==========test data==========");
    NSString *testStr = @"我们是test的定西 哈哈呀666";
    NSData *testData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"testData = %@ testDataLen = %ld", testData, testData.length);
    
    Byte *testByte = (Byte *)testData.bytes;
    NSLog(@"testByte = %s###", testByte);
    
    // imageData
    NSData *imageData = [NSData dataWithContentsOfFile:[MainBundle pathForResource:@"girl" ofType:@"jpeg"]];
    NSUInteger imageDataLen = imageData.length;
    NSLog(@"=====imageDataLen = %lu=====", imageDataLen);
//    NSString *dataStr = [imageData ndl_convertData2StrWithSpliceStr:@"-"];
//    NSString *dataHexStr = [imageData ndl_convertData2HexStr];
    
    // test scanner
//    NSScanner *scanner = [NSScanner scannerWithString:@"ff"];// 0xff也行
//    unsigned int hexInt = 0;
//    [scanner scanHexInt:&hexInt];
//    NSLog(@"hexInt = %u", hexInt);// 255
    
    NSLog(@"%ld", [@"0023400" integerValue]);// 23400
    NSLog(@"%@-%@", [NSString ndl_binaryStringFromDecimalSystemValue:7], [NSString ndl_binaryStringFromDecimalSystemValue:32]);
    
    // =============================
    //    int32_t headL = 0;
    //    int32_t contentL = [self getContentLength:imageData withHeadLength:&headL];
    //    NSLog(@"headL = %d contentL = %d", headL, contentL);
    
    // fileMD5
//    YYFileHash *fileHash = [YYFileHash hashForFile:[MainBundle pathForResource:@"girl" ofType:@"jpeg"] types:YYFileHashTypeMD5 | YYFileHashTypeSHA1];
//    // md5:6da4f34633a60b6b6499e2a97b333b38
//    NSLog(@"md5:%@ | sha1:%@", fileHash.md5String, fileHash.sha1String);
//    // md5:6da4f34633a60b6b6499e2a97b333b38
//    NSLog(@"md5:%@", [NSString ndl_fileMD5WithFilePath:[MainBundle pathForResource:@"girl" ofType:@"jpeg"]]);
    
//    int32_t headL = 0;
//    int32_t contentL = [self getContentLength:imageData withHeadLength:&headL];
//    NSLog(@"headL = %d contentL = %d", headL, contentL);
    
    
    // =====format=====
    NSInteger testLong = 6;
    NSString *string = [NSString stringWithFormat:@"%03ld",testLong];
    NSLog(@"%@", string);
    NSLog(@"%@",[NSString stringWithFormat:@"这个字符串要拼接百分号-%%"]);
    
    NSLog(@"%@",[NSString stringWithFormat:@"双引号的转义字符-\""]);
    NSLog(@"%@",[NSString stringWithFormat:@"反斜杠的转义字符-\\"]);
    /*
     %x, %X 16进制整数
     %o 八进制整数
     %zu size_t
     %p 指针
     %s C 字符串
     %c 字符
     %C unichar
     %lld 64位长整数（long long）
     %llu 无符64位长整数
     */
    
    
//    SInt8
//    uint8_t // typedef unsigned char uint8_t;
//    uint32_t
    // typedef unsigned char                   UInt8;
//    int32_t value = 17;// 0x00000011
    int32_t value = (int32_t)imageData.length;// 46526
    
    Byte *byteArray = NULL;
    NSLog(@"sizeof byte = %ld", sizeof(Byte));// 1
    byteArray = (Byte *)calloc(4, sizeof(Byte));
    if (byteArray != NULL) {
        byteArray[0] = (Byte)((value & 0xFF000000) >> 24);// 值为hex
        byteArray[1] = (Byte)((value & 0x00FF0000) >> 16);
        byteArray[2] = (Byte)((value & 0x0000FF00) >> 8);
        byteArray[3] = (Byte)(value & 0x000000FF);
        // NSLog(@"NSIntegerMax = %ld NSUIntegerMax = %lu", NSIntegerMax, NSUIntegerMax);
        // hex（16进制） -> 10进制 -> 2进制
        // ff -> 255 -> 11111111
        NSLog(@"byte1 = %d byte2 = %d byte3 = %d byte4 = %d", byteArray[0], byteArray[1], byteArray[2], byteArray[3]);// 10进制 0,0,181,190
        NSLog(@"byte1 = %o byte2 = %o byte3 = %o byte4 = %o", byteArray[0], byteArray[1], byteArray[2], byteArray[3]);// 8进制 0,0,265,276
        NSLog(@"byte1 = %x byte2 = %x byte3 = %x byte4 = %x", byteArray[0], byteArray[1], byteArray[2], byteArray[3]);// 每个字节是0,0,b5,be(16进制) -> 0000b5be
    }
    
    // ###
    NSInteger byte2Integer = byteArray[2];
    NSLog(@"byte2Integer = %ld", byte2Integer);// 181
    
    free(byteArray);
    
//    NSLog(@"16jinzhi = %@", [NSString ndl_hexStringFromDecimalSystemValue:102]);
    
    
//    UIBarButtonItem
//    UIBarItem
    
    NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableWeakMemory];
    [mapTable setObject:@"123" forKey:@"name"];
    [mapTable setObject:@"234" forKey:@"age"];
    
    NSEnumerator *keys = [mapTable keyEnumerator];
    
    id keyObj = [keys nextObject];
    if (keyObj) {
        NSLog(@"keys nextObject = %@", keyObj);
    }
    
    [[UIButton buttonWithType:UIButtonTypeCustom] ndl_performSelector:@selector(setTitleColor:forState:) withObjects:@[[UIColor redColor], @(UIControlStateNormal)]];
    
    
#warning TODO_MORE
    // 后面转义
    NSLog(@"%@---%@", @"-Warc-performSelector-leaks", @"\"-Warc-performSelector-leaks\"");
    
    NSInteger ii = 13;
    NSInteger oo = ii;
    ii = 23;
    NSLog(@"oo = %ld", oo);// 13
    
    NSNumber *intNumber = [NSNumber numberWithInteger:20];
    NSNumber *other = intNumber;
    intNumber = [NSNumber numberWithInteger:40];
    NSLog(@"other = %@", other);// 20
    
    NSString *sss = [NSString stringWithFormat:@"123"];
    NSString *oSS = sss;
    sss = [NSString stringWithFormat:@"123df"];
    NSLog(@"oSS = %@", oSS);// 123
//    NSLog(@"intNumber = %@", [intNumber description]);
    
    Book *book = [[Book alloc] init];
    book.title = @"234";
    Book *otherBook = book;
    book = [[Book alloc] init];
    book.title = @"sdf";
    NSLog(@"otherBook = %@ title = %@ book = %@", otherBook, otherBook.title, book);// 234 两个对象不同
    
    if ([@"" ndl_isWholeDigit]) {
        NSLog(@"ndl_isWholeCN");
    } else {
        NSLog(@"no ndl_isWholeCN");
    }
    
    
    for (int i = 0; i < 10; i++) {
        StartTime
        NSString *hanziText = @"我是汉字";
        if ([hanziText length]) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                NSLog(@"pinyin: #%@#", ms);
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                NSLog(@"pinyin: #%@#", ms);
            }
        }
        EndTime
    }
    
    
//    StartTime
//    NSString *sourceText=@"我是汉字";
//    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
//    [outputFormat setToneType:ToneTypeWithoutTone];// ToneTypeWithoutTone
//    [outputFormat setVCharType:VCharTypeWithV];
//    [outputFormat setCaseType:CaseTypeLowercase];
//    [PinyinHelper toHanyuPinyinStringWithNSString:sourceText
//                      withHanyuPinyinOutputFormat:outputFormat
//                                     withNSString:@" "
//                                      outputBlock:^(NSString *pinYin) {
//                                          NSLog(@"pinYin = %@", pinYin);
//                                          EndTime
//                                      }];// 0.0008
    
    
    
    SEL sel = @selector(viewDidLoad);
    NSLog(@"sel = %s", sel);
    
    NSLog(@"encode = %s", @encode(void));// 返回 v
//    [[NSObject alloc] init];
    // 不需要import
    Class testClass = NSClassFromString(@"TestRuntime");
    NSObject *obj = [[testClass alloc] init];
    SEL selector = NSSelectorFromString(@"logRuntime");
    if ([obj respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [obj performSelector:selector withObject:nil];
#pragma clang diagnostic pop
    }
    
    
    if (class_isMetaClass([ViewController class])) {
        NSLog(@"YES###");
    } else {
        NSLog(@"NO###");//
    }
    
    Class class = [ViewController class];//
    if (class_isMetaClass(object_getClass(class))) {// 类对象的类是元类
        NSLog(@"object_getClassYES###");//
    } else {
        NSLog(@"object_getClassNO###");
    }
    
    NSLog(@"实例对象的类 = %@", object_getClass(self));// Class = ViewController
    if (class_isMetaClass(object_getClass(self))) {// 实例对象的类是ViewController
        NSLog(@"selfYES###");
    } else {
        NSLog(@"selfNO###");//
    }

    
    NSLog(@"pathComp = %@", [@"http:///www.baidu.com/:user/name我们" pathComponents]);
    TestModel *model = [[TestModel alloc] init];
    [model publicMethod:@"我们"];
    
    [CommonUtils logIvarListForClass:[UINavigationItem class]];
    [CommonUtils logPropertyListForClass:[UINavigationItem class]];
    NSString *message = @"wjhgfk";
    NSLog(@"message = %@", message ? : @"123ws");
    
    NSLog(@"YYkit = %@ === %@", App_Bundle_Version,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]);
    
    NSLog(@"IDFA = %@ IDFV = %@", [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString, [[UIDevice currentDevice].identifierForVendor UUIDString]);
    
    // 每次运行都会发生变化，最理想的就是保存在keychain里面，以此作为标识用户设备的唯一标识符
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSLog(@"uuidStr = %@", uuidStr);
    
    NSString *udid = [OpenUDID value];
    NSLog(@"openUDID = %@ count = %ld", udid, udid.length);// 40
    [@"wohgei76s1" ndl_aes128Encrypt];
    
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        NSLog(@"thread = %@", [NSThread currentThread]);
//    }];
    
//    CCCryptorStatus
//    char pKey[kCCKeySizeAES128 + 1];// 使用 null 字符 '\0' 终止
//    bzero(pKey, sizeof(pKey));
//    NSString *key = @"1234567812345678";
//
//    NSLog(@"key bytes = %ld value = %s", sizeof(key.UTF8String), key.UTF8String);
//    NSLog(@"key bytes utf8= %ld", sizeof([key cStringUsingEncoding:NSUTF8StringEncoding]));
//    NSLog(@"key bytes ascii= %ld", sizeof([key cStringUsingEncoding:NSASCIIStringEncoding]));
//
//    if ([key getCString:pKey maxLength:sizeof(pKey) encoding:NSUTF8StringEncoding]) {//
//        NSLog(@"YES leng = %ld key = %s", sizeof(pKey), pKey);
//    } else {
//        NSLog(@"NO leng = %ld key = %s", sizeof(pKey), pKey);
//    }
    
//    char greeting[13] = "Hello";
//    NSLog(@"bytes = %ld len = %ld", sizeof(greeting), strlen(greeting));// 13 , 5
    
//    char greeting[13];
//    greeting[0] = 's';
//    NSLog(@"grre = %s", greeting);

    
    
    NSLog(@"===view controller view did load %@===", NSStringFromUIEdgeInsets(self.view.extraTouchInset));
    
    // https://www.jianshu.com/p/e6b7cb1eca9e
    // 通讯录
//    ABPeoplePickerNavigationController *peoplePickerNavVC = [[ABPeoplePickerNavigationController alloc] init];
//    peoplePickerNavVC.peoplePickerDelegate = self;
//    peoplePickerNavVC.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:NO];// 不自动dismiss选择控制器
    
    CNContactPickerViewController *contactPickerVC = [[CNContactPickerViewController alloc] init];
    /*
     // 2. 设置代理
     picker.delegate = self;
     // 3. 设置相关属性，谓词筛选email地址是@mac.com的联系人
     picker.predicateForSelectionOfProperty = [NSPredicate predicateWithFormat:@"(key == 'emailAddresses') AND (value LIKE '*@mac.com')"];
     / / 谓词筛选email地址数等于1的联系人
     picker.predicateForSelectionOfContact = [NSPredicate predicateWithFormat:@"emailAddresses.@count == 1"];
     // 4. 弹出
     [self presentViewController: picker  animated:YES completion:nil];
     */
    
    
    NSLog(@"%@", NSStringFromCGRect(CGRectInset(CGRectMake(0, 0, 100, 100), 0, 10)));

    self.testPerson = [Person personWithName:@"ndl" age:20];
    NSLog(@"person = %@", self.testPerson);
    
    /*
    🤨
Unicode: U+1F928，UTF-8: F0 9F A4 A8
     \ud83e\udd28
     */
    
//    NSLog(@"%@", [self convertSimpleUnicodeStr:@"U+6211"]);

//    NSLog(@"%@", [@"我门" ndl_emojiStringEncoding]);// \u6211\u95e8
    NSLog(@"%.2f", 11.2345);
    
    
    // applicationWillResignActive // 来电话
    // applicationDidBecomeActive // 挂电话
    // vc消失的时候 self.callCenter = nil
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
        NSLog(@"callID = %@", call.callID);
        NSString *state = call.callState;
        if ([state isEqualToString:CTCallStateDisconnected]) {
            NSLog(@"CTCallStateDisconnected");// 挂电话（移除系统电话UI）
        } else if ([state isEqualToString:CTCallStateConnected]) {
            NSLog(@"CTCallStateConnected");// 接电话
        } else if ([state isEqualToString:CTCallStateIncoming]) {
            NSLog(@"CTCallStateIncoming");// 来电话（显示系统电话UI）
        } else if ([state isEqualToString:CTCallStateDialing]) {
            NSLog(@"CTCallStateDialing");// 打电话
        }
    };
    
    // 退到后台还会执行
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCallback) userInfo:nil repeats:YES];
    // 必须添加到runloop
//    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeCallback) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    /*
     Causes the receiver’s message to be sent to its target// 立即执行
     If the timer is non-repeating, it is automatically invalidated after firing
     */
//    [timer fire];// 立即执行
    
//    [NSArray arrayWithObject:@""];
    NSArray *arrr = [NSArray arrayWithObject:@""];
    if ([arrr isEqual:@""]) {
        NSLog(@" arr 123");
    } else {
        NSLog(@" arr 234");
    }
    
    
    Person *p = [[Person alloc] init];
    p.name = @"nick";
    p.age = 20;
    NSLog(@"dic = %@", [p ndl_model2Dictionary]);
    
    NSLog(@"---date = %@---", [[NSDate alloc] initWithTimeIntervalSince1970:1524535958000]);
    NSLog(@"---date = %@---", [[NSDate alloc] initWithTimeIntervalSince1970:1524535958000 / 1000]);
    
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]);
    
    NSInteger ttt = 10;
    NSAssert(ttt != 9, @"=====");
    
    NSArray<NSString *> *arrrr = @[@"1", @"2", @"3"];
    if ([arrrr containsObject:@"1"]) {
        NSLog(@"===---");
    } else {
        NSLog(@"###@@@");
    }
    NSLog(@"dic = %@", [[NSBundle mainBundle] infoDictionary]);
    NSLog(@"viewDidLoad 11");
    [super viewDidLoad];
NSLog(@"viewDidLoad 22");
    
     NSLog(@"viewDidLoad button Frame = %@", NSStringFromCGRect(self.rightButton.frame));
    
    NSArray *arr = @[[NSNull null] , @"123"];
    NSLog(@"leng = %ld ", arr.count);
    
    if (arr[0] == nil) {
        NSLog(@"12345");
    }
    
    NSLog(@"=====#####===== %@",[self disable_emoji:@"我们是😄"]);
    
    CGRect frame = CGRectMake(0, 0, 100, 100);
    CGRect windowFrame = CGRectMake(0, 0, 100, 100);//CGRectMake(0, 20, 100, 81);
    NSLog(@"here = %ld", CGRectIntersectsRect(frame, windowFrame));
    
    WEAK_REF(self)
//    weak_self.view
    
    
    NSNumber *v = [NSNumber numberWithBool:[@"😄" canBeConvertedToEncoding:NSASCIIStringEncoding]];
    NSLog(@"v = %ld", [v boolValue]);
    
    NSLog(@"range = %@", NSStringFromRange([@"我们是😄" rangeOfComposedCharacterSequenceAtIndex:3]));
    
    NSLog(@"byte = %ld", sizeof(NSInteger));
    
//    UIImage *image = [UIImage imageNamed:@"大笑"];
//    image = [image ndl_imageWithScaleRatio:2.0];
//    UIImageView *ivv = [[UIImageView alloc] initWithImage:image];
//    ivv.backgroundColor = [UIColor redColor];
//    [self.view addSubview:ivv];
//    [ivv sizeToFit];
    
//    [CommonUtils logIvarListForClass:[UINavigationBar class]];
    [CommonUtils logPropertyListForClass:[UINavigationBar class]];
//    [CommonUtils logIvarListForClass:NSClassFromString(@"_UIBarBackground")];
    
    
    TestView *tview = [[TestView alloc] initWithFrame:CGRectMake(20, 20, self.view.width - 40, 100)];
    tview.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:tview];
    
    tview.layer.borderColor = [UIColor blueColor].CGColor;
    tview.layer.borderWidth = 2.0;
//    tview.layer.shadowColor = [UIColor blackColor].CGColor;
//    tview.layer.shadowOpacity = 1.0;
//    tview.layer.shadowRadius = 8;
//    tview.layer.shadowOffset = CGSizeZero;//CGSizeMake(0, 5);
    NSLog(@"layer = %@", tview.layer);
    NSLog(@"===%@ dele = %@", tview, tview.layer.delegate);
    NSLog(@"here = %@  tt = %@", nil, [NSNull null]);




    
    CGFloat lengths[] = {3, 3, 4};
//    CGFloat *lengths = {3, 3, 4};//error
    NSLog(@"length = %ld", sizeof(lengths) / sizeof(CGFloat));
    
    self.view.backgroundColor = [UIColor greenColor];
    
    Person *pp = [Person personWithName:@"123" age:123];
    [CommonUtils logIvarListForClass:[Person class]];
    
    self.bottomViews = [NSMutableArray array];
    
    NSString *ss =@"123,456,789,";
    //NSArray *aaa = [ss componentsSeparatedByString:@","];
    NSLog(@"here = %@ ", [ss substringToIndex:ss.length - 1]);
    
    
    NSMutableArray *strArr = [NSMutableArray arrayWithObjects:@"123", @"234", @"345", @"123", nil];;
    NSLog(@"count = %ld", strArr.count);
    [strArr removeObject:@"123"];
    NSLog(@"count = %ld here = %@", strArr.count, strArr);
    
//    UIView *vvv = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 5, 170 - 5, 10, 10)];
//    vvv.backgroundColor = [UIColor redColor];
//    [self.view addSubview:vvv];
    
    // pt
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 28 - 48 - 26 - 48, self.view.height - 200, 48, 48)];
    self.bottomView.backgroundColor = [UIColor cyanColor];
    self.bottomView.layer.cornerRadius = 24;
    self.bottomView.tag = 3;
    [self.view addSubview:self.bottomView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.bottomView addGestureRecognizer:tap];
    [self.bottomViews addObject:self.bottomView];
    NSLog(@"tran 1= %@", NSStringFromCGRect(self.bottomView.frame));
    
    self.bottomViewLeft = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 28 - 48 - 26 - 48 - 10 - 48, self.view.height - 200, 48, 48)];
    self.bottomViewLeft.backgroundColor = [UIColor redColor];
    self.bottomViewLeft.layer.cornerRadius = 24;
    self.bottomViewLeft.tag = 2;
    [self.view addSubview:self.bottomViewLeft];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    [self.bottomViewLeft addGestureRecognizer:tap1];
    [self.bottomViews addObject:self.bottomViewLeft];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 28 - 48 - 26 - 48 - 10 - 48 - 10 -48, self.view.height - 200, 48, 48)];
    view2.backgroundColor = [UIColor redColor];
    view2.layer.cornerRadius = 24;
    [self.view addSubview:view2];
    [self.bottomViews addObject:view2];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 28 - 48 - 26 - 48 - 10 - 48 - 10 -48 - 58, self.view.height - 200, 48, 48)];
    view1.backgroundColor = [UIColor redColor];
    view1.layer.cornerRadius = 24;
    [self.view addSubview:view1];
    [self.bottomViews addObject:view1];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 28 - 48 - 26 - 48 - 10 - 48 - 10 -48 - 58 - 58, self.view.height - 200, 48, 48)];
    view0.backgroundColor = [UIColor redColor];
    view0.layer.cornerRadius = 24;
    [self.view addSubview:view0];
    [self.bottomViews addObject:view0];
    
    
//    UIView *ttttt = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 96, self.view.height - 200, 48, 48)];
//    ttttt.backgroundColor = [UIColor greenColor];
//    ttttt.layer.cornerRadius = 24;
//    [self.view addSubview:ttttt];
    
    /*
    UIView *animView = [[UIView alloc] init];
    animView.size = CGSizeMake(120, 80);
    animView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:animView];
    
    animView.layer.borderWidth = 2;
    animView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // 0.5:0.5   60:40
    NSLog(@"anchor = %@ position = %@", NSStringFromCGPoint(animView.layer.anchorPoint), NSStringFromCGPoint(animView.layer.position));
    
    animView.layer.anchorPoint = CGPointMake(0.2, 0.2);
    animView.layer.position = CGPointMake(animView.size.width * 0.2, animView.size.height * 0.2);
    
    animView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:5.0 animations:^{
        animView.transform = CGAffineTransformIdentity;
    }];
    */
    
    // _placeholderLabel
    //[CommonUtils logIvarListForClass:[UITextView class]];
    

//    self.placeholderTextView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(20, 80, self.view.size.width - 40, 200)];
//    self.placeholderTextView.backgroundColor = [UIColor greenColor];
//    
//    self.placeholderTextView.placeholder = @"我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人";//我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人我们是中国人
//    self.placeholderTextView.placeholderColor = [UIColor cyanColor];
//    self.placeholderTextView.placeholderAlignment = PlaceholderAlignment_Center;
//    
//    
//    [self.view addSubview:self.placeholderTextView];
    
//    test touchEvent
//        TestView *touchView = [[TestView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
//        touchView.backgroundColor = [UIColor redColor];
//        [self.view addSubview:touchView];
    
//    UIView *tt = [[UIView alloc] initWithFrame:CGRectMake(0, 400, 200, 100)];
//    tt.backgroundColor = [UIColor redColor];
//    [self.view addSubview:tt];
    
    /*
    Person *per = [[Person alloc] init];
    per.name = @"123";
    per.age = 20;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"person.archive"];
    NSLog(@"path = %@", path);
//    [NSKeyedArchiver archiveRootObject:per toFile:path];
    
    NSLog(@"%@", [@"ndl" ndl_md5String]);
    NSLog(@"here = %X", 's');
    
    //NSLog(@"%@", [NSString ndl_generateRandomStringWithLength:10]);
    //NSFoundationVersionNumber_iOS_9_0
    NSLog(@"margin = %@", NSStringFromUIEdgeInsets(self.view.layoutMargins));
    
    //NSOperatingSystemVersion
//    [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:((NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 1, .patchVersion = 0})];// > 9.1
//    [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:((NSOperatingSystemVersion){9, 1, 0})];
    
    srand((unsigned int)time(0));
    rand() % 10;
    time_t now;
    //NSLog(@"%ld", now);
    time_t t = time(&now);
    NSLog(@"%ld-%ld", now, t);
    // 时间戳
    NSString *time_stamp = [NSString stringWithFormat:@"%ld", now];
    NSLog(@"time = %@", time_stamp);
    
    NSLog(@"version = %f", [[UIDevice currentDevice].systemVersion floatValue]);
    
    //UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>
    //NSLog(@"view H = %f", self.view.bounds.size.height);
    
    NSLog(@"bundle path = %@", [[NSBundle mainBundle] pathForResource:@"PYSearch" ofType:@"bundle"]);
    NSLog(@"resourcePath path = %@", [[NSBundle mainBundle] resourcePath]);
    
    [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str = @" sdf fg ij ";
    //str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"str = %@", [str stringByAppendingString:@"123"]);
    
    dispatch_queue_t queue = dispatch_queue_create("123", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i  = 0; i < 50; i++) {
                
            }
            NSLog(@"dispatch semaphore send");
            dispatch_semaphore_signal(semaphore);
        });
        NSLog(@"waiting...");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"wait after");
    });
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    subView1.backgroundColor = [UIColor redColor];
    [self.floatLayoutView addSubview:subView1];
    
    self.testView = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    self.testView.textAlignment = NSTextAlignmentCenter;
    self.testView.text = @"12345";
    [self.view addSubview:self.testView];
    self.testView.backgroundColor = [UIColor purpleColor];
    
    
    
//    self.testView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
//    [self.view addSubview:self.testView];
//    self.testView.backgroundColor = [UIColor blackColor];
    


    
    
    
    
    
    
    // 同一层及  只有一个view相应
//    TestView *touchView = [[TestView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
//    touchView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:touchView];
//    
//    TestView1 *touchView1 = [[TestView1 alloc] initWithFrame:CGRectMake(0, 64, 300, 300)];
//    touchView1.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
//    [self.view addSubview:touchView1];
    
    // 不同层级
    TestView *touchView = [[TestView alloc] initWithFrame:CGRectMake(0, 64, 300, 300)];
    //touchView.alpha = 0.3;//子空间也透明
    touchView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:touchView];
    self.touchView = touchView;
    //touchView.userInteractionEnabled = NO;
    
    TestView1 *touchView1 = [[TestView1 alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    touchView1.backgroundColor = [UIColor greenColor];
    //[touchView addSubview:touchView1];
    [self.view addSubview:touchView1];
    
    
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"1"] = @"111";
    dic[@"2"] = @"222";
    dic[@"3"] = @"333";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key = %@ value = %@", key, obj);
    }];
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"123"];
    [arr addObject:@"456"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"object = %@ index = %ld", obj, idx);
    }];
    
    
    UIView *verView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.view.frame.size.height)];
    verView.center = self.view.center;
    verView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:verView];
    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(120, 60, 80, 80)];
//    view2.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view2];
//    
//    [view2 ndl_viewByRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.center = self.view.center;
    [self.view addSubview:searchBar];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor redColor];
//    searchField.textInputMode
    
    
    searchBar.barStyle = UIBarStyleBlack;
//    searchBar.prompt = @"中国人";
    searchBar.placeholder = @"搜索";
    searchBar.showsCancelButton = YES;
//    searchBar.showsSearchResultsButton = YES;
    
    //[searchBar setShowsCancelButton:YES animated:YES];
    searchBar.tintColor = [UIColor yellowColor];
    searchBar.backgroundColor = [UIColor greenColor];
    searchBar.barTintColor = [UIColor cyanColor];
//    [searchBar sizeToFit];
    
    //[searchBar setPositionAdjustment:UIOffsetMake(self.view.frame.size.width / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"123"];
//    NSLog(@"sarch frame = %@", NSStringFromCGRect(searchBar.frame));
    
    //searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(20, 0);
    searchBar.searchTextPositionAdjustment = UIOffsetMake(30, 0);
    NSLog(@"offset.x = %f", searchBar.searchFieldBackgroundPositionAdjustment.horizontal);
//    CGRect rect = searchBar.frame;
//    rect.size.height = 75;
//    searchBar.frame = rect;
    //searchBar.translucent = YES;
    
    //searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
//    searchBar.showsScopeBar = YES;
//    searchBar.scopeButtonTitles = @[@"1", @"2", @"3"];
    
    //searchBar.inputAccessoryView
    
    
    
    //searchBar setImage:<#(nullable UIImage *)#> forSearchBarIcon:UISearchBarIc state:<#(UIControlState)#>
    
    
    // longPress
//    LongPressLabel *label = [[LongPressLabel alloc] initWithFrame:CGRectMake(100, 200, 0, 0)];
//    label.backgroundColor = [UIColor redColor];
//    label.text = @"LongPress";
//    label.textColor = [UIColor blackColor];
//    [label sizeToFit];
//    [self.view addSubview:label];
    
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    //[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    
    
    NSArray *array = @[@1, @2, @2, @1];
    
    NSCountedSet *set = [[NSCountedSet alloc]initWithArray:array];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@ => %lud", obj, (unsigned long)[set countForObject:obj]);
    }];
    
    
//    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:<#(CGFloat)#> leadSpacing:<#(CGFloat)#> tailSpacing:<#(CGFloat)#>];
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    //array mas_makeConstraints:<#^(MASConstraintMaker *make)block#>
    
    //[self setupTextView];
    
    
    //self.view.backgroundColor = [UIColor greenColor];
    
    
    NSArray *testArr = [NSArray arrayWithObjects:@"123", @"345", @"2134", nil];
    id strr = [testArr objectAtIndex:2];
    
    // key : 排序key, 某个对象的属性名称; 如果对字符串进行排序, 则传nil
    // ascending : 是否升序, YES-升序, NO-降序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *sortedArr = [testArr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"%@", sortedArr);
//    if (strr == nil) {
//        NSLog(@"strr = nil");
//    } else if (strr == [NSNull null]) {
//        NSLog(@"strr = <null>");
//    }
//    NSLog(@"%@", strr);
    
    [self.view bringSubviewToFront:self.testView];
    
    
    self.floatView = [[NDLFloatLayoutView alloc] init];
    self.floatView.backgroundColor = [UIColor yellowColor];
    self.floatView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.floatView.itemMargins = UIEdgeInsetsMake(0, 10, 10, 10);
    [self.view addSubview:self.floatView];
    
    NSArray<NSString *> *suggestions = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:suggestions[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        //button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.floatView addSubview:button];
        [button sizeToFit];
    }
    
    
    
    
    
    
    UIView *hitView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    [self.view addSubview:hitView];
    hitView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:hitView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hitButton) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(30, -20, 60, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"women" forState:UIControlStateNormal];
    [hitView addSubview:btn];
    
    
    
    
    AutoSizingView *v = [[AutoSizingView alloc] initWithFrame:CGRectMake(0, 400, 100, 100)];
    [self.view addSubview:v];
    self.v = v;
    
    
    NSLog(@"inut mode = %@", [UITextInputMode activeInputModes]);
    
    
    PieView *pie = [[PieView alloc] initWithFrame:CGRectMake(0, 100, 200, 200) values:@[@100, @200, @200] titles:nil];
    [self.view addSubview:pie];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 120, 300)];
    label2.numberOfLines = 0;
    label2.backgroundColor = [UIColor blueColor];
    label2.text = @"我们始终高三高三高三高三高三高三高三高三三脚架花湖好苏啊啥啥你爱就是啊急死啊急死啊急死啊急死啊决赛";
    [label2 sizeToFit];
    [self.view addSubview:label2];
    [self.view bringSubviewToFront:label2];
    
    NSArray *ar = [self getSeparatedLinesFromLabel:label2];
    NSLog(@"===%@===",ar);
    */
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"view did load end");
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"NSTimer = %@", self.loadingView);
//    }];
    
    // TODO: test collectionView
    
    HorizontalLinearMiddleScaleLayout *layout = [[HorizontalLinearMiddleScaleLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 160);
//    layout.itemSize = CGSizeMake(60, 80);
//    layout.minimumInteritemSpacing = 100;
    layout.minimumLineSpacing = 40;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//上下布局
     
    
    /*
     //UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 160);
    layout.minimumLineSpacing = 40;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 100, 0, 0);
     */
    
    // 200
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, NDLScreenW, 200) collectionViewLayout:layout];
    NSLog(@"===collectionView-1===");
    collectionView.backgroundColor = [UIColor yellowColor];
//    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.contentInset = UIEdgeInsetsMake(0, 100, 0, 0);
//    collectionView.contentOffset = CGPointMake(-100, 0);
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    NSLog(@"===collectionView-2===");
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCell class]) bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
    
    // TestXibView
    self.xibView = [TestXibView viewFromXib];
    [self.view addSubview:self.xibView];
//    [self.xibView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self).offset(10);
////        make.bottom.equalTo(self).offset(50).priorityLow(250);
//    }];
    self.xibView.x = 0;
    self.xibView.y = 0;
    self.xibView.width = NDLScreenW;
    self.xibView.height = 170;
    
    
    [self.view bringSubviewToFront:tview];
    tview.clipsToBounds = NO;
    
    
//    TextStrokeLabel *sLabel = [[TextStrokeLabel alloc] init];
//    sLabel.text = @"我们是中国";
//    sLabel.textColor = [UIColor blackColor];
//    sLabel.font = [UIFont boldSystemFontOfSize:14.0];
//    sLabel.textStrokeWidth = 5.0;
//    sLabel.textStrokeColor = [UIColor whiteColor];
//    [self.view addSubview:sLabel];
//    [sLabel sizeToFit];
//    sLabel.y = 100;
    
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:nil];
//    imageV.backgroundColor = [UIColor blackColor];
////    UIImageView *imageV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"couponBG"] ndl_stretchedImage]];
//    imageV.frame = CGRectMake(0, 0, 80, 80);
//    imageV.center = self.view.center;
//    [self.view addSubview:imageV];
//    
//    [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
//        imageV.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    } completion:nil];
    
    NSURL *url = [NSURL URLWithString:nil];
    NSLog(@"url = %@", url);
    
    // 红包动画
//    RedEnvelopeLoadingView *redView = [[RedEnvelopeLoadingView alloc] initWithFrame:CGRectMake(0, 0, 120, 50) dotsSpace:20];
//    redView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:redView];
//    redView.center = self.view.center;
//    [redView startAnimation];
//    self.redView = redView;
    
    // TODO:alipay动画
//    AlipayPaymentAnimationView *alipayView = [AlipayPaymentAnimationView showInView:self.view];
//    self.alipayView = alipayView;
    
    // TODO:语音识别动画
//    SpeechRecognitionAnimationView *srView = [[SpeechRecognitionAnimationView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
//    [self.view addSubview:srView];
//    srView.center = self.view.center;
    
    AlipayPaymentSuccessAnimationView *successView = [[AlipayPaymentSuccessAnimationView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    successView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:successView];
    successView.center = self.view.center;
    
    
    // self.view添加手势 添加在上面的view的touchEnded不会走
//    [self.view addGestureRecognizer:[UITapGestureRecognizer ndl_gestureRecognizerWithActionBlock:^(UIGestureRecognizer *gesture) {
//        // ended手抬起 才会走
//        NSLog(@"123===");
//    }]];
    
    
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0, NDLScreenH - 50, 80, 50);
    bottomBtn.backgroundColor = [UIColor redColor];
    [bottomBtn addActionBlock:^(UIButton *pSender) {
        NSLog(@"bottomBtn clicked");
    }];
    [self.view addSubview:bottomBtn];
    
//    NDLLabel *ndlLabel = [[NDLLabel alloc] init];
//    ndlLabel.backgroundColor = [UIColor whiteColor];
////    ndlLabel.padding = UIEdgeInsetsMake(8, 8, 8, 8);
//    ndlLabel.text = @"我么事他们管";
//    ndlLabel.longPressFlag = YES;
//    ndlLabel.highlightedBackgroundColor = [UIColor purpleColor];
//    [ndlLabel sizeToFit];
//    ndlLabel.y = 250;
//    ndlLabel.x = 20;
//    [self.view addSubview:ndlLabel];
//    [ndlLabel ndl_addTapGestureWithHandler:^{
//        ndlLabel.padding = UIEdgeInsetsMake(16, 16, 16, 16);
//        [ndlLabel sizeToFit];
//        ndlLabel.y = 250;
//        ndlLabel.x = 20;
//    }];
    MarqueeLabel *marquee = [[MarqueeLabel alloc] initWithFrame:CGRectMake(20, 170, NDLScreenW - 40, 40)];
    marquee.backgroundColor = [UIColor greenColor];
    marquee.font = [UIFont systemFontOfSize:16];
    marquee.textColor = [UIColor blackColor];
//    marquee.edgeFadeStartColor = [UIColor redColor];
    marquee.textAlignment = NSTextAlignmentCenter;
//    marquee.text = @"我没睡呢还是公司觉得接班人时间回家冻结实也是极极好的你懂吃呢和你扯视屏呢";
    marquee.text = @"sjhdgdgjk";
    
    marquee.showEdgeFadeFlag = NO;
    [self.view addSubview:marquee];
    
    
//    WaveView *wave = [[WaveView alloc] initWithFrame:CGRectMake(20, 170, 200, 200) waveColors:@[[UIColor redColor], [UIColor cyanColor]]];//  [UIColor greenColor]
//    wave.tag = 1000;
//    wave.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:wave];
//    wave.progress = 0.4;
    
    TieBaLoadingView *loadView = [[TieBaLoadingView alloc] initWithFrame:CGRectMake(20, 170, 100, 100)];
    loadView.backgroundColor = [UIColor whiteColor];
    loadView.tag = 1000;
    [self.view addSubview:loadView];
    
    BounceView *bounceView = [[BounceView alloc] initWithFrame:CGRectMake(20, 300, 120, 60) bounceSpacing:10];
    bounceView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bounceView];
    
    YouKuPlayButton * youku = [[YouKuPlayButton alloc] initWithFrame:CGRectMake(self.view.width - 120, 480, 120, 120) state:YouKuButtonState_Pause];//
    youku.backgroundColor = [UIColor orangeColor];
    [youku addTarget:self action:@selector(youkuDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youku];
    
    
//    TestMaskView *testMaskView = [[TestMaskView alloc] initWithFrame:self.view.bounds];
//    testMaskView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:testMaskView];
    
    
    // bubbleView
    TestBubbleView *bubbleView = [[TestBubbleView alloc] initWithFrame:CGRectMake(40, 300, 80, 60)];
    [bubbleView ndl_addTapGestureWithHandler:^{
        STRONG_REF(self)
        // TestAutoLayout
//        [strong_self presentViewController:[TestLifeCircleAutoLayoutViewController new] animated:YES completion:nil];
        // TestCalcFrame
        [strong_self presentViewController:[TestLifeCircleController new] animated:YES completion:nil];
    }];
    bubbleView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bubbleView];
    
    // YYKit
    [NSDate dateWithString:@"2019-02-25 10:00" format:@"yyyy-MM-dd HH:mm"];
    // test date
    NSDate *oneDate = [NSDate dateWithString:@"2019-02-25 10:00" formatString:@"yyyy-MM-dd HH:mm"];
    NSDate *testDate = [NSDate dateWithString:@"2019-02-25 20:00" formatString:@"yyyy-MM-dd HH:mm"];
    NSDate *otherDate = [NSDate dateWithString:@"2019-02-26 21:00" formatString:@"yyyy-MM-dd HH:mm"];
    NSLog(@"oneDate = %@ otherDate = %@ date =%@", oneDate, otherDate, [NSDate date]);
//    NSLog(@"1.dayCount = %ld", [otherDate daysFrom:oneDate]);
//    NSLog(@"2.dayCount = %ld", [oneDate daysFrom:otherDate]);
//    if ([oneDate isToday]) {
//        NSLog(@"oneDate isToday");
//    }
//
//    if ([testDate isToday]) {
//        NSLog(@"testDate isToday");
//    }
    
    // ======================================
    // TimeZone
    NSLog(@"###date = %@###", [NSDate date]);// ###date = Tue Feb 26 18:19:47 2019###
    NSLog(@"###date = %@###", [NSString stringWithFormat:@"%@", [NSDate date]]);// ###date = 2019-02-26 10:19:47 +0000###
    CLog(@"###date = %@###", [NSDate date]);// ###date = 2019-02-26 10:19:47 +0000### UTC
    NSInteger hour = [NSDate date].hour;// YYKit: 18
    
    
    
    NSLog(@"CString = %s ", CString(123qwe));
    
    [CommonUtils logTimeZone:[NSTimeZone localTimeZone]];
    [CommonUtils logDate];
    [CommonUtils logCalendar];
    [CommonUtils logLocal:[NSLocale currentLocale]];
    
    [UserInfo sharedUserInfo].userID = 123;
    [UserInfo sharedUserInfo].token = @"token";
    NSLog(@"UserInfo = %@", [UserInfo sharedUserInfo]);
    
    
    // local notification
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dispatch local notification");
        [LocalNotificationUtils presentLocalNotificationWithContent:@"ndlwill～～～" soundNamed:nil];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"open URL");
//        [[UIApplication sharedApplication] ndl_openURL:[NSURL URLWithString:@"testapp://"]];
//    });
    
    
    [CommonUtils logBinaryTree];
    
    UILabel *fontLabel = [[UILabel alloc] init];
    fontLabel.backgroundColor = [UIColor whiteColor];
    fontLabel.font = [UIFont systemFontOfSize:28];
    fontLabel.textColor = [UIColor blackColor];
//    fontLabel.text = @"TextFont";
    fontLabel.text = @"测试字体";
    [self.view addSubview:fontLabel];
    [fontLabel sizeToFit];
    NSLog(@"fontLabel size before = %@", NSStringFromCGSize(fontLabel.size));
    fontLabel.height = 28;// 我感觉高度就是fontSize=28
    NSLog(@"fontLabel size after = %@", NSStringFromCGSize(fontLabel.size));
    
    [CommonUtils testFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:28]];
    
    NSLog(@"kBigTitleBundleMargin = %lf kBigTitleLimitY = %lf", kBigTitleBundleMargin, kBigTitleLimitY);
    
    NSLog(@"===Home viewDidLoad===");
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"Home dispatch_after 6.0");
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[TestPresentViewController new]];
//        [self presentViewController:nav animated:YES completion:nil];
//    });
    
    [self testHook];
    
    
    
    NSString *crashStr = nil;
    // crash
//    NSDictionary *crashDic = @{@"key1" : @"123", @"key2" : crashStr, @"key3" : @"234"};
    
    // exception捕获 不crash了
    NSDictionary *exceptionDic = nil;
    @try {
        // 删除全局异常断点 不然还是会进入到断点
        exceptionDic = @{@"key1" : @"123", @"key2" : crashStr, @"key3" : @"234"};
    } @catch (NSException *exception) {
        // exception = *** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[1]
        NSLog(@"exception = %@", exception);
    } @finally {
        NSLog(@"finally exceptionDic = %@", exceptionDic);// nil
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"===after 3.0, need crash===");
            // condition:应该exceptionDic != nil 现在exceptionDic == nil 会断言 会闪退
//            NSAssert(exceptionDic != nil, @"exceptionDic == nil,need to crash");
        });
    }
    
    // MARK:根控制器 transition animation
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"=====start transition animation===");
//
//        // UIViewAnimationOptionTransitionCrossDissolve
//        [UIView transitionWithView:KeyWindow duration:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//            KeyWindow.rootViewController = [NextRootViewController new];
//        } completion:^(BOOL finished) {
//            NSLog(@"===Home finished===");
//        }];
//    });
    
    
    // new navController
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[NextRootViewController new]] animated:YES completion:nil];
//    });
 
    
//    // 3DTouch
//    if (@available(iOS 9.0, *)) {
//        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    }
    
    // ===object_setClass===
//    self.childObj = [[ChildObject alloc] init];
//    self.childObj.objectName = @"objectName";
//    self.childObj.childObjName = @"childObjName";
//    object_setClass(self.childObj, [BaseObject class]);
//
//    NSLog(@"childObj = %@", self.childObj);
//
    // -[BaseObject childObjName]: unrecognized selector sent to instance
//    NSLog(@"childObj = %@ childObjName = %@", self.childObj, self.childObj.childObjName);
    
    
    // ===TestGesture===
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        GestureViewController *vc = [GestureViewController new];
//
//        NavController *nav = [[NavController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//    });
    
    // ===TestTransitionController===
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        GestureViewController *vc = [GestureViewController new];
//        // 默认的从下到上 UIModalTransitionStyleCoverVertical
//        // 翻转:UIModalTransitionStyleFlipHorizontal
//        // 渐显:UIModalTransitionStyleCrossDissolve
////        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        // 默认全屏
////        vc.modalPresentationStyle = UIModalPresentationFullScreen;
////        [self presentViewController:vc animated:YES completion:nil];
//
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//    });
    
    
    // ===log method list===
//    [CommonUtils logInstanceMethodListForClass:[UINavigationController class]];
//    [CommonUtils logInstanceMethodListForClass:[UIPercentDrivenInteractiveTransition class]];
    
    // ===test BOOL===
//    BOOL trueFlag = YES;// 1
//    BOOL falseFlag = NO;// 0
//    NSLog(@"trueFlag = %ld falseFlag = %ld", trueFlag, falseFlag);
    
    // =====test database=====
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self presentViewController:[TestWCDBViewController new] animated:YES completion:nil];
//    });
    
    // =====test navBar=====
    
//    // MARK:=====test TextView || TestAVFoundation=====
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self presentViewController:[TestTVViewController new] animated:YES completion:nil];
//        [self presentViewController:[TestAVFoundationViewController new] animated:YES completion:nil];
//    });
    
    // MARK: interview面试
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NDLLog(@"===start interview===");
//        [self presentViewController:[InterviewViewController new] animated:YES completion:nil];
//    });
    
    // MARK: ===test opengles==
    /**
     TestOpenGLESViewController
     OpenGLES1Controller
     OpenGLES2Controller
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CCViewController *vc = [[CCViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    });
    
    
    // MARK: test Rotate ???
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        KeyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[TestRotateViewController new]];
//    });
    
    // MARK: test tabBarVC
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        KeyWindow.rootViewController = [[TestTabBarController alloc] init];
//    });
    
    // test apm
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"cpu_usage = %.2lf cpu_usage_1 = %.2lf", [SystemInfo cpu_usage], [SystemInfo cpu_usage_1]);
//        NSLog(@"totalMemorySize = %lld availableMemorySize = %lld", [SystemInfo totalMemorySize], [SystemInfo availableMemorySize]);
//        NSLog(@"residentMemory = %llu", [SystemInfo residentMemory]);
//        NSLog(@"usedMemory = %lld memoryUsage = %lld", [SystemInfo usedMemory], [SystemInfo memoryUsage]);
//
//    });
    
    
    // ===test swift===
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        TestSwiftViewController *swiftVC = [[TestSwiftViewController alloc] init];
//        [self presentViewController:swiftVC animated:YES completion:nil];
//    });
    
    // TODO:start new test
    
    
    
    // ===test GCD===
//    // 创建队列组
//    dispatch_group_t group = dispatch_group_create();
//    // 获取全局并发队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_group_enter(group);
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"before dispatch_group_async - 1");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"dispatch_group_async-1");
//            dispatch_group_leave(group);
//        });
//    });
//
//    dispatch_group_enter(group);
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"before dispatch_group_async - 2");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"dispatch_group_async-2");
//            dispatch_group_leave(group);
//        });
//    });
//
//    // 当并发队列组中的任务执行完毕后才会执行这里的代码
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"dispatch_group_notify");
//    });
    

}

- (BOOL)runUntilBlock:(BOOL(^)())block timeout:(NSTimeInterval)timeout
{
    __block Boolean fulfilled = NO;
    void (^beforeWaiting) (CFRunLoopObserverRef observer, CFRunLoopActivity activity) =
    ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        fulfilled = block();
        if (fulfilled) {
            CFRunLoopStop(CFRunLoopGetCurrent());
        }
    };
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, true, 0, beforeWaiting);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // Run!
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeout, false);
    
    NSLog(@"=====after CFRunLoopRunInMode=====");
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
    
    return fulfilled;
}

// iOS9.0
#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSLog(@"previewingContext:viewControllerForLocation location = %@", NSStringFromCGPoint(location));
    ThreeDTouchViewController *vc = [[ThreeDTouchViewController alloc] init];
    
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    NSLog(@"previewingContext:commitViewController = %@", viewControllerToCommit);
}

- (void)testHook
{
    NSLog(@"###ViewController testHook###");
}

- (void)youkuDidClicked:(YouKuPlayButton *)btn
{
    if (btn.buttonState == YouKuButtonState_Pause) {
        btn.buttonState = YouKuButtonState_Play;
    } else {
        btn.buttonState = YouKuButtonState_Pause;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=====#####indexItem = %ld", indexPath.item);
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    
    if (indexPath.item == 0) {
        cell.backgroundColor = [UIColor cyanColor];
    }
    
    if (indexPath.item == 1) {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        
        
    } else {
        NSLog(@"scrollViewDidEndDragging");
        NSArray *cells = ((UICollectionView *)scrollView).visibleCells;
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    NSArray *cells = ((UICollectionView *)scrollView).visibleCells;
    NSLog(@"cells = %@", cells);
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//    NSArray *cells = ((UICollectionView *)scrollView).visibleCells;
//
//}


#warning TODO touchesBegan...
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"===Home touchesBegan===");
    
//    [super touchesBegan:touches withEvent:event];
    
//    self.xibView.height += 10;
//
//    [self.loadingView removeFromSuperview];
//    self.loadingView = nil;
//
//    NSLog(@"loadingView = nil create###");
//    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
//    self.loadingView.backgroundColor = [UIColor yellowColor];
//    self.loadingView.loadingStatus = LoadingStatus_Success;
//    [self.view addSubview:self.loadingView];
//    [self.loadingView startAnimation];
    
    TieBaLoadingView *view = [self.view viewWithTag:1000];
    view.progress = 0.6;
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"===dispatch_after===");
//        
//        NSString *customURL = @"NDL_TEST_ROUTE://NaviPush/TestViewController?name=home&userId=99999&age=18&adbc=29";
//        
//        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
//    });
    
    
    // 替换icon
//    if (@available(iOS 10.3, *)) {
//        if (!Application.supportsAlternateIcons) {
//            return;
//        }
//
//        // 这个是替换图标的名称，在Info.plist文件里面添加一个CFBundleAlternateIcons字段，如果你想显示应用的主图标，则设置字段的值为nil，键的主键是plist里面的CFBundleIcons字段
//        NSString *alternateIconName = Application.alternateIconName;
//        if (alternateIconName) {
//            [Application setAlternateIconName:@"" completionHandler:^(NSError * _Nullable error) {
//
//            }];
//        }
//    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"===###===");
//    if (!self.popoverView.isAnimating) {
//        [self.popoverView startAnimation];
//    } else {
//        NSLog(@"=====isAnimaing=====");
//    }
    
    //[self earthquake:gesture.view];
    //NSLog(@"tran2 = %@", NSStringFromCGRect(self.bottomView.frame));
    
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnim.values = @[@-10, @0, @10, @0];
    shakeAnim.repeatCount = 3;
    shakeAnim.duration = 0.15;
    [gesture.view.layer addAnimation:shakeAnim forKey:nil];
    
    
//    dampingRatio（阻尼系数）
//    范围 0~1 当它设置为1时，动画是平滑的没有振动的达到静止状态，越接近0 振动越大
//
//    velocity （弹性速率）
//    就是形变的速度，从视觉上看可以理解弹簧的形变速度，到动画结束，该速度减为0，所以，velocity速度越大，那么形变会越快，当然在同等时间内，速度的变化（就是速率）也会越快，因为速度最后都要到0。
//    for (NSInteger i = self.bottomViews.count - 1; i >= 0; i--) {
//        NSLog(@"index = %ld", i);
//        UIView *v = self.bottomViews[i];
//        v.transform = CGAffineTransformMakeTranslation(0, 13);
//
//        [UIView animateWithDuration:0.6 delay:0 + 0.03 * i usingSpringWithDamping:0.6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            v.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }
    
    
    
    
    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        v.transform = CGAffineTransformIdentity;
//    } completion:nil];
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}

- (void)hitButton
{
    self.v.frame = CGRectMake(0, 400, 200, 200);
    NSLog(@"hitButton clcked");
}



// TODO: viewDidLayoutSubviews
- (void)viewDidLayoutSubviews
{
    NSLog(@"=====viewDidLayoutSubviews=====");
    [super viewDidLayoutSubviews];
    
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 48;
    CGSize floatLayoutViewSize = [self.floatView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    
    NSLog(@"before set frame");
    self.floatView.frame = CGRectMake(24, 200, contentWidth, floatLayoutViewSize.height);
    
    NSLog(@"viewDidLayoutSubviews button Frame = %@", NSStringFromCGRect(self.rightButton.frame));NSLog(@"viewDidLayoutSubviews button Frame = %@", NSStringFromCGRect(self.rightButton.frame));
    
    NSLog(@"###collection view offset = %@ contentSize = %@", NSStringFromCGPoint(self.collectionView.contentOffset), NSStringFromCGSize(self.collectionView.contentSize));
}


- (void)setupTextView {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200)];
    _textView.delegate = self;
    _textView.tintColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15.f];
    _textView.backgroundColor =[UIColor grayColor];
    [_textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_textView];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容";
    placeholderLabel.font = [UIFont systemFontOfSize:15.f];
    placeholderLabel.textColor = [UIColor whiteColor];
    placeholderLabel.numberOfLines = 0;
    [placeholderLabel sizeToFit];
    [_textView addSubview:placeholderLabel];
    
    [_textView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    
    

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        NSLog(@"text change new = %@", change[@"new"]);
        
        NSString *newText = change[@"new"];
        if (newText.length > 10) {
            self.textView.text = [newText substringToIndex:10];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"===Home viewWillDisappear===");
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"===Home viewDidDisappear===");
    
    CGRect bound = self.view.bounds;
    bound.size.height = 400;
    self.view.bounds = bound;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    NSLog(@"===HomeViewController dealloc===");
    
//    [super dealloc];// arc不允许调用这个 (这个对象被置nil，会调用dealloc)
}

- (void)deviceOrientationDidChanged:(NSNotification *)notification
{
    NSLog(@"deviceOrientationDidChanged");
    
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
}



static CGFloat count = 0;
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.textView.text = @"1234567890wer";
//
//    if ([self isPureInt:@"1234"]) {
//        NSLog(@"YES");
//
//        [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    } else {
//        NSLog(@"NO");
//    }
//
//
//    //[self presentViewController:[MyTableViewController new] animated:YES completion:nil];
//
//    //MyTableViewController *tableVC = [MyTableViewController new];
//    CustomViewController *tableVC = [CustomViewController new];
//
//    UIView *tableV = tableVC.view;
//
//    CGRect bound = tableV.frame;
//    bound.origin.y = 40;
//    bound.size.height = 300;
//    tableV.frame = bound;
//
//    [self addChildViewController:tableVC];
//    [self.view addSubview:tableV];
//
////    [UIView animateWithDuration:2.0 animations:^{
////        self.touchView.transform = CGAffineTransformMakeScale(1.2 + count, 1.2 + count);
////    }];
//
//
////    [UIView transitionWithView:self.view duration:2.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
////        //self.touchView.backgroundColor = [UIColor cyanColor];
////    } completion:nil];
//}


//#warning TODO..
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //[super touchesBegan:touches withEvent:event];
//    NSLog(@"=====#####=====#####");
//    // testView-label
////    NSLog(@"test Vview size = %@", NSStringFromCGSize([self.testView sizeThatFits:CGSizeMake(-1, -1)]));
////    CGSize szie = [self.testView sizeThatFits:CGSizeMake(60, 30)];
////    CGRect frame = self.testView.frame;
////    frame.size = szie;
////    self.testView.frame = frame;
//    // testView-view
//    NSLog(@"test Vview size = %@", NSStringFromCGSize([self.testView sizeThatFits:CGSizeMake(0, 0)]));
//
////    [self.testView sizeToFit];
////    NSLog(@"sizeToFit test Vview origin = %@", NSStringFromCGPoint(self.testView.frame.origin));
////    NSLog(@"sizeToFit test Vview size = %@", NSStringFromCGSize(self.testView.frame.size));
//
////    [self.floatLayoutView sizeToFit];
//    NSLog(@"touch begin");
//
//
//
//
//}


- (BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"shouldChangeTextInRange");
    
    
    if (textView == self.textView) {
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        
        NSLog(@"exist = %@ selectL = %ld replaceText = %@", textView.text, range.length, text);
        if (existedLength - selectedLength + replaceLength > 10) {
            // HUD 提示
            NSLog(@"warming = >10");
            return NO;
        }
    }
    
 
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
    if (textView == self.textView) {
        if (textView.text.length > 10) {
            // 截取字符串
            textView.text = [textView.text substringToIndex:10];
            // HUD 提示
            NSLog(@"warming = >10");
        }
    }
    
//    if (self.textView.text.length == 0) {
//        NSLog(@"here placeholderLabel frame = %@", NSStringFromCGRect(_placeholderLabel.frame));
//        CGFloat y = (_textView.frame.size.height - _placeholderLabel.frame.size.height) / 2;
//        CGRect frame = _placeholderLabel.frame;
//        frame.origin.y = y;
//        _placeholderLabel.frame = frame;
//    }

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

//UIKIT_STATIC_INLINE


@end
