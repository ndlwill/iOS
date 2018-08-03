#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LKDB+Mapping.h"
#import "LKDBHelper.h"
#import "LKDBUtils.h"
#import "NSObject+LKDBHelper.h"
#import "NSObject+LKModel.h"

FOUNDATION_EXPORT double LKDBHelperVersionNumber;
FOUNDATION_EXPORT const unsigned char LKDBHelperVersionString[];

