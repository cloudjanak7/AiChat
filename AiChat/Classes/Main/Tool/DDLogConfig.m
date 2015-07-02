//
//  DDLogConfig.m
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "DDLogConfig.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "UIColor+Hex.h"

#define ERROR_LOG_COLOR [UIColor colorWithHexString:@"EE2C2C"]
#define WARN_LOG_COLOR [UIColor colorWithHexString:@"EE9A00"]
#define INFO_LOG_COLOR [UIColor colorWithHexString:@"1E90FF"]
#define VERBOSE_LOG_COLOR [UIColor colorWithHexString:@"8B636C"]

@implementation DDLogConfig

+ (void)setupLogConfig {
    //配置DDLog输出
    setenv("XcodeColors", "YES", 0);
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:ERROR_LOG_COLOR backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:WARN_LOG_COLOR backgroundColor:nil forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:INFO_LOG_COLOR backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:VERBOSE_LOG_COLOR backgroundColor:nil forFlag:DDLogFlagVerbose];
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
//    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    [DDLog addLogger:fileLogger];
}

@end
