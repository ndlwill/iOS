//
//  PlaceholderTextView.h
//  NDL_Category
//
//  Created by dzcx on 2018/3/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlaceholderAlignment) {
    PlaceholderAlignment_Top = 0,
    PlaceholderAlignment_Center
};

@interface PlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 default = gray*/
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) PlaceholderAlignment placeholderAlignment;

@end
