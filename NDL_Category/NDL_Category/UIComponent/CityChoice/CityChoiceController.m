//
//  CityChoiceController.m
//  DaZhongChuXing
//
//  Created by dzcx on 2018/7/26.
//  Copyright © 2018年 tony. All rights reserved.
//

#import "CityChoiceController.h"

#import <AMapLocationKit/AMapLocationKit.h>

#import "CityChoiceTableHeaderView.h"
#import "HotCityCell.h"
#import "CityChoiceSectionHeaderView.h"
#import "CitySearchResultView.h"

#import "PinYin4Objc.h"
#import "BigTitleNavigationView.h"

static NSString * const kHotCityCellID = @"HotCityCellID";

static NSString * const kCityChoiceSectionHeaderViewID = @"CityChoiceSectionHeaderViewID";

@interface CityChoiceController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) BigTitleNavigationView *navigationView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CityChoiceTableHeaderView *tableHeaderView;
@property (nonatomic, strong) CitySearchResultView *searchResultView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) HanyuPinyinOutputFormat *outputFormat;

@property (nonatomic, strong) NSMutableArray *hotCityArray;
// 字母索引
@property (nonatomic, strong) NSMutableArray<NSString *> *letterArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *pinyinArray;

// eg: {@"A" : (@"阿坝藏族羌族自治州", ...)}
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *dataSource;
// 搜索到的城市数组
@property (nonatomic, strong) NSMutableArray<NSString *> *searchResultArray;

@end

@implementation CityChoiceController
#pragma mark - Lazy Load
- (NSMutableDictionary<NSString *,NSMutableArray *> *)dataSource
{
   if (!_dataSource) {
      _dataSource = [NSMutableDictionary dictionary];
   }
   return _dataSource;
}

- (NSMutableArray<NSString *> *)letterArray
{
   if (!_letterArray) {
      _letterArray = [NSMutableArray array];
   }
   return _letterArray;
}

- (NSMutableArray<NSString *> *)pinyinArray
{
   if (!_pinyinArray) {
      _pinyinArray = [NSMutableArray array];
   }
   return _pinyinArray;
}

- (NSMutableArray<NSString *> *)searchResultArray
{
   if (!_searchResultArray) {
      _searchResultArray = [NSMutableArray array];
   }
   return _searchResultArray;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
   [super viewDidLoad];
   self.view.backgroundColor = [UIColor whiteColor];
   if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
      [self setAutomaticallyAdjustsScrollViewInsets:NO];
   }
   
