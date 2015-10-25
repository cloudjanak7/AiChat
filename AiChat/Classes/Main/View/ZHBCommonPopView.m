//
//  ZHBCommentPopView.m
//  AiChat
//
//  Created by 庄彪 on 15/7/31.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBCommonPopView.h"
#import "ZHBPopView.h"
#import "UIView+Frame.h"
#import "TXLAddFriendVC.h"
#import "TXLNewChatRoomTVC.h"

static CGFloat const kPopViewWidth = 150;
static CGFloat const kPopViewMarginX = 20;

@interface ZHBCommonPopView ()

/*! @brief  弹出菜单 */
@property (nonatomic, strong) ZHBPopView *popView;

/*! @brief  点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/*! @brief  显示在的控制器 */
@property (nonatomic, strong) UIViewController *parentVc;

@end

@implementation ZHBCommonPopView

#pragma mark -
#pragma mark Life Cycle
- (instancetype)initWithParentVC:(UIViewController *)parentVc {
    if ([self isExistedSameView]) return nil;
    if (self = [super init]) {
        self.parentVc = parentVc;
        [self addSubview:self.popView];
        [self addGestureRecognizer:self.tapGesture];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.frame = self.parentVc.view.frame;
        self.popView.frame = CGRectMake(self.width - kPopViewWidth - kPopViewMarginX, 0, kPopViewWidth, 10);
    }
    return self;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)showPopViewInVC:(UIViewController *)viewController {
    return [[self alloc] initWithParentVC:viewController];
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)isExistedSameView {
    BOOL existed = NO;
    for (id vc in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([vc isKindOfClass:[ZHBCommonPopView class]]) {
            [(ZHBCommonPopView *)vc teardownSelf];
            existed = YES;
            break;
        }
    }
    return existed;
}

- (void)teardownSelf {
    self.popView = nil;
    self.tapGesture = nil;
    self.parentVc = nil;
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark Event Response

- (void)didClickAddFriendButton {
    DDLOG_INFO
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TXLAddFriendVC *addFriendVc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TXLAddFriendVC"];
    [self.parentVc.navigationController pushViewController:addFriendVc animated:YES];
    [self teardownSelf];
}

- (void)didClickCreateChatRoomButton {
    DDLOG_INFO
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TXLAddFriendVC *newChatRoomTvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TXLNewChatRoomTVC"];
    [self.parentVc.navigationController pushViewController:newChatRoomTvc animated:YES];
    [self teardownSelf];
}

- (void)tap {
    [self teardownSelf];
}

#pragma mark -
#pragma mark Getters

- (ZHBPopView *)popView {
    if (nil == _popView) {
        _popView = [[ZHBPopView alloc] init];
        [_popView addTitle:@"添加好友" image:@"barbuttonicon_InfoSingle" target:self action:@selector(didClickAddFriendButton)];
        [_popView addTitle:@"创建群组" image:@"barbuttonicon_InfoMulti" target:self action:@selector(didClickCreateChatRoomButton)];
        [_popView addTitle:@"扫一扫" image:@"barbuttonicon_Camera" target:nil action:nil];
        [_popView addTitle:@"收钱" image:@"barbuttonicon_more" target:nil action:nil];
        [_popView addTitle:@"帮助与反馈" image:@"barbuttonicon_question" target:nil action:nil];
    }
    return _popView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (nil == _tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    }
    return _tapGesture;
}
                                              
@end
