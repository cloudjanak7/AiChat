//
//  TXLContactsNC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLContactsNC.h"

@interface TXLContactsNC ()

@end

@implementation TXLContactsNC

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
    UIImage *norImage = [UIImage originalImageNamed:@"tabbar_contacts"];
    UIImage *selImage = [UIImage originalImageNamed:@"tabbar_contactsHL"];
    NSString *title = @"通讯录";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:selImage];
    self.tabBarItem.tag = TabBarItemTagOfContacts;
}

@end
