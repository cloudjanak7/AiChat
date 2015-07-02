//
//  ZHBControllerTool.h
//  AiChat
//
//  Created by 庄彪 on 15/7/1.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHBControllerTool : NSObject

/**
 *  @brief  选择keyWindow的根控制器
 */
+ (void)chooseRootViewController;

/**
 *  @brief  根据登录状态选择主界面
 *
 *  @param isUserLogon 是否登录成功
 */
+ (void)showStoryboardWithLogonState:(BOOL)isUserLogon;

@end
