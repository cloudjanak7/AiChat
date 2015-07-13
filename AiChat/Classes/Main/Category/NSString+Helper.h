//
//  NSString+Helper.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/4/29.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Helper)

/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

/**
 *  是否空字符串
 *
 *  @return 如果字符串为nil或者长度为0返回YES
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 *  返回沙盒中的文件路径
 *
 *  @return 返回当前字符串对应在沙盒中的完整文件路径
 */
- (NSString *)documentsPath;

/**
 *  计算字符串区域大小
 *
 *  @param maxSize 最大范围
 *  @param font    字体
 *
 *  @return CGRect
 */
- (CGRect)textSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;

/**
 *  写入系统偏好
 *
 *  @param key 写入键值
 */
- (void)saveToNSDefaultsWithKey:(NSString *)key;

/**
 *  获取文件大小
 *
 *  @return long long
 */
- (long long)fileSize;

/**
 *  计算字符串区域大小
 *
 *  @param size 最大范围
 *  @param font 字体
 *
 *  @return CGSize
 */
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

@end
