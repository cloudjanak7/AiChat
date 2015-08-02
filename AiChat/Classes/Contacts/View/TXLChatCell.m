//
//  TXLChatCell.m
//  AiChat
//
//  Created by 庄彪 on 15/7/12.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLChatCell.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "UIImage+Helper.h"
#import "NSDate+Helper.h"
#import "NSString+Helper.h"
#import "UIView+Frame.h"
#import "ZHBXMPPTool.h"
#import "ZHBFontMacro.h"

@interface TXLChatCell ()
/*! @brief  对方消息最大宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherMessageBgMaxW;
/*! @brief  我的消息最大宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myMessageBgMaxW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTopX;
/*! @brief  消息时间 */
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
/*! @brief  对方头像 */
@property (weak, nonatomic) IBOutlet UIImageView *otherHeadImageView;
/*! @brief  我的头像 */
@property (weak, nonatomic) IBOutlet UIImageView *myHeadImageView;
/*! @brief  对方消息内容 */
@property (weak, nonatomic) IBOutlet UILabel *otherMessageLbl;
/*! @brief  我的消息内容 */
@property (weak, nonatomic) IBOutlet UILabel *myMessageLbl;
/*! @brief  对方消息背景 */
@property (weak, nonatomic) IBOutlet UIImageView *otherMessageBgImageView;
/*! @brief  我的消息背景 */
@property (weak, nonatomic) IBOutlet UIImageView *myMessageBgImageView;

@end

@implementation TXLChatCell

#pragma mark -
#pragma mark Life Cycle
- (void)awakeFromNib {
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    //设置消息最长宽度
    //屏幕宽度 - 头像宽度*2 - 距离边框距离*2 - 距离消息距离*2
    CGFloat messageMaxW              = [UIScreen mainScreen].bounds.size.width - 110;
    self.otherMessageBgMaxW.constant = messageMaxW;
    self.myMessageBgMaxW.constant    = messageMaxW;
    
    //设置时间样式
    self.timeBtn.titleLabel.font = CHAT_TIME_FONT;
    self.timeBtn.userInteractionEnabled = NO;
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.timeBtn setBackgroundImage:[UIImage resizedImageNamed:@"MessageContent_TimeNodeBkg"] forState:UIControlStateNormal];

    //设置消息内容样式
    self.otherMessageLbl.font = CHAT_MESSAGE_FONT;
    self.otherMessageLbl.numberOfLines = 0;
    self.otherMessageLbl.textAlignment = NSTextAlignmentLeft;
    self.otherMessageBgImageView.image = [UIImage resizedImageNamed:@"ReceiverTextNodeBkg"];
    self.otherMessageBgImageView.highlightedImage = [UIImage resizedImageNamed:@"ReceiverTextNodeBkgHL"];
    
    self.myMessageLbl.font = CHAT_MESSAGE_FONT;
    self.myMessageLbl.numberOfLines = 0;
    self.myMessageLbl.textAlignment = NSTextAlignmentLeft;
    self.myMessageBgImageView.image = [UIImage resizedImageNamed:@"SenderTextNodeBkg"];
    self.myMessageBgImageView.highlightedImage = [UIImage resizedImageNamed:@"SenderTextNodeBkgHL"];
}

#pragma mark -
#pragma mark Private Methods
- (void)setupMessage {
    self.otherMessageBgImageView.hidden = self.message.isOutgoing;
    self.otherMessageLbl.hidden         = self.message.isOutgoing;
    self.otherHeadImageView.hidden      = self.message.isOutgoing;
    self.myMessageBgImageView.hidden    = !self.message.isOutgoing;
    self.myMessageLbl.hidden            = !self.message.isOutgoing;
    self.myHeadImageView.hidden         = !self.message.isOutgoing;

    if (self.message.isOutgoing) {
        UIImage *photo = [UIImage imageWithData:[ZHBXMPPTool sharedXMPPTool].xmppvCardModule.myvCardTemp.photo];
        if (!photo) {
            photo = [UIImage imageNamed:@"DefaultHead"];
        }
        self.myHeadImageView.image = photo;
        self.myMessageLbl.text     = self.message.body;
    } else {
        UIImage *photo = [UIImage imageWithData:[[ZHBXMPPTool sharedXMPPTool].xmppAvatarModule photoDataForJID:self.message.bareJid]];
        if (!photo) {
            photo = [UIImage imageNamed:@"DefaultHead"];
        }
        self.otherHeadImageView.image = photo;
        self.otherMessageLbl.text     = self.message.body;
    }
    if ((int)[self.message.timestamp timeIntervalSince1970] % 2) {
        self.timeBtn.hidden = YES;
        self.messageTopX.constant = 10;
    } else {
        self.timeBtn.hidden = NO;
        self.messageTopX.constant = 30;
    }
    [self.timeBtn setTitle:[self.message.timestamp formatIMDate] forState:UIControlStateNormal];
}

- (CGFloat)calCellHeight {
    //消息宽度 = 消息宽度约束 - 内容距离背景左右间距
    CGFloat messageLblW = self.otherMessageBgMaxW.constant - 40;
    CGSize messageSize = [self.message.body calculateSize:CGSizeMake(messageLblW , MAXFLOAT) font:CHAT_MESSAGE_FONT];
    //消息高度 = 内容高度 + 距离背景的上下间距 - 距离顶部的高度
    return messageSize.height + 30 + self.messageTopX.constant;
}

#pragma mark -
#pragma mark Setters

- (void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    _message = message;
    [self setupMessage];
}

- (CGFloat)height {
    if (0 == _height) {
        _height = [self calCellHeight];
    }
    return _height;
}

@end
