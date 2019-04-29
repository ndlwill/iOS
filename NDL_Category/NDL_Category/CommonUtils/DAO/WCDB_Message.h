//
//  WCDB_Message.h
//  NDL_Category
//
//  Created by dzcx on 2019/4/24.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDB_Message : NSObject

@property (nonatomic, assign) NSInteger messageID;

@property (nonatomic, copy) NSString *messageName;
@property (nonatomic, assign) NSInteger messageValue;

@property (nonatomic, strong) NSDate *createDate;

@end

NS_ASSUME_NONNULL_END
