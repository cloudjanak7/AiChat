//
//  ZHBChatCell.m
//  AiChat
//
//  Created by 庄彪 on 15/8/5.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBChatCell.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "UIImage+Helper.h"
#import "NSDate+Helper.h"
#import "NSString+Helper.h"
#import "UIView+Frame.h"
#import "ZHBXMPPTool.h"
#import "ZHBEmotionTool.h"

@interface ZHBChatCell ()

/*! @brief  头像 */
@property (nonatomic, strong) UIImageView *headImageView;
/*! @brief  消息背景 */
@property (nonatomic, strong) UIImageView *messageBgImageView;

@end

@implementation ZHBChatCell

#pragma mark -
#pragma mark Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headImageView];
        [self addSubview:self.messageBgImageView];
    }
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)setupMineLayout {
    __weak typeof(self) weakSelf = self;
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.messageBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(5);
        make.top.equalTo(weakSelf.headImageView);
        make.right.greaterThanOrEqualTo(weakSelf.mas_right).offset(60);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

- (void)setupOtherLayout {
    __weak typeof(self) weakSelf = self;
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.messageBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.headImageView.mas_left).offset(-5);
        make.top.equalTo(weakSelf.headImageView);
        make.left.greaterThanOrEqualTo(weakSelf.mas_left).offset(60);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

#pragma mark -
#pragma mark Getters

- (UIImageView *)headImageView {
    if (nil == _headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UIImageView *)messageBgImageView {
    if (nil == _messageBgImageView) {
        _messageBgImageView = [[UIImageView alloc] init];
    }
    return _messageBgImageView;
}

#pragma mark Setters

- (void)setMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    _message = message;
    if (message.isOutgoing) {
        [self setupMineLayout];
    } else {
        [self setupOtherLayout];
    }
}

@end
