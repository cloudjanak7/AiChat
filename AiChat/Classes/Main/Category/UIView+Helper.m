//
//  UIView+Helper.m
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/5/6.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [[self.subviews firstObject] removeFromSuperview];
    }
}

@end
