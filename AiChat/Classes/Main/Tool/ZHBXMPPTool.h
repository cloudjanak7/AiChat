//
//  ZHBXMPPTool.h
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHBSingleton.h"
#import "XMPPFramework.h"

@class RACSignal;

typedef enum {
    XMPPStatusTypeConnecting = 0,//连接中...
    XMPPStatusTypeLoginSuccess,//登录成功
    XMPPStatusTypeLoginFailure,//登录失败
    XMPPStatusTypeNetErr,//网络不给力
    XMPPStatusTypeRegisterSuccess,//注册成功
    XMPPStatusTypeRegisterFailure//注册失败
}XMPPStatusType;

typedef enum {
    XMPPUserStatusTypeOnline = 0,
    XMPPUserStatusTypeLeave,
    XMPPUserStatusTypeOffline
}XMPPUserStatusType;

//XMPP请求结果的block
typedef void (^XMPPResultCallBack)(XMPPStatusType type);

@interface ZHBXMPPTool : NSObject

@property (nonatomic, strong, readonly) XMPPStream *xmppStream; /**< XMPPStream */

@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardModule; /**< 电子名片 */

@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppAvatarModule; /**< 头像模块 */

@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster; /**< 花名册 */

@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage; /**< 花名册数据存储 */

@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageStorage; /**< 消息数据存储 */

@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage *xmppRoomStorage; /**< 聊天室数据存储 */

@property (nonatomic, strong, readonly) XMPPRoom *xmppRoom; /**< 聊天室 */

@property (nonatomic, copy) NSString *chatJid; /**< 当前聊天对象JID */

/*! @brief  用户头像更新消息(发送UIImage) */
@property (nonatomic, strong, readonly) RACSignal *rac_myVCardUpdateSignal;

/**
 *  @brief  单例sharedXMPPTool
 */
ZHBSingletonH(XMPPTool)

/**
 *  @brief  用户登录
 *
 *  @param callBack 回掉block
 */
- (void)userLogin:(XMPPResultCallBack)callBack;
/*!
 *  @brief  用户注册
 *
 *  @param callBack 注册结果回掉
 */
- (void)userRegister:(XMPPResultCallBack)callBack;
/*!
 *  @brief  用户退出
 */
- (void)userLogout;
/*!
 *  @brief  断开服务器连接
 */
- (void)disConnectFromHost;

/**
 *  @brief  发送消息
 *
 *  @param message 消息内容
 *  @param jid     对方JID
 */
- (void)sendMessage:(NSString *)message toJID:(XMPPJID *)jid;
/**
 *  @brief  重置未读消息数
 *
 *  @param fromJidStr 消息发送发jid
 *
 *  @return YES重置成功 NO重置失败
 */
- (BOOL)resetUnreadMessage:(NSString *)fromJidStr;
/**
 *  @brief  判断用户是否为好友
 *
 *  @param jidStr 用户jid
 *
 *  @return YES是好友 NO非好友
 */
- (BOOL)userExistsWithJID:(NSString *)jidStr;
/**
 *  @brief  添加好友
 *
 *  @param jidStr 用户jid
 */
- (void)subscribeUser:(NSString *)jidStr;

- (void)createChatRoom;

@end

