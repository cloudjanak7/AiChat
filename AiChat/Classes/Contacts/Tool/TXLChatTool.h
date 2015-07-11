//
//  TXLChatTool.h
//  AiChat
//
//  Created by 庄彪 on 15/7/6.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPJID;
@class RACSignal;
@class XMPPUserCoreDataStorageObject;

@interface TXLChatTool : NSObject

/**
 *  @brief  有新消息信号
 */
@property (nonatomic, strong, readonly) RACSignal *freshSignal;
/**
 *  @brief  获取到历史信息信号
 */
@property (nonatomic, strong, readonly) RACSignal *historySignal;
/**
 *  @brief  存储XMPPMessageArchiving_Message_CoreDataObject
 */
@property (nonatomic, strong, readonly) NSMutableArray *messages;
/**
 *  @brief  对方user
 */
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *toUser;
///**
// *  @brief  对方JID
// */
//@property (nonatomic, strong) XMPPJID *toJid;

/**
 *  @brief  发送消息
 *
 *  @param message 消息内容
 */
- (void)sendMessage:(NSString *)message;

- (void)loadHistoryMessages;

@end
