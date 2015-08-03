//
//  ZHBEmotionTextView.h
//  AiChat
//
//  Created by 庄彪 on 15/8/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBEmotion;

@interface ZHBEmotionTextView : UITextView

/*! @brief  上传服务端的内容 */
@property (nonatomic, copy, readonly) NSString *realText;

/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(ZHBEmotion *)emotion;

@end