//   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
//   tap.cancelsTouchesInView = NO;// 触摸事件传递给其他视图
//   [self.view addGestureRecognizer:tap];
   
   [self _setupUI];
   [self _setupDatas];
   
   [self _startOnceLocation];
}
#pragma mark - Overrides
- (void)viewWillLayoutSubviews
{
   [super viewWillLayoutSubviews];

   self.tableView.frame = CGRectMake(0, self.navigationView.height, self.view.width, self.view.height - self.navigationView.height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   NSLog(@"vc touchesBegan");
   [self.view endEditing:YES];
}

#pragma mark - Private Methods
- (void)_setupDatas
{
   self.hotCityArray = [NSMutableArray arrayWithObjects:@"上海", @"北京", @"广州", @"深圳", @"苏州", @"绍兴", @"南京", @"无锡", @"南通", nil];
 
   // 初始化数据
   self.outputFormat = [[HanyuPinyinOutputFormat alloc] init];
   self.outputFormat.toneType = ToneTypeWithoutTone;
   self.outputFormat.vCharType = VCharTypeWithV;
   self.outputFormat.caseType = CaseTypeUppercase;
   
    
   // 最好转成模型 加个拼音属性
    //TODO:数据
    NSArray *totalCityArray = nil;//[VWTAccountModel sharedAccount].cityListDic;
   
   // for async
//   __block NSUInteger dataCount = 0;
   
   NSUInteger dataCount = 0;
   for (NSDictionary *modelDic in totalCityArray) {
       //TODO:数据
       NSString *city = nil;//[modelDic notNullObjectForKey:@"area"];
      
      // 同步 汉字转拼音
      NSString *pinYin = [PinyinHelper toHanyuPinyinStringWithNSString:city withHanyuPinyinOutputFormat:self.outputFormat withNSString:@""];
      
      //
      [self.pinyinArray addObject:pinYin];
      
      NSString *firstLetter = [pinYin substringToIndex:1];
      
      // 是不是字母开头
      //            BOOL isLetter = [firstLetter matchFirstLetter];
      //            if (!isLetter) {
      //               firstLetter = @"#";
      //            }
      
      // letterArray为空数组
      if (self.letterArray.count <= 0) {
         [self.letterArray addObject:firstLetter];
         
         NSMutableArray *cityArray = [NSMutableArray arrayWithObject:city];
         [self.dataSource setObject:cityArray forKey:firstLetter];
      } else {
         if ([self.letterArray containsObject:firstLetter]) {// 包含这个letter
            NSMutableArray *cityArray = [self.dataSource objectForKey:firstLetter];
            [cityArray addObject:city];
         } else {
            [self.letterArray addObject:firstLetter];
            
            NSMutableArray *cityArray = [NSMutableArray arrayWithObject:city];
            [self.dataSource setObject:cityArray forKey:firstLetter];
         }
      }
      
      dataCount++;
      
      if (dataCount == totalCityArray.count) {// 全部转换完毕
         //               NSLog(@"self.letterArray = %@", self.letterArray);
         //               NSLog(@"self.dataSource = %@", self.dataSource);
         
         // 字母排序 如果self.letterArray里面存在@“#” 排序后他在第一个
         NSArray *sortedArray = [self.letterArray sortedArrayUsingSelector:@selector(compare:)];
         self.letterArray = [NSMutableArray arrayWithArray:sortedArray];
         
         [self.tableView reloadData];
      }
      
      
      // for async
//      if (city.length) {
//         // 同步 汉字转拼音 不能异步否则city和pinYin不同步,下标不一致
//         [PinyinHelper toHanyuPinyinStringWithNSString:city withHanyuPinyinOutputFormat:self.outputFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
//            NSString *firstLetter = [pinYin substringToIndex:1];
//
//            // 是不是字母开头
////            BOOL isLetter = [firstLetter matchFirstLetter];
////            if (!isLetter) {
////               firstLetter = @"#";
////            }
//
//            // letterArray为空数组
//            if (self.letterArray.count <= 0) {
//               [self.letterArray addObject:firstLetter];
//
//               NSMutableArray *cityArray = [NSMutableArray arrayWithObject:city];
//               [self.dataSource setObject:cityArray forKey:firstLetter];
//
//               /*
//               // test for NSMutableArray<NSMutableDictionary *> *dataSource;
//               NSMutableArray *cityArray = [NSMutableArray arrayWithObject:city];
//               NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:cityArray, firstLetter, nil];
//               [self.dataSource addObject:dic];
//                */
//            } else {
//               if ([self.letterArray containsObject:firstLetter]) {// 包含这个letter
//                  NSMutableArray *cityArray = [self.dataSource objectForKey:firstLetter];
//                  [cityArray addObject:city];
//               } else {
//                  [self.letterArray addObject:firstLetter];
//
//                  NSMutableArray *cityArray = [NSMutableArray arrayWithObject:city];
//                  [self.dataSource setObject:cityArray forKey:firstLetter];
//               }
//            }
//
//            dataCount++;
//
//            if (dataCount == totalCityArray.count) {// 全部转换完毕
////               NSLog(@"self.letterArray = %@", self.letterArray);
////               NSLog(@"self.dataSource = %@", self.dataSource);
//
//               // 字母排序 如果self.letterArray里面存在@“#” 排序后他在第一个
//               NSArray *sortedArray = [self.letterArray sortedArrayUsingSelector:@selector(compare:)];
//               self.letterArray = [NSMutableArray arrayWithArray:sortedArray];
//
//               [self.tableView reloadData];
//            }
//         }];
//      } else {
//         dataCount++;
//      }
   }
}

- (void)_setupUI
{
    // BigTitleNavigationView
    self.navigationView = [[BigTitleNavigationView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavTextFieldBigTitleContainerViewHeight + TopExtendedLayoutH)];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    // BigTitleNavigationView-lineView
    self.navigationView.lineViewShowFlag = YES;
    // BigTitleNavigationView-left setting
    self.navigationView.leftButtonImage = [UIImage imageNamed:@"common_navBack_18x18"];
    WEAK_REF(self)
    self.navigationView.leftButtonBlock = ^{
        STRONG_REF(self)
        [strong_self.navigationController popViewControllerAnimated:YES];
    };
    // BigTitleNavigationView-textField setting
    self.navigationView.placeHolderStr = @"请输入城市/拼音";
    self.navigationView.textFieldRightButtonBlock = ^{
        STRONG_REF(self)
        [strong_self.searchResultArray removeAllObjects];
        if (strong_self.searchResultView) {
            [strong_self _loadSearchResultDatasWithSearchText:@""];
        }
    };
    
    [self.navigationView.textField setValue:UIColorFromHex(0xBEBEBE) forKeyPath:@"_placeholderLabel.textColor"];
    [self.navigationView.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.navigationView.textField.delegate = self;
    
    // tableHeaderView
    self.tableHeaderView = [[CityChoiceTableHeaderView alloc] init];
    self.tableHeaderView.onLocatedCityClicked = ^(NSString *cityStr) {
        STRONG_REF(self)
        if (strong_self.chooseCityBlock) {
            strong_self.chooseCityBlock(cityStr);
        }
        [strong_self.navigationController popViewControllerAnimated:YES];
    };
    self.tableHeaderView.frame = CGRectMake(0, 0, 0, 65);
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 24, 0, 24);
    self.tableView.separatorColor = UIColorFromHex(0xE5E5E5);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // tableView高度
    //   self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = UIColorFromHex(0x00A1CC);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[CityChoiceSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kCityChoiceSectionHeaderViewID];
    [self.tableView registerClass:[HotCityCell class] forCellReuseIdentifier:kHotCityCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCommonCellID];
    [self.view addSubview:self.tableView];
    
    if (iPhoneX) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, AdditionaliPhoneXBottomSafeH, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
}

- (void)_startOnceLocation
{
   self.locationManager = [[AMapLocationManager alloc] init];
   self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
   self.locationManager.locationTimeout = 2.0;
   self.locationManager.reGeocodeTimeout = 2.0;
   [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
      NSString *city = regeocode.city;
      self.tableHeaderView.locatedCityStr = [city substringToIndex:city.length - 1];
      self.tableHeaderView.locatedCityButton.enabled = YES;
   }];
}

