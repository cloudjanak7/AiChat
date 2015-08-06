//
//  ZHBTextChatCell.m
//  AiChat
//
//  Created by 庄彪 on 15/8/5.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBTextChatCell.h"

@interface ZHBTextChatCell ()

/*! @brief  消息内容 */
@property (nonatomic, strong) UILabel *messageLbl;

@end

@implementation ZHBTextChatCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.messageLbl];
        [self setupDefaultView];
    }
    return self;
}

#pragma mark - Private Methods
- (void)setupDefaultView {
//    self
}

#pragma mark - Getters

- (UILabel *)messageLbl {
    if (nil == _messageLbl) {
        _messageLbl = [[UILabel alloc] init];
    }
    return _messageLbl;
}

@end
