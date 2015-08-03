//
//  ZHBEmotionAttachment.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBEmotion;

@interface ZHBEmotionAttachment : NSTextAttachment

@property (nonatomic, strong) ZHBEmotion *emotion;

@end
