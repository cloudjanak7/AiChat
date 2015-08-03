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
//#import "RegexKitLite.h"
#import "ZHBRegexResult.h"
#import "ZHBEmotion.h"
#import "ZHBEmotionTool.h"
#import "ZHBEmotionAttachment.h"

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

//    NSAttributedString *attributedString = [self attributedStringWithText:self.message.body];
    
    if (self.message.isOutgoing) {
        UIImage *photo = [UIImage imageWithData:[ZHBXMPPTool sharedXMPPTool].xmppvCardModule.myvCardTemp.photo];
        if (!photo) {
            photo = [UIImage imageNamed:@"DefaultHead"];
        }
        self.myHeadImageView.image       = photo;
//        self.myMessageLbl.attributedText = attributedString;
        self.myMessageLbl.text = self.message.body;
    } else {
        UIImage *photo = [UIImage imageWithData:[[ZHBXMPPTool sharedXMPPTool].xmppAvatarModule photoDataForJID:self.message.bareJid]];
        if (!photo) {
            photo = [UIImage imageNamed:@"DefaultHead"];
        }
        self.otherHeadImageView.image       = photo;
//        self.otherMessageLbl.attributedText = attributedString;
        self.otherMessageLbl.text = self.message.body;
    }
    if ((int)[self.message.timestamp timeIntervalSince1970] % 2) {
        self.timeBtn.hidden       = YES;
        self.messageTopX.constant = 10;
    } else {
        self.timeBtn.hidden       = NO;
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

//- (NSArray *)regexResultsWithText:(NSString *)text
//{
//    // 用来存放所有的匹配结果
//    NSMutableArray *regexResults = [NSMutableArray array];
//    
//    // 匹配表情
//    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        ZHBRegexResult *regexResult = [[ZHBRegexResult alloc] init];
//        regexResult.string = *capturedStrings;
//        regexResult.range = *capturedRanges;
//        regexResult.emotion = YES;
//        [regexResults addObject:regexResult];
//    }];
//    
//    // 匹配非表情
//    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        ZHBRegexResult *regexResult = [[ZHBRegexResult alloc] init];
//        regexResult.string = *capturedStrings;
//        regexResult.range = *capturedRanges;
//        regexResult.emotion = NO;
//        [regexResults addObject:regexResult];
//    }];
//    
//    // 排序
//    [regexResults sortUsingComparator:^NSComparisonResult(ZHBRegexResult *rr1, ZHBRegexResult *rr2) {
//        NSUInteger loc1 = rr1.range.location;
//        NSUInteger loc2 = rr2.range.location;
//        return [@(loc1) compare:@(loc2)];
//    }];
//    return regexResults;
//}
//
//- (NSAttributedString *)attributedStringWithText:(NSString *)text
//{
//    // 1.匹配字符串
//    NSArray *regexResults = [self regexResultsWithText:text];
//    
//    // 2.根据匹配结果，拼接对应的图片表情和普通文本
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
//    // 遍历
//    [regexResults enumerateObjectsUsingBlock:^(ZHBRegexResult *result, NSUInteger idx, BOOL *stop) {
//        ZHBEmotion *emotion = nil;
//        if (result.isEmotion) { // 表情
//            emotion = [ZHBEmotionTool emotionWithDesc:result.string];
//        }
//        
//        if (emotion) { // 如果有表情
//            // 创建附件对象
//            ZHBEmotionAttachment *attach = [[ZHBEmotionAttachment alloc] init];
//            
//            // 传递表情
//            attach.emotion = emotion;
//            attach.bounds = CGRectMake(0, -3, CHAT_MESSAGE_FONT.lineHeight, CHAT_MESSAGE_FONT.lineHeight);
//            
//            // 将附件包装成富文本
//            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
//            [attributedString appendAttributedString:attachString];
//        } else { // 非表情（直接拼接普通文本）
//            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
//            [attributedString appendAttributedString:substr];
//        }
//    }];
//    
//    // 设置字体
//    [attributedString addAttribute:NSFontAttributeName value:CHAT_MESSAGE_FONT range:NSMakeRange(0, attributedString.length)];
//    
//    return attributedString;
//}

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