- (void)_matchCNBeginWithString:(NSString *)beginStr;
{
    //TODO:数据
    NSArray *totalCityArray = nil;//[VWTAccountModel sharedAccount].cityListDic;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] %@", [NSString stringWithFormat:@"%@*", beginStr]];
    for (NSDictionary *modelDic in totalCityArray) {
        //TODO:数据
        NSString *city = nil;//[modelDic notNullObjectForKey:@"area"];
        if ([predicate evaluateWithObject:city]) {
            [self.searchResultArray addObject:city];
        }
    }
}

- (void)_matchLetterBeginWithString:(NSString *)beginStr
{
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] %@", [NSString stringWithFormat:@"%@*", [beginStr uppercaseString]]];// 大写

   for (NSInteger i = 0; i < self.pinyinArray.count; i++) {
      if ([predicate evaluateWithObject:self.pinyinArray[i]]) {
          //TODO:数据
//         [self.searchResultArray addObject:[[[VWTAccountModel sharedAccount].cityListDic objectAtIndex:i] notNullObjectForKey:@"area"]];
      }
   }
}

- (void)_loadSearchResultDatasWithSearchText:(NSString *)searchText
{
   if (self.searchResultView) {// 已经创建了searchResultView
      self.searchResultView.dataSource = [self.searchResultArray copy];
      if (self.searchResultArray.count == 0) {
         if ([searchText isEqualToString:@""]) {// 没有searchText 不显示view
            self.searchResultView.hidden = YES;
         } else {
            self.searchResultView.hidden = NO;
         }
      } else {
         if (self.searchResultView.hidden) {
            self.searchResultView.hidden = NO;
         }
      }
   } else {
      self.searchResultView = [[CitySearchResultView alloc] initWithFrame:self.tableView.frame];
      WEAK_REF(self)
      self.searchResultView.cellDidSelectedBlock = ^(NSString *cityName) {
         STRONG_REF(self)
         if (strong_self.chooseCityBlock) {
            strong_self.chooseCityBlock(cityName);
         }
         [strong_self.navigationController popViewControllerAnimated:YES];
      };
      [self.view addSubview:self.searchResultView];
      self.searchResultView.dataSource = [self.searchResultArray copy];
   }
}

