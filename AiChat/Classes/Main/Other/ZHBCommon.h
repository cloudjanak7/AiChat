//
//  ZHBCommon.h
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//


#ifndef AiChat_ZHBCommon_h
#define AiChat_ZHBCommon_h

#import "ZHBColorMacro.h"
#import "ZHBFontMacro.h"
#import "ZHBSystemMacro.h"
#import "ZHBColorMacro.h"

#import <DDLog.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const DDLogLevel ddLogLevel = LOG_LEVEL_OFF;
#endif

#define DDLOG_INFO DDLogInfo(@"%@::%@", THIS_FILE, THIS_METHOD);

#endif
