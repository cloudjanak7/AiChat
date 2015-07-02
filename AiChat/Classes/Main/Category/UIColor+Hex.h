//
//  UIColor+Hex.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/5/20.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 *  根据十六进制转换为颜色
 *
 *  @param hex UInt32
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex;

/**
 *  获取对应的颜色
 *
 *  @param hex   UInt32
 *  @param alpha CGFloat（0---1）
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/**
 *  根据十六进制字符串转换为颜色
 *
 *  @param hexString NSString
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)HEXString;

@end
