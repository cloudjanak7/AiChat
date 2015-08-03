//
//  ZHBEmotionAttachment.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionAttachment.h"
#import "ZHBEmotion.h"
#import "UIImage+Helper.h"

@implementation ZHBEmotionAttachment

- (void)setEmotion:(ZHBEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@", emotion.png]];
}

@end
