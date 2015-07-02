//
//  ZHBLoginVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/1.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBLoginVC.h"
#import <ReactiveCocoa.h>

@interface ZHBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTxtf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtf;

@end

@implementation ZHBLoginVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.userNameTxtf.rac_textSignal filter:^BOOL(id value) {
        NSString *userName = value;
        return userName.length >= 4;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

@end
