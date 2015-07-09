//
//  XXMessagesNC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "XXMessagesNC.h"

@interface XXMessagesNC ()

@end

@implementation XXMessagesNC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTabBarItem];
}

#pragma mark -
#pragma mark Private Methods

- (void)setupTabBarItem {
    UIImage *norImage = [UIImage originalImageNamed:@"tabbar_mainframe"];
    UIImage *selImage = [UIImage originalImageNamed:@"tabbar_mainframeHL"];
    NSString *title = @"消息";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:selImage];
    self.tabBarItem.tag = TabBarItemTagOfMessages;
}

@end
