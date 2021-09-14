//
//  TestASDK1ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2021/1/6.
//  Copyright © 2021 ndl. All rights reserved.
//

// MARK: ASDK
/**
 https://github.com/texturegroup/texture/tree/master/examples/ASDKgram
 
 iOS应用程序中的所有在屏幕上的显示都通过CALayer对象表示的。
 UIViews 创建并且拥有一个底层的 CALayer，并为他们添加触摸处理和其他交互功能。
 
 所有的 ASCellNode 都负责确定自己的大小。
 
 ###
 Texture Node Container    UIKit Equivalent
 ASCollectionNode    in place of UIKit's UICollectionView
 ASPagerNode    in place of UIKit's UIPageViewController
 ASTableNode    in place of UIKit's UITableView
 ASViewController    in place of UIKit's UIViewController
 ASNavigationController    in place of UIKit's UINavigationController. Implements the ASVisibility protocol.
 ASTabBarController    in place of UIKit's UITabBarController. Implements the ASVisibility protocol.
 ###
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestASDK1ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
