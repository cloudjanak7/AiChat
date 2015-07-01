//
//  ZHBControllerTool.m
//  AiChat
//
//  Created by 庄彪 on 15/7/1.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBControllerTool.h"
#import <UIKit/UIKit.h>

@implementation ZHBControllerTool

/**
 *  @brief  选择启动界面
 */
+ (void)chooseRootViewController {
    //版本Key
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    //从沙盒种获取上次版本信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    //获得当前版本信息
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        //版本相等，显示登录界面
        
        //读取本地存储的账户信息
        if (/* DISABLES CODE */ (NO)) {
            //有存储,显示主页
            [self showStoryboardWithLogonState:YES];
        } else {
            //无存储,转到登录界面
            [self showStoryboardWithLogonState:NO];
        }
    } else {
        //版本不相等，显示新特性界面
        
        //存储当前版本信息到沙盒中
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

#pragma mark 根据用户登录状态加载对应的Storyboard显示
+ (void)showStoryboardWithLogonState:(BOOL)isUserLogon
{
    
    UIStoryboard *storyboard = nil;
    
    if (isUserLogon) {
        // 显示Main.storyboard
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    } else {
        // 显示Login.sotryboard
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    }
    
    // 在主线程队列负责切换Storyboard，而不影响后台代理的数据处理
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        // 把Storyboard的初始视图控制器设置为window的rootViewController
        [window setRootViewController:storyboard.instantiateInitialViewController];
        
        if (!window.isKeyWindow) {
            [window makeKeyAndVisible];
        }
    });
}


@end
