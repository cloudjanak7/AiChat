//
//  ZHBNSNotificationConst.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHBNotificationConst : NSObject

/*!  @brief  表情选中的通知 */
extern NSString * const ZHBEmotionDidSelectedNotification;
/*!  @brief  点击删除按钮的通知 */
extern NSString * const ZHBEmotionDidDeletedNotification;
/*!  @brief  通知里面取出表情用的key */
extern NSString * const ZHBEmotionSelectKey;

@end
