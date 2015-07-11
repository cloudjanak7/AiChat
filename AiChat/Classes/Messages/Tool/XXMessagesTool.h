//
//  XXMessagesTool.h
//  AiChat
//
//  Created by 庄彪 on 15/7/10.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface XXMessagesTool : NSObject

/**
 *  @brief  消息列表更新信号
 */
@property (nonatomic, strong, readonly) RACSignal *rac_updateSignal;

/**
 *  @brief  存储最近联系人XXContactMessage
 */
@property (nonatomic, strong, readonly) NSArray *recentContacts;

@end
