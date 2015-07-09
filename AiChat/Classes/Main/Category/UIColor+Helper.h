//
//  UIColor+Random.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/5/19.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)colorWithFFRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithFFRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)randomColor;

@end
