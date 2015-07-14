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
}

- (BOOL)isValidUserName:(NSString *)name {
    return name.length >= 4;
}

@end
