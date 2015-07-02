//
//  AppDelegate.m
//  AiChat
//
//  Created by 庄彪 on 15/6/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHBControllerTool.h"
#import "DDLogConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLogConfig setupLogConfig];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    DDLogInfo(@"选择启动界面info");
    [ZHBControllerTool chooseRootViewController];

    return YES;
}

@end
