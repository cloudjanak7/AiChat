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
NSString * const xmppDoMain   = @"cn-mall";
NSString * const xmppHostName = @"192.168.0.106";
NSInteger  const xmppHostPort = 5222;
#endif

NSTimeInterval const xmppTimeout = 15.f;


NSString * const xmppUserCoreDataStorageObject = @"XMPPUserCoreDataStorageObject";

NSString * const xmppMessageArchivingMessageCoreDataObject = @"XMPPMessageArchiving_Message_CoreDataObject";

NSString * const xmppMessageArchivingContactCoreDataObject = @"XMPPMessageArchiving_Contact_CoreDataObject";