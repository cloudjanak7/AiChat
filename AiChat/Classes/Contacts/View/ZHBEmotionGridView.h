//
//  ZHBEmotionGridView.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSUInteger const kEmotionMaxRows = 3;
static NSUInteger const kEmotionMaxCols = 7;
static NSUInteger const kEmotionMaxCountPerPage = kEmotionMaxRows * kEmotionMaxCols - 1;

@interface ZHBEmotionGridView : UIView

/*! 需要展示的所有表情 */
@property (nonatomic, strong) NSArray *emotions;

@end
