//
//  ZHBEmotionGridView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionGridView.h"
#import "UIImage+Helper.h"
#import "ZHBEmotion.h"
#import "ZHBEmotionView.h"
#import "ZHBEmotionTool.h"
#import "UIView+Frame.h"
#import "ZHBNotificationConst.h"

@interface ZHBEmotionGridView ()

/*! @brief  删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
/*! @brief  存储ZHBEmotionView */
@property (nonatomic, strong) NSMutableArray *emotionViews;

@end


@implementation ZHBEmotionGridView

#pragma mark -
#pragma mark Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    
    // 1.排列所有的表情
    NSInteger count = self.emotionViews.count;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / kEmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / kEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.x = leftInset + (i % kEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / kEmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
    
    // 2.删除按钮
    self.deleteBtn.width = emotionViewW;
    self.deleteBtn.height = emotionViewH;
    self.deleteBtn.x = self.width - leftInset - self.deleteBtn.width;
    self.deleteBtn.y = self.height - self.deleteBtn.height;
}

#pragma mark -
#pragma mark Event Response
- (void)didClickDeleteButton {
    DDLOG_INFO
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ZHBEmotionDidDeletedNotification object:nil userInfo:nil];
}

- (void)didClickEmotion:(ZHBEmotionView *)sender {
    DDLOG_INFO
    if (sender.emotion == nil) return;
    // 保存使用记录
    [ZHBEmotionTool addRecentEmotion:sender.emotion];
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ZHBEmotionDidSelectedNotification object:nil userInfo:@{ZHBEmotionSelectKey : sender.emotion}];
}

#pragma mark -
#pragma mark Getters
- (UIButton *)deleteBtn {
    if (nil == _deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [_deleteBtn addTarget:self action:@selector(didClickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (NSMutableArray *)emotionViews
{
    if (nil == _emotionViews) {
        _emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

#pragma mark Setters
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 添加新的表情
    NSInteger count = emotions.count;
    NSInteger currentEmotionViewCount = self.emotionViews.count;
    for (NSInteger index = 0; index < count; index ++) {
        ZHBEmotionView *emotionView = nil;
        if (index >= currentEmotionViewCount) { // emotionView不够用
            emotionView = [[ZHBEmotionView alloc] init];
            [emotionView addTarget:self action:@selector(didClickEmotion:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
        } else { // emotionView够用
            emotionView = self.emotionViews[index];
        }
        // 传递模型数据
        emotionView.emotion = emotions[index];
        emotionView.hidden = NO;
    }
    
    // 隐藏多余的emotionView
    for (NSInteger index = count; index < currentEmotionViewCount; index ++) {
        UIButton *emotionView = self.emotionViews[index];
        emotionView.hidden = YES;
    }
}
@end
