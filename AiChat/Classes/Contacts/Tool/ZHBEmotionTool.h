//
//  ZHBEmotionTool.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHBEmotion;

@interface ZHBEmotionTool : NSObject

/*!
 *  @brief  默认表情
 *
 *  @return 数组保存ZHBEmotion
 */
+ (NSArray *)defaultEmotions;

/*!
 *  @brief  Emoji表情
 *
 *  @return 数组保存ZHBEmotion
 */
+ (NSArray *)emojiEmotions;

/*!
 *  @brief  浪小花表情
 *
 *  @return 数组保存ZHBEmotion
 */
+ (NSArray *)lxhEmotions;

/*!
 *  @brief  最近表情
 *
 *  @return 数组保存ZHBEmotion
 */
+ (NSArray *)recentEmotions;

/*!
 *  @brief  根据表情的文字描述找出对应的表情对象
 *
 *  @param desc 文字描述
 *
 *  @return ZHBEmotion
 */
+ (ZHBEmotion *)emotionWithDesc:(NSString *)desc;

/*!
 *  @brief  添加最近使用表情
 *
 *  @param emotion ZHBEmotion
 */
+ (void)addRecentEmotion:(ZHBEmotion *)emotion;

/*!
 *  @brief  转换ZHBEmotion为富文本
 *
 *  @param emotion ZHBEmotion
 *  @param font    字体大小
 *
 *  @return NSAttributedString 富文本
 */
+ (NSAttributedString *)emotionAttributedString:(ZHBEmotion *)emotion font:(UIFont *)font;

/*!
 *  @brief  Emotion富文本转换为字符串
 *
 *  @param attributedString 要转换的emotion富文本
 *
 *  @return NSString 字符内容
 */
+ (NSString *)stringWithEmotionAttributedString:(NSAttributedString *)attributedString;

/*!
 *  @brief  根据字符串转换为Emotion富文本
 *
 *  @param string 要转换的内容
 *  @param font   字体大小
 *
 *  @return Emotion富文本
 */
+ (NSAttributedString *)emotionsAttributedStringWithString:(NSString *)string font:(UIFont *)font;

@end
