//
//  ZHBEmotionToolView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionToolView.h"
#import "UIImage+Helper.h"
#import "ZHBNotificationConst.h"
#import "UIView+Frame.h"

@interface ZHBEmotionToolView ()

/*! @brief  当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

/*! @brief  最近 */
@property (nonatomic, strong) UIButton *recentBtn;
/*! @brief  默认 */
@property (nonatomic, strong) UIButton *defaultBtn;
/*! @brief  Emoji */
@property (nonatomic, strong) UIButton *emojiBtn;
/*! @brief  浪小花 */
@property (nonatomic, strong) UIButton *lxhBtn;

/*! @brief  背景 */
@property (nonatomic, strong) UIImageView *imageView;

@end

static NSInteger const kEmotionToolButtonMaxCount = 4;

@implementation ZHBEmotionToolView

#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.contents = (id)[UIImage resizedImageNamed:@"buttontoolbarBkg_white"].CGImage;
        // 1.添加4个按钮
        [self addSubview:self.recentBtn];
        [self addSubview:self.defaultBtn];
        [self addSubview:self.emojiBtn];
        [self addSubview:self.lxhBtn];
        
        // 2.监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:ZHBEmotionDidSelectedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 设置工具条按钮的frame
    CGFloat buttonW = self.width / kEmotionToolButtonMaxCount;
    CGFloat buttonH = self.height;
    for (NSInteger index = 0; index < kEmotionToolButtonMaxCount; index ++) {
        if ([self.subviews[index] isKindOfClass:[UIButton class]]) {
            UIButton *button = self.subviews[index];
            button.width = buttonW;
            button.height = buttonH;
            button.x = button.tag * buttonW;
        }
    }
}

#pragma mark -
#pragma mark Event Response

- (void)emotionDidSelected:(NSNotification *)noti {
    if (self.selectedButton.tag == ZHBEmotionTypeRecent) {
        [self didClickemotionTypeButton:self.selectedButton];
    }
}

- (void)didClickemotionTypeButton:(UIButton *)sender {
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(didSelectedEmotionToolViewButton:)]) {
        [self.delegate didSelectedEmotionToolViewButton:sender.tag];
    }
}

#pragma mark-
#pragma mark Private Methods

/**
 *  添加按钮
 *
 *  @param title 按钮文字
 */
- (UIButton *)setupButtonWithTag:(ZHBEmotionType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(didClickemotionTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = CHAT_TIME_FONT;
    [button setBackgroundImage:[UIImage resizedImageNamed:@"EmotionsBagTabBg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizedImageNamed:@"EmotionsBagTabBgFocus"] forState:UIControlStateHighlighted];
    return button;
}

#pragma mark -
#pragma mark Getters

- (UIButton *)recentBtn {
    if (nil == _recentBtn) {
        _recentBtn = [self setupButtonWithTag:ZHBEmotionTypeRecent];
        [_recentBtn setImage:[UIImage imageNamed:@"EmotionCustomHL"] forState:UIControlStateNormal];
    }
    return _recentBtn;
}

- (UIButton *)defaultBtn {
    if (nil == _defaultBtn) {
        _defaultBtn = [self setupButtonWithTag:ZHBEmotionTypeDefault];
        [_defaultBtn setImage:[UIImage imageNamed:@"EmotionsBagAdd"] forState:UIControlStateNormal];
    }
    return _defaultBtn;
}

- (UIButton *)emojiBtn {
    if (nil == _emojiBtn) {
        _emojiBtn = [self setupButtonWithTag:ZHBEmotionTypeEmoji];
        [_emojiBtn setImage:[UIImage imageNamed:@"EmotionsEmojiHL"] forState:UIControlStateNormal];
    }
    return _emojiBtn;
}

- (UIButton *)lxhBtn {
    if (nil == _lxhBtn) {
        _lxhBtn = [self setupButtonWithTag:ZHBEmotionTypeLxh];
        [_lxhBtn setImage:[UIImage imageNamed:@"EmotionsSetting"] forState:UIControlStateNormal];
    }
    return _lxhBtn;
}

- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage resizedImageNamed:@"buttontoolbarBkg_white"];
    }
    return _imageView;
}

#pragma mark -
#pragma mark Setters
- (void)setDelegate:(id<ZHBEmotionToolViewDelegate>)delegate
{
    _delegate = delegate;
    
    // 获得“默认”按钮
    UIButton *defaultButton = (UIButton *)[self viewWithTag:ZHBEmotionTypeDefault];
    // 默认选中“默认”按钮
    [self didClickemotionTypeButton:defaultButton];
}

@end
