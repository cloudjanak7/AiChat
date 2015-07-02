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

//XMPP请求结果的block
typedef void (^XMPPResultCallBack)(XMPPStatusType type);

@interface ZHBXMPPTool : NSObject

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;

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

@end
