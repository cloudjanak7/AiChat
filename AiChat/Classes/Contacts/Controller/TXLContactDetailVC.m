//
//  TXLContactDetailVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/13.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLContactDetailVC.h"
#import "UIImage+Helper.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "TXLChatVC.h"
#import <ReactiveCocoa.h>

@interface TXLContactDetailVC ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UILabel *sourceLbl;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoChatBtn;

@end

@implementation TXLContactDetailVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultView];
    [self setupUserDetail];
    [self setupSignal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TXLChatVC class]]) {
        TXLChatVC *chatVc = segue.destinationViewController;
        chatVc.friendUser = self.user;
    }
}

#pragma mark -
#pragma mark Private Methods
- (void)setupUserDetail {
    if (self.user.photo) {
        [self.headBtn setBackgroundImage:self.user.photo forState:UIControlStateNormal];
    } else {
        [self.headBtn setBackgroundImage:[UIImage imageNamed:@"DefaultHead"] forState:UIControlStateNormal];
    }
    self.titleLbl.text = self.user.displayName;
    self.userNameLbl.text = self.user.jidStr;
}

- (void)setupDefaultView {
    self.sendMessageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.videoChatBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.sendMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBigBtn"] forState:UIControlStateNormal];
    [self.sendMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBigBtnHighlight"] forState:UIControlStateHighlighted];
    [self.videoChatBtn setBackgroundImage:[UIImage resizedImageNamed:@"OpBigBtn"] forState:UIControlStateNormal];
    [self.videoChatBtn setBackgroundImage:[UIImage resizedImageNamed:@"OpBigBtnHighlight"] forState:UIControlStateHighlighted];
}

- (void)setupSignal {
    
}

#pragma mark -
#pragma mark Setters


@end
