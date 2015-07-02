//
//  MBProgressHUD+ZHB.h
//  OverBar
//
//  Created by 庄彪 on 15/3/28.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZHB)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
