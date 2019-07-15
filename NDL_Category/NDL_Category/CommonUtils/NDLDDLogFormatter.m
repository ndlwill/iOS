//
//  NDLDDLogFormatter.m
//  NDL_Category
//
//  Created by dzcx on 2019/6/14.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "NDLDDLogFormatter.h"

@implementation NDLDDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *loglevel = nil;
    switch (logMessage.flag)
    {
        case DDLogFlagError:
        {
            loglevel = @"[ERROR]->";
        }
            break;
        case DDLogFlagWarning:
        {
            loglevel = @"[WARNING]-->";
        }
            break;
        case DDLogFlagInfo:
        {
            loglevel = @"[INFO]--->";
        }
            break;
        case DDLogFlagDebug:
        {
            loglevel = @"[DEBUG]---->";
        }
            break;
        case DDLogFlagVerbose:
        {
            loglevel = @"[VERBOSE]----->";
        }
            break;
            
        default:
            break;
    }
    
//    if (logMessage.context) {
//
//    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@___line[%ld]__%@", loglevel, logMessage->_function, logMessage->_line, logMessage->_message];
    return formatStr;
}

@end
