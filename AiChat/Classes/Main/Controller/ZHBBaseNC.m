//
//  ZHBBaseNC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBBaseNC.h"
#import "ZHBColorMacro.h"
#import "UIImage+Helper.h"

@interface ZHBBaseNC ()

@end

@implementation ZHBBaseNC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)awakeFromNib {
    [self setupTabBarItems];
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

#pragma mark -
#pragma mark Private Methods
- (void)setupTabBarItems {
    NSString *configPath  = [[NSBundle mainBundle] pathForResource:@"TabBar" ofType:@"plist"];
    NSArray *tabBarCfgs   = [NSArray arrayWithContentsOfFile:configPath];
    
    NSDictionary *cfgDict = [tabBarCfgs objectAtIndex:self.tabBarItem.tag];
    UIImage *norImage     = [UIImage originalImageNamed:cfgDict[@"norImage"]];
    UIImage *selImage     = [UIImage originalImageNamed:cfgDict[@"selImage"]];
    NSString *title       = cfgDict[@"title"];
    
    self.tabBarItem       = [[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:selImage];
}

@end
