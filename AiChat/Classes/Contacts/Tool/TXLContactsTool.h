//
//  TXLContactsTool.h
//  AiChat
//
//  Created by 庄彪 on 15/7/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface TXLContactsTool : NSObject

/**
 *  @brief  好友列表数组更新信号
 */
@property (nonatomic, strong, readonly) RACSignal *rac_updateSignal;

/**
 *  @brief  存储XMPPUserCoreDataStorageObject
 */
@property (nonatomic, strong, readonly) NSArray *friends;

- (void)loadContactsList;

@end
