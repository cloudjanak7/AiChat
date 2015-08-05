//
//  TXLChatToolView.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLHelpKeyboard.h"
@class TXLChatToolView;

@protocol TXLChatToolViewDelegate <NSObject>

@optional
- (void)chatToolView:(TXLChatToolView *)chatToolView didSelectedShareType:(TXLShareType)type;

- (void)chatToolView:(TXLChatToolView *)chatToolView didClickedSendMessage:(NSString *)message;

@end

@interface TXLChatToolView : UIView

/*! @brief  是否更换键盘 */
@property (nonatomic, assign, readonly, getter=isChangingKeyboard) BOOL changingKeyboard;
/*! @brief  代理 */
@property (nonatomic, weak) id<TXLChatToolViewDelegate> delegate;

/*!
 *  @brief  取消第一响应者
 */
- (void)endEditing;

@end
