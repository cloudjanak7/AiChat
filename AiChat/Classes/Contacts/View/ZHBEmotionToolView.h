//
//  ZHBEmotionToolView.h
//  AiChat
//
//  Created by 庄彪 on 15/8/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZHBEmotionType) {
    ZHBEmotionTypeRecent = 0,
    ZHBEmotionTypeDefault,
    ZHBEmotionTypeEmoji,
    ZHBEmotionTypeLxh
};

@protocol ZHBEmotionToolViewDelegate <NSObject>

@optional
- (void)didSelectedEmotionToolViewButton:(ZHBEmotionType)emotionType;

@end

@interface ZHBEmotionToolView : UIView

/*! @brief  代理 */
@property (nonatomic, weak) id<ZHBEmotionToolViewDelegate> delegate;

@end
