//
//  ZHBXMPPConst.m
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBXMPPConst.h"

NSString * const kUserName    = @"userName";
NSString * const kUserPwd     = @"userPwd";
NSString * const kLoginStatus = @"loginStatus";

#if LOCAL_TEST
NSString * const kXmppChatRoomDoMain = @"conference.localhost";
NSString * const kXmppDoMain         = @"zhuangpc.local";
NSString * const kXmppHostName       = @"172.20.10.8";
//NSString * const kXmppHostName       = @"192.168.1.22";
NSInteger  const kXmppHostPort       = 5222;
#else
NSString * const kXmppChatRoomDoMain = @"conference.zhuangpc.local";
NSString * const kXmppDoMain         = @"zhuangpc.local";
NSString * const kXmppHostName       = @"192.168.1.5";
NSInteger  const kXmppHostPort       = 5222;
#endif

NSTimeInterval const kXmppTimeout = 15.f;

NSString * const kMessageTypeChat = @"chat";

NSString * const kMessageTypeGroupChat = @"groupchat";

NSString * const kXmppUserCoreDataStorageObject = @"XMPPUserCoreDataStorageObject";

NSString * const kXmppMessageArchivingMessageCoreDataObject = @"XMPPMessageArchiving_Message_CoreDataObject";

NSString * const kXmppMessageArchivingContactCoreDataObject = @"XMPPMessageArchiving_Contact_CoreDataObject";