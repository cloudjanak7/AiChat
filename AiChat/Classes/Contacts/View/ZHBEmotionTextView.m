//
//  ZHBEmotionTextView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionTextView.h"
#import "ZHBEmotion.h"
#import "ZHBEmotionTool.h"

@implementation ZHBEmotionTextView

#pragma mark -
#pragma mark Public Methods
- (void)appendEmotion:(ZHBEmotion *)emotion {
    if (emotion.emoji) { // emoji表情
        [self insertText:emotion.emoji];
    } else { // 图片表情
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        // 创建一个带有图片表情的富文本
        NSAttributedString *attachString = [ZHBEmotionTool emotionAttributedString:emotion font:self.font];
        
        // 记录表情的插入位置
        NSInteger insertIndex = self.selectedRange.location;
        
        // 插入表情图片到光标位置
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        // 设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        // 重新赋值(光标会自动回到文字的最后面)
        self.attributedText = attributedText;
        
        // 让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
    }
}

#pragma mark -
#pragma mark Getters

- (NSString *)realText {
    return [ZHBEmotionTool stringWithEmotionAttributedString:self.attributedText];
}

@end
