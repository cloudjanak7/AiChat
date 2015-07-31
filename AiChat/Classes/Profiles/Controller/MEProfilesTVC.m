//
//  MEProfilesTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "MEProfilesTVC.h"
#import "XMPPvCardTemp.h"
#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"
#import <ReactiveCocoa.h>

@interface MEProfilesTVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *accountLbl;

@property (weak, nonatomic) IBOutlet UIButton *qrImageBtn;

@end


@implementation MEProfilesTVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultStyle];
    [self setupSignal];
    [self setupAccountInfo];
}

#pragma mark -
#pragma mark Private Methods

- (void)setupSignal {
    @weakify(self);
    [[ZHBXMPPTool sharedXMPPTool].rac_myVCardUpdateSignal subscribeNext:^(id x) {
        @strongify(self);
        [self setupAccountInfo];
    }];
}

- (void)setupDefaultStyle {
    self.accountLbl.font = TITLE_FONT;
    self.accountLbl.textColor = SUB_TITLE_COLOR;
}

- (void)setupAccountInfo {
    XMPPvCardTemp *vCard = [ZHBXMPPTool sharedXMPPTool].xmppvCardModule.myvCardTemp;
    if (vCard.photo) {
        self.headImageView.image = [UIImage imageWithData:vCard.photo];
    }
    if (vCard.nickname) {
        self.nickNameLbl.text = vCard.nickname;
    } else {
        self.nickNameLbl.text = [ZHBUserInfo sharedUserInfo].name;
    }
    self.accountLbl.text = [@"帐号 ：" stringByAppendingString:[ZHBUserInfo sharedUserInfo].name];
    [self.tableView layoutSubviews];
}

@end
