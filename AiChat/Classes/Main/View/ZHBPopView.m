//
//  ZHBPopView.m
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/6/9.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "ZHBPopView.h"
#import "UIView+Frame.h"

static CGFloat const kToolButtoH = 40;

@interface ZHBPopView ()

@property (nonatomic, strong) NSMutableArray *tools;

@end

@implementation ZHBPopView

#pragma mark - 
#pragma mark Lift Cycle

- (void)layoutSubviews {
    NSInteger index = 0;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.width;
    CGFloat btnH = kToolButtoH;
    for (UIButton *btn in self.tools) {
        btn.frame = CGRectMake(btnX, btnY + btnH * index, btnW, btnH);
        index ++;
    }
    self.height = btnH * self.tools.count;
}

#pragma mark -
#pragma mark Public Methods
- (void)addTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self addTitle:title image:nil target:target action:action];
}

- (void)addTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.88]];
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    }
    [self addSubview:button];
    [self.tools addObject:button];
}

#pragma mark - 
#pragma mark Getters and Setters

- (NSMutableArray *)tools {
    if (nil == _tools) {
        _tools = [[NSMutableArray alloc] init];
    }
    return _tools;
}

@end
