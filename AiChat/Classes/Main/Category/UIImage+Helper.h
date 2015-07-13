//
//  UIImage+Helper.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/4/29.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//
//  UIImage类扩展

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImageNamed:(NSString *)name;
/**
 *  @brief  根据图片名返回一张能够自由拉伸的图片
 *
 *  @param name   图片名称
 *  @param width  宽度截取位置 0-->1 左-->右
 *  @param height 高度截取位置 0-->1 上-->下
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)resizedImageNamed:(NSString *)name width:(CGFloat)width height:(CGFloat)height;

/**
 *  根据颜色返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)originalImageNamed:(NSString *)name;

@end
