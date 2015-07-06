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

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
/**
 *  @brief  电子名片
 */
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardModule;
/**
 *  @brief  花名册
 */
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
/**
 *  @brief  花名册数据存储
 */
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
/**
 *  @brief  消息数据存储
 */
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;


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

- (void)userLogout;

- (void)disConnectFromHost;

/**
 *  @brief  发送消息
 *
 *  @param message 消息内容
 *  @param jid     对方JID
 */
- (void)sendMessage:(NSString *)message toJID:(XMPPJID *)jid;

@end
