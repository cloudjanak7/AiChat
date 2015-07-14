//
//  ZHBPopView.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/6/9.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBPopView : UIView

- (void)addTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)addTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action;

@end
