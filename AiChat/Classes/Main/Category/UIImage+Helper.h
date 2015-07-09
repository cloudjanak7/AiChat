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
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  根据颜色返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)originalImageNamed:(NSString *)name;

@end
