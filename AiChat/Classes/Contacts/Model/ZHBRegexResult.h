//
//  ZHBRegexResult.h
//  AiChat
//
//  Created by 庄彪 on 15/8/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHBRegexResult : NSObject

/*! @brief  匹配到的字符串 */
@property (nonatomic, copy) NSString *string;
/*! @brief  匹配到的范围 */
@property (nonatomic, assign) NSRange range;
/*! @brief  是否为表情 */
@property (nonatomic, assign, getter=isEmotion) BOOL emotion;

@end
