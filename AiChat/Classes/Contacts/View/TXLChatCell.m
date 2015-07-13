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

#define TIME_BTN_FONT [UIFont boldSystemFontOfSize:12]
#define MESSAGE_BTN_FONT [UIFont systemFontOfSize:18]

@interface TXLChatCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBtnHeight;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet UIButton *otherHeadBtn;

@property (weak, nonatomic) IBOutlet UIButton *otherMessageBtn;

@property (weak, nonatomic) IBOutlet UIButton *myHeadBtn;

@property (weak, nonatomic) IBOutlet UIButton *myMessageBtn;

@end

@implementation TXLChatCell

#pragma mark -
#pragma mark Life Cycle
- (void)awakeFromNib {
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.timeBtn.titleLabel.font         = TIME_BTN_FONT;
    self.myMessageBtn.titleLabel.font    = MESSAGE_BTN_FONT;
    self.otherMessageBtn.titleLabel.font = MESSAGE_BTN_FONT;
    
    self.timeBtn.userInteractionEnabled = NO;
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.timeBtn setBackgroundImage:[UIImage resizedImageNamed:@"MessageContent_TimeNodeBkg"] forState:UIControlStateNormal];
    
    self.otherMessageBtn.titleLabel.numberOfLines = 0;
    [self.otherHeadBtn setBackgroundImage:[UIImage resizedImageNamed:@"DefaultHead"] forState:UIControlStateNormal];
    [self.otherHeadBtn setBackgroundImage:[UIImage resizedImageNamed:@"DefaultHead"] forState:UIControlStateHighlighted];
    [self.otherMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"ReceiverTextNodeBkg" width:0.5 height:0.7] forState:UIControlStateNormal];
    [self.otherMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"ReceiverTextNodeBkgHL" width:0.5 height:0.7] forState:UIControlStateHighlighted];
    
    self.myMessageBtn.titleLabel.numberOfLines = 0;
    [self.myHeadBtn setBackgroundImage:[UIImage resizedImageNamed:@"DefaultHead"] forState:UIControlStateNormal];
    [self.myHeadBtn setBackgroundImage:[UIImage resizedImageNamed:@"DefaultHead"] forState:UIControlStateHighlighted];
    [self.myMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"SenderTextNodeBkg" width:0.5 height:0.7] forState:UIControlStateNormal];
    [self.myMessageBtn setBackgroundImage:[UIImage resizedImageNamed:@"SenderTextNodeBkgHL" width:0.5 height:0.7] forState:UIControlStateHighlighted];
}

#pragma mark -
#pragma mark Private Methods
- (void)setupMessage {
    self.otherMessageBtn.hidden = self.message.isOutgoing;
    self.otherHeadBtn.hidden    = self.message.isOutgoing;
    self.myHeadBtn.hidden       = !self.message.isOutgoing;
    self.myMessageBtn.hidden    = !self.message.isOutgoing;
    if (self.message.isOutgoing) {
        [self.myMessageBtn setTitle:self.message.body forState:UIControlStateNormal];
    } else {
        [self.otherMessageBtn setTitle:self.message.body forState:UIControlStateNormal];
    }
    if (self.message.timestamp) {
        self.timeBtnHeight.constant = 20;
        [self.timeBtn setTitle:[self.message.timestamp timeString] forState:UIControlStateNormal];
    } else {
        self.timeBtnHeight.constant = 0;
    }
}

- (CGFloat)calCellHeight {
    CGFloat defaultCellHeight = 65;
    CGFloat leftX = 10;
    CGFloat margin = 5;
    CGFloat rightX = 60;
    CGFloat headW = 45;
    CGSize messageSize = [self.message.body calculateSize:CGSizeMake(self.width - leftX - headW - margin - rightX, MAXFLOAT) font:MESSAGE_BTN_FONT];
    return 30 + defaultCellHeight + messageSize.height - 20;
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
