//
//  ZHBHelpKeyboard.h
//  AiChat
//
//  Created by 庄彪 on 15/8/4.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXLShareType) {
    TXLShareTypePic,
    TXLShareTypeSight,
    TXLShareTypeVideo,
    TXLShareTypeVoice,
    TXLShareTypeFav,
    TXLShareTypeLocation,
    TXLShareTypeOther
};

typedef void(^ShareOperation)(TXLShareType type);

@interface TXLHelpKeyboard : UIView

/*! @brief  分享操作 */
@property (nonatomic, copy) ShareOperation shareOperation;

+ (instancetype)helpKeyboard;

@end
