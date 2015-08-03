//
//  ZHBEmotionView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionView.h"
#import "ZHBEmotion.h"
#import "UIImage+Helper.h"

@implementation ZHBEmotionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage resizedImageNamed:@"group_buton_pressed"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setEmotion:(ZHBEmotion *)emotion {
    _emotion = emotion;
    
    if (emotion.code) { // emoji表情
        // 取消动画效果
        [UIView setAnimationsEnabled:NO];
        // 设置emoji表情
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        // 再次开启动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
    } else { //图片表情
        UIImage *image = [UIImage imageWithName:emotion.png];
        if (iOS7) { // 不需要进行蓝色的渲染
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
}


@end
