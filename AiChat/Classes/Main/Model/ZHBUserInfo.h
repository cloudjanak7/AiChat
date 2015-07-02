//
//  ZHBUserEntity.h
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHBSingleton.h"

@interface ZHBUserInfo : NSObject

ZHBSingletonH(UserInfo)

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *password;
/**
 *  @brief  xmpp登录帐号,格式为:name@domain
 */
@property (nonatomic, copy) NSString *jid;
/**
 *  @brief  是否能够自动登录
 */
@property (nonatomic, assign, getter=canAutoLogin) BOOL autoLogin;

/**
 *  @brief  保存用户信息到沙盒
 */
- (void)saveInfoToSanbox;
/**
 *  @brief  从沙盒获取用户信息
 */
- (void)userInfoFromSanbox;

@end
