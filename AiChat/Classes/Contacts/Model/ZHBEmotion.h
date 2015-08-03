//
//  ZHBEmotion.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHBEmotion : NSObject

/*! 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/*! 表情的文字描述 */
@property (nonatomic, copy) NSString *cht;
/*! 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/*! 表情的文gif图片名 */
@property (nonatomic, copy) NSString *gif;
/*! 表情的type */
@property (nonatomic, copy) NSString *type;
/*! emoji表情的编码 */
@property (nonatomic, copy) NSString *code;
/*! emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;

+ (NSArray *)emotionsWithFile:(NSString *)filePath;

@end