#pragma mark - Gesture
//- (void)handleTapGesture
//{
//   NSLog(@"handleTapGesture");
//   [self.view endEditing:YES];
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0) {
      NSUInteger row = self.hotCityArray.count / kColumn;
      if (self.hotCityArray.count % kColumn != 0) {
         row += 1;
      }
      
      return kFirstRowTop2Edge + kItemHeight * row + kItemVerticalSpacing * (row - 1) + kLastRowBottom2Edge;
   } else {
      return 53.0;
   }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 34.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // 系统的设置无效,可通过设置backgroundView
//   UITableViewHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommonSectionHeaderViewID];
//   // 这些设置无效
//   sectionHeaderView.backgroundColor = [UIColor whiteColor];
//   sectionHeaderView.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//   sectionHeaderView.textLabel.textColor = [UIColorFromHex(@"#2C2C2C") colorWithAlphaComponent:0.6];
//
//   sectionHeaderView.textLabel.text = (section == 0) ? @"热门城市" : [self.letterArray objectAtIndex:section - 1];
//   return sectionHeaderView;

   // 自定义,重用机制
   CityChoiceSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCityChoiceSectionHeaderViewID];
   sectionHeaderView.indexStr = (section == 0) ? @"热门城市" : [self.letterArray objectAtIndex:section - 1];
   return sectionHeaderView;
   
   // 没有重用机制
//   UIView *sectionHeaderView = [[UIView alloc] init];//initWithFrame:CGRectMake(0, 0, 0, 34)
//   UILabel *sectionHeaderLabel = [[UILabel alloc] init];
//   sectionHeaderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//   sectionHeaderLabel.textColor = [UIColorFromHex(@"#2C2C2C") colorWithAlphaComponent:0.6];
//   sectionHeaderLabel.text = (section == 0) ? @"热门城市" : [self.letterArray objectAtIndex:section - 1];
//   [sectionHeaderLabel sizeToFit];
//   sectionHeaderLabel.x = 24;
//   sectionHeaderLabel.y = 8;
//   [sectionHeaderView addSubview:sectionHeaderLabel];
//
//   return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSInteger section = indexPath.section;
   
   if (section > 0) {
      NSString *key = [self.letterArray objectAtIndex:section - 1];
      NSString *cityName = [[self.dataSource objectForKey:key] objectAtIndex:indexPath.row];
      
      if (self.chooseCityBlock) {
         self.chooseCityBlock(cityName);
      }
      [self.navigationController popViewControllerAnimated:YES];
   }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.dataSource.count + 1;// +热门城市
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (section == 0) {
      return 1;
   } else {
      NSString *key = [self.letterArray objectAtIndex:(section - 1)];
      return [self.dataSource objectForKey:key].count;
   }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   NSMutableArray *indexArray = [NSMutableArray arrayWithObject:@"热"];
   [indexArray addObjectsFromArray:self.letterArray];
   return indexArray;
}

// section headerView title
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   return ((section == 0) ? @"热门城市" : [self.letterArray objectAtIndex:section - 1]);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0) {
      // 滚动显示隐藏都只创建了一个对象
      HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotCityCellID forIndexPath:indexPath];
      cell.dataSource = self.hotCityArray;
      WEAK_REF(self)
      if (!cell.itemDidClickedBlock) {
         cell.itemDidClickedBlock = ^(NSString *cityName) {
            STRONG_REF(self)
            if (strong_self.chooseCityBlock) {
               strong_self.chooseCityBlock(cityName);
            }
            [strong_self.navigationController popViewControllerAnimated:YES];
         };
      }
      return cell;
   } else {
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommonCellID forIndexPath:indexPath];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
      cell.textLabel.textColor = UIColorFromHex(0x2C2C2C);
      NSString *key = [self.letterArray objectAtIndex:(indexPath.section - 1)];
      cell.textLabel.text = [[self.dataSource objectForKey:key] objectAtIndex:indexPath.row];
      return cell;
   }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [self.view endEditing:YES];
   
   return YES;
}

#pragma mark - UITextField Actions
- (void)textFieldEditingChanged:(UITextField *)textField
{
   NSString *searchText = textField.text;
   [self.searchResultArray removeAllObjects];
   
   // 匹配数据
   if ([searchText ndl_isWholeCN]) {// 是否全是中文
      NSLog(@"_matchCNBeginWithString");
      [self _matchCNBeginWithString:searchText];
   } else if ([searchText ndl_isWholeLetter]) {// 是否全是字母
      NSLog(@"_matchLetterBeginWithString");
      [self _matchLetterBeginWithString:searchText];
   }
   
   // 加载查询结果的数据
   [self _loadSearchResultDatasWithSearchText:searchText];
}


@end
