//
//  ZHBEmotionKeyboard.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionKeyboard.h"
#import "ZHBEmotionListView.h"
#import "ZHBEmotionTool.h"
#import "UIImage+Helper.h"
#import "UIView+Frame.h"
#import "ZHBEmotionToolView.h"

@interface ZHBEmotionKeyboard ()<ZHBEmotionToolViewDelegate>

/*! 表情列表 */
@property (nonatomic, strong) ZHBEmotionListView *listView;

/*! @brief  emotion工具条 */
@property (nonatomic, strong) ZHBEmotionToolView *toolView;

/*! @brief  背景 */
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZHBEmotionKeyboard

#pragma mark -
#pragma mark Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.imageView];
        [self addSubview:self.listView];
        [self addSubview:self.toolView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    self.toolView.width = self.width;
    self.toolView.height = 40;
    self.toolView.y = self.height - self.toolView.height;

    self.listView.width = self.width;
    self.listView.height = self.toolView.y;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)emotionKeyboard {
    return [[self alloc] init];
}

#pragma mark -
#pragma mark ZHBEmotionToolView Delegate
- (void)didSelectedEmotionToolViewButton:(ZHBEmotionType)emotionType {
    switch (emotionType) {
        case ZHBEmotionTypeDefault:
            self.listView.emotions = [ZHBEmotionTool defaultEmotions];
            break;
        case ZHBEmotionTypeEmoji:
            self.listView.emotions = [ZHBEmotionTool emojiEmotions];
            break;
        case ZHBEmotionTypeLxh:
            self.listView.emotions = [ZHBEmotionTool lxhEmotions];
            break;
        case ZHBEmotionTypeRecent:
            self.listView.emotions = [ZHBEmotionTool recentEmotions];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Getters

- (ZHBEmotionListView *)listView {
    if (nil == _listView) {
        _listView = [[ZHBEmotionListView alloc] init];
    }
    return _listView;
}

- (ZHBEmotionToolView *)toolView {
    if (nil == _toolView) {
        _toolView = [[ZHBEmotionToolView alloc] init];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage resizedImageNamed:@"buttontoolbarBkg_white"];
    }
    return _imageView;
}

@end
