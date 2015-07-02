//
//  ZHBXMPPConst.m
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBXMPPConst.h"

NSString * const userName    = @"userName";
NSString * const userPwd     = @"userPwd";
NSString * const loginStatus = @"loginStatus";

#if LOCAL_TEST
NSString * const xmppDoMain   = @"zhuangpc.local";
NSString * const xmppHostName = @"127.0.0.1";
NSInteger  const xmppHostPort = 5222;
#else
NSString * const xmppDoMain   = @"?";
NSString * const xmppHostName = @"?";
NSInteger  const xmppHostPort = @"?";
#endif

NSTimeInterval const xmppTimeout = 15.f;
