//
//  AppDelegate.m
//  AiChat
//
//  Created by 庄彪 on 15/6/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHBControllerTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [ZHBControllerTool chooseRootViewController];
    return YES;
}

@end
