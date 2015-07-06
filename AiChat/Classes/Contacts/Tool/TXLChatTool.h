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

@interface TXLChatTool : NSObject

/**
 *  @brief  好友消息更新信号
 */
@property (nonatomic, strong, readonly) RACSignal *updateSignal;

/**
 *  @brief  存储XMPPMessageArchiving_Message_CoreDataObject
 */
@property (nonatomic, strong, readonly) NSArray *messages;

/**
 *  @brief  好友JID
 */
@property (nonatomic, strong) XMPPJID *friendJid;


//- (void)loadMessageWithJid:(XMPPJID *)friendJid;

@end
