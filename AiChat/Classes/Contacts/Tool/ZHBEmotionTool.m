//
//  ZHBEmotionTool.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionTool.h"
#import "ZHBEmotion.h"
#import "ZHBEmotionGridView.h"

#define ZHBEmotionRecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

/*! 默认表情 */
static NSArray *_defaultEmotions;
/*! emoji表情 */
static NSArray *_emojiEmotions;
/*! 浪小花表情 */
static NSArray *_lxhEmotions;
/*! 最近表情 */
static NSMutableArray *_recentEmotions;

@implementation ZHBEmotionTool

+ (NSArray *)defaultEmotions
{
    if (nil == _defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        _defaultEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (nil == _emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        _emojiEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (nil == _lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        _lxhEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:ZHBEmotionRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
+ (void)addRecentEmotion:(ZHBEmotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    if (_recentEmotions.count > kEmotionMaxCountPerPage) {
        [_recentEmotions removeObjectsInRange:NSMakeRange(kEmotionMaxCountPerPage, _recentEmotions.count - kEmotionMaxCountPerPage)];
    }
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:ZHBEmotionRecentFilepath];
}

+ (ZHBEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block ZHBEmotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(ZHBEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(ZHBEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

@end
