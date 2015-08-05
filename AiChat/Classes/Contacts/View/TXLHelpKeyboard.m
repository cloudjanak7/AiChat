//
//  ZHBHelpKeyboard.m
//  AiChat
//
//  Created by 庄彪 on 15/8/4.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLHelpKeyboard.h"
#import "UIView+Frame.h"
#import "UIImage+Helper.h"

@interface TXLHelpKeyboard ()

/*! @brief  添加图片 */
@property (nonatomic, strong) UIButton *picBtn;
/*! @brief  添加视频 */
@property (nonatomic, strong) UIButton *videoBtn;
/*! @brief  添加位置 */
@property (nonatomic, strong) UIButton *locationBtn;
/*! @brief  收藏 */
@property (nonatomic, strong) UIButton *favBtn;
/*! @brief  短视频 */
@property (nonatomic, strong) UIButton *sightBtn;
/*! @brief  声音 */
@property (nonatomic, strong) UIButton *voiceBtn;
/*! @brief  更多 */
@property (nonatomic, strong) UIButton *moreBtn;

/*! @brief  背景 */
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation TXLHelpKeyboard

#pragma mark -
#pragma mark Public Methods
+ (instancetype)helpKeyboard {
    return [[self alloc] init];
}

#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.picBtn];
        [self addSubview:self.sightBtn];
        [self addSubview:self.videoBtn];
        [self addSubview:self.voiceBtn];
        [self addSubview:self.locationBtn];
        [self addSubview:self.favBtn];
        [self addSubview:self.moreBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
    // 设置工具条按钮的frame
    NSUInteger maxCols = 4;
    NSUInteger currentRows = (self.subviews.count - 1 + maxCols) / maxCols;
    CGFloat buttonW = 59;
    CGFloat buttonH = 59;
    CGFloat marginX = (self.width - maxCols * buttonW) / (maxCols + 1);
    CGFloat marginY = (self.height - currentRows * buttonH) / (currentRows + 1);
    
    for (NSUInteger index = 0; index < self.subviews.count; index ++) {
        if ([self.subviews[index] isKindOfClass:[UIButton class]]) {
            UIButton *button = self.subviews[index];
            button.width = buttonW;
            button.height = buttonH;
            button.x = (button.tag % maxCols + 1) * marginX + (button.tag % maxCols) * buttonW;
            button.y = (button.tag / maxCols + 1) * marginY + (button.tag / maxCols) * buttonH;
        }
    }
}

#pragma mark -
#pragma mark Event Response 
- (void)didClickedKeyboardButton:(UIButton *)sender {
    DDLOG_INFO
    if (self.shareOperation) {
        self.shareOperation(sender.tag);
    }
}

#pragma mark -
#pragma mark Private Methods

- (UIButton *)setupButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage resizedImageNamed:@"sharemore_other"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImageNamed:@"sharemore_other_HL"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(didClickedKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark -
#pragma mark Getters

- (UIButton *)picBtn {
    if (nil == _picBtn) {
        _picBtn = [self setupButton];
        [_picBtn setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        _picBtn.tag = TXLShareTypePic;
    }
    return _picBtn;
}

- (UIButton *)sightBtn {
    if (nil == _sightBtn) {
        _sightBtn = [self setupButton];
        [_sightBtn setImage:[UIImage imageNamed:@"sharemore_sight"] forState:UIControlStateNormal];
        _sightBtn.tag = TXLShareTypeSight;
    }
    return _sightBtn;
}

- (UIButton *)videoBtn {
    if (nil == _videoBtn) {
        _videoBtn = [self setupButton];
        [_videoBtn setImage:[UIImage imageNamed:@"sharemore_videovoip"] forState:UIControlStateNormal];
        _videoBtn.tag = TXLShareTypeVideo;
    }
    return _videoBtn;
}

- (UIButton *)voiceBtn {
    if (nil == _voiceBtn) {
        _voiceBtn = [self setupButton];
        [_voiceBtn setImage:[UIImage imageNamed:@"sharemore_voiceinput"] forState:UIControlStateNormal];
        _voiceBtn.tag = TXLShareTypeVoice;
    }
    return _voiceBtn;
}

- (UIButton *)favBtn {
    if (nil == _favBtn) {
        _favBtn = [self setupButton];
        [_favBtn setImage:[UIImage imageNamed:@"sharemore_myfav"] forState:UIControlStateNormal];
        _favBtn.tag = TXLShareTypeFav;
    }
    return _favBtn;
}

- (UIButton *)locationBtn {
    if (nil == _locationBtn) {
        _locationBtn = [self setupButton];
        [_locationBtn setImage:[UIImage imageNamed:@"sharemore_location"] forState:UIControlStateNormal];
        _locationBtn.tag = TXLShareTypeLocation;
    }
    return _locationBtn;
}

- (UIButton *)moreBtn {
    if (nil == _moreBtn) {
        _moreBtn = [self setupButton];
        [_moreBtn setImage:[UIImage imageNamed:@"sharemorePay"] forState:UIControlStateNormal];
        _moreBtn.tag = TXLShareTypeOther;
    }
    return _moreBtn;
}

- (UIImageView *)bgImageView {
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage resizedImageNamed:@"buttontoolbarBkg_white"];
    }
    return _bgImageView;
}

@end
