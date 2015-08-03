//
//  TXLChatToolView.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendOperation)(NSString *message);

@interface TXLChatToolView : UIView

/*! @brief  发送消息操作 */
@property (nonatomic, copy) SendOperation sendOperation;
/*! @brief  是否更换键盘 */
@property (nonatomic, assign, readonly, getter=isChangingKeyboard) BOOL changingKeyboard;

@end
