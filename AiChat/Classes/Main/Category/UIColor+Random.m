//
//  UIColor+Random.m
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/5/19.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)colorWithFFRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithFFRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithFFRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red)/255.0 green:(green)/255.0 blue:(blue)/255.0 alpha:alpha];
}

+ (UIColor *)randomColor {
    return [UIColor colorWithFFRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256) alpha:arc4random_uniform(101)/100.0f];
}

@end
