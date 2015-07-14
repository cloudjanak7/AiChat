//
//  TXLAddFriendVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/14.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLAddFriendVC.h"
#import "UIImage+Helper.h"
#import "ZHBXMPPTool.h"
#import "NSString+Helper.h"
#import "ZHBUserInfo.h"
#import "ZHBXMPPConst.h"
#import "MBProgressHUD+ZHB.h"
#import <ReactiveCocoa.h>

@interface TXLAddFriendVC ()

@property (weak, nonatomic) IBOutlet UITextField *userTxtf;

@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@end

@implementation TXLAddFriendVC
#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultView];
    [self setupSignal];
}

#pragma mark -
#pragma mark Private Methods
- (void)setupDefaultView {
    self.userTxtf.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_searchicon"]];
    self.userTxtf.background = [UIImage imageNamed:@"Connectkeyboad_line"];
    self.addFriendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.addFriendBtn setBackgroundImage:[UIImage resizedImageNamed:@"OpBigBtnHighlight"] forState:UIControlStateDisabled];
    [self.addFriendBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBigBtn"] forState:UIControlStateNormal];
    [self.addFriendBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBigBtnHighlight"] forState:UIControlStateHighlighted];
}

- (void)setupSignal {
    @weakify(self);
    RACSignal *validUsernameSignal = [self.userTxtf.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        return @([self isValidUserName:value]);
    }];
    
    [validUsernameSignal subscribeNext:^(NSNumber *enble) {
        @strongify(self);
        self.addFriendBtn.enabled = [enble boolValue];
    }];
    
    [[[self.addFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:self.userTxtf.text];
            return nil;
        }];
    }] subscribeNext:^(NSString *userName) {
        @strongify(self);
        [self addFriend:userName];
    }];
}

- (BOOL)isValidUserName:(NSString *)name {
    return [name trimString].length >= 4;
}

- (void)addFriend:(NSString *)userName {
    
    if ([[ZHBXMPPTool sharedXMPPTool] userExistsWithJID:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户已经是好友,无需添加!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[ZHBXMPPTool sharedXMPPTool] subscribeUser:userName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加好友请求已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    @weakify(self);
    [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
