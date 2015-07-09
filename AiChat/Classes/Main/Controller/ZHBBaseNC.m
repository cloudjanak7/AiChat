//
//  ZHBBaseNC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBBaseNC.h"
#import "ZHBColorMacro.h"

@interface ZHBBaseNC ()

@end

@implementation ZHBBaseNC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.tintColor = TAB_BAR_TINT_COLOR;
}

#pragma mark -
#pragma mark Override Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
