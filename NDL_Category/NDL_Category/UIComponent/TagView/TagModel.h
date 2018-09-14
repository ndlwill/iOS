//
//  TagModel.h
//  NDL_Category
//
//  Created by dzcx on 2018/9/13.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagModel : NSObject

@property (nonatomic, copy) NSString *tagTitle;
@property (nonatomic, assign) BOOL selectionFlag;// 是否被选中

@end
