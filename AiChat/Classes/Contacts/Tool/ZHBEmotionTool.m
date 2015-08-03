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
#import "ZHBEmotionAttachment.h"
#import "ZHBRegexResult.h"
//#import "RegexKitLite.h"

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

#pragma mark - 
#pragma mark Public Methods

+ (NSArray *)defaultEmotions {
    if (nil == _defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        _defaultEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions {
    if (nil == _emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        _emojiEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions {
    if (nil == _lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        _lxhEmotions = [ZHBEmotion emotionsWithFile:plist];
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions {
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:ZHBEmotionRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

+ (void)addRecentEmotion:(ZHBEmotion *)emotion {
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

+ (ZHBEmotion *)emotionWithDesc:(NSString *)desc {
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

+ (NSAttributedString *)emotionAttributedString:(ZHBEmotion *)emotion font:(UIFont *)font {
    ZHBEmotionAttachment *attach = [[ZHBEmotionAttachment alloc] init];
    attach.emotion = emotion;
    attach.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
    return [NSAttributedString attributedStringWithAttachment:attach];
}

+ (NSString *)stringWithEmotionAttributedString:(NSAttributedString *)attributedString {
    NSMutableString *string = [NSMutableString string];
    
    // 遍历富文本里面的所有内容
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        ZHBEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { // 如果是带有附件的富文本
            [string appendString:attach.emotion.chs];
        } else { // 普通的文本
            // 截取range范围的普通文本
            NSString *substr = [attributedString attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    
    return string;
}

+ (NSAttributedString *)emotionsAttributedStringWithString:(NSString *)string font:(UIFont *)font {
    // 1.匹配字符串
    NSArray *regexResults = [ZHBEmotionTool regexResultsWithString:string];

    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(ZHBRegexResult *result, NSUInteger idx, BOOL *stop) {
        ZHBEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [ZHBEmotionTool emotionWithDesc:result.string];
        }

        if (emotion) { // 如果有表情
            // 创建附件对象
            ZHBEmotionAttachment *attach = [[ZHBEmotionAttachment alloc] init];

            // 传递表情
            attach.emotion = emotion;
            attach.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);

            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            [attributedString appendAttributedString:substr];
        }
    }];

    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];

    return attributedString;
}


+ (NSArray *)regexResultsWithString:(NSString *)string {
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
//    // 匹配表情
//    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    [string enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//        ZHBRegexResult *regexResult = [[ZHBRegexResult alloc] init];
//        regexResult.string = *capturedStrings;
//        regexResult.range = *capturedRanges;
//        regexResult.emotion = YES;
//        [regexResults addObject:regexResult];
//    }];
//    
//    // 匹配非表情
//    [string enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
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
    return regexResults;
}

@end
