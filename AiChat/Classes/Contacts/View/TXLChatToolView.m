//
//  TXLChatToolView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLChatToolView.h"
#import <Masonry.h>
#import "NSString+Helper.h"
#import "UIImage+Helper.h"
#import "ZHBEmotionKeyboard.h"
#import "UIView+Frame.h"
#import "ZHBNotificationConst.h"
#import "ZHBEmotion.h"
#import "ZHBEmotionTextView.h"

@interface TXLChatToolView ()<UITextViewDelegate>

/*! @brief  切换按钮 */
@property (nonatomic, strong) UIButton *statusBtn;
/*! @brief  录音按钮 */
@property (nonatomic, strong) UIButton *audioBtn;
/*! @brief  更多功能按钮 */
@property (nonatomic, strong) UIButton *moreBtn;
/*! @brief  发送按钮 */
@property (nonatomic, strong) UIButton *sendBtn;
/*! @brief  键盘输入内容框 */
@property (nonatomic, strong) UIView *inputToolView;
/*! @brief  输入 */
@property (nonatomic, strong) ZHBEmotionTextView *inputView;
/*! @brief  表情 */
@property (nonatomic, strong) UIButton *iconBtn;
/*! @brief  横线 */
@property (nonatomic, strong) UIView *lineView;
/*! @brief  背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;
/*! @brief  emotion键盘 */
@property (nonatomic, strong) ZHBEmotionKeyboard *emotionKeyboard;
/*! @brief  功能选择面板 */
@property (nonatomic, strong) TXLHelpKeyboard *helpKeyboard;

@property (nonatomic, assign, readwrite, getter=isChangingKeyboard) BOOL changingKeyboard;

@end

static CGFloat const kButtonW          = 44;
static CGFloat const kButtonH          = 44;
static CGFloat const kToolViewDefaultH = 44;
static CGFloat const kToolViewMaxH     = 100;
static CGFloat const kInputViewMarginY = 5;
static CGFloat const kInputViewMarginX = 5;

@implementation TXLChatToolView

#pragma mark -
#pragma mark Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.statusBtn];
        [self addSubview:self.audioBtn];
        [self addSubview:self.moreBtn];
        [self addSubview:self.inputToolView];
        [self addSubview:self.sendBtn];
        [self layoutViewSubviews];
        
        // 监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedEmotion:) name:ZHBEmotionDidSelectedNotification object:nil];
        // 监听删除按钮点击的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeletedEmotion:) name:ZHBEmotionDidDeletedNotification object:nil];
        // 监听状态栏方向改变通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Public Methods
- (void)endEditing {
    self.inputView.inputView = nil;
    [self.inputView resignFirstResponder];
}

#pragma mark -
#pragma mark Private Methods

- (void)layoutInputToolSubviews {
    __weak typeof(self) weakSelf = self;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputToolView.mas_top).offset(kInputViewMarginY);
        make.left.equalTo(weakSelf.inputToolView.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.inputToolView.mas_bottom).offset(-kInputViewMarginY);
        make.right.equalTo(weakSelf.iconBtn.mas_left).offset(0);
    }];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.inputToolView.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.inputToolView.mas_bottom).offset(0);
        make.width.mas_equalTo(kButtonW);
        make.height.mas_equalTo(kButtonH);
    }];
    
    CGFloat lineH = 1;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.inputToolView);
        make.right.equalTo(weakSelf.inputToolView);
        make.bottom.equalTo(weakSelf.inputToolView).offset(-kInputViewMarginY + lineH);
        make.height.mas_equalTo(lineH);
    }];
}

- (void)layoutViewSubviews {
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    
    __weak typeof(self) weakSelf = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(toolViewW);
        make.height.mas_equalTo(kToolViewDefaultH);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonW);
        make.height.mas_equalTo(kButtonH);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonW + 2 * kInputViewMarginX);
        make.height.mas_equalTo(kButtonH);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonW);
        make.height.mas_equalTo(kButtonH - 2 * kInputViewMarginX);
        make.right.equalTo(weakSelf.mas_right).offset(-kInputViewMarginX);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-kInputViewMarginX);
    }];
    
    [self.inputToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusBtn.mas_right).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.moreBtn.mas_left).offset(0);
    }];
    
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusBtn.mas_right).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.moreBtn.mas_left).offset(0);
    }];
}

- (void)setInputViewStatus {
    BOOL canSend = self.inputView.text.length > 0;
    self.moreBtn.hidden = canSend;
    self.sendBtn.hidden = !canSend;
    self.lineView.backgroundColor = canSend ? AI_CHAT_GREEN_COLOR : [UIColor lightGrayColor];
}

- (void)resetInputView {
    self.inputView.text      = @"";
    self.inputView.inputView = nil;
    self.moreBtn.selected    = NO;
    [self setInputViewStatus];
    [self.inputView resignFirstResponder];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kToolViewDefaultH);
    }];
}

- (void)changeKeyboard:(UIView *)keyboard {
    // 正在切换键盘
    self.changingKeyboard = YES;
    if ([self.inputView.inputView isKindOfClass:[keyboard class]]) {
        self.inputView.inputView = nil;
    } else {
        self.inputView.inputView = keyboard;
    }
    [self.inputView resignFirstResponder];
    // 更换完毕完毕
    self.changingKeyboard = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [weakSelf.inputView becomeFirstResponder];
    });
}

#pragma mark -
#pragma mark UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    [self setInputViewStatus];
    CGFloat lineH = textView.contentSize.height;
    if (lineH < kToolViewDefaultH) {
        lineH = kToolViewDefaultH;
    }
    if (lineH > kToolViewMaxH) {
        lineH = kToolViewMaxH;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineH);
    }];
    [textView scrollRangeToVisible:NSMakeRange(0, textView.text.length)];
}

#pragma mark -
#pragma mark Event Response

//- (void)applicationDidChangeStatusBarOrientation:(NSNotification *)noti {
//    DDLOG_INFO
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    switch (orientation) {
//        case UIInterfaceOrientationLandscapeRight:
//        case UIInterfaceOrientationLandscapeLeft:
//            DDLogVerbose(@"水平%@", @(orientation));
//            self.helpKeyboard.height    = 0;
//            self.emotionKeyboard.height = 0;
//            break;
//        case UIInterfaceOrientationPortrait:
//        case UIInterfaceOrientationPortraitUpsideDown:
//            DDLogVerbose(@"竖直%@", @(orientation));
//            self.helpKeyboard.height    = ZHBSystemKeyboardH_V;
//            self.emotionKeyboard.height = ZHBSystemKeyboardH_V;
//            break;
//        default:
//            DDLogVerbose(@"其他%@", @(orientation));
//            self.helpKeyboard.height    = ZHBSystemKeyboardH_V;
//            self.emotionKeyboard.height = ZHBSystemKeyboardH_V;
//            break;
//    }
//    [self layoutSubviews];
//}

- (void)didSelectedEmotion:(NSNotification *)noti {
    ZHBEmotion *emotion = noti.userInfo[ZHBEmotionSelectKey];
    [self.inputView appendEmotion:emotion];
    [self textViewDidChange:self.inputView];
}

- (void)didDeletedEmotion:(NSNotification *)noti {
    [self.inputView deleteBackward];
}

- (void)didChangeToolViewStatus:(UIButton *)sender {
    DDLOG_INFO
    DDLogVerbose(@"%d", sender.selected);
    if (!sender.selected) {
        [self endEditing];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kToolViewDefaultH);
        }];
        [sender setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    } else {
        [self.inputView becomeFirstResponder];
        [self textViewDidChange:self.inputView];
        [sender setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    }
    sender.selected           = !sender.selected;
    self.inputToolView.hidden = sender.selected;
    self.audioBtn.hidden      = !sender.selected;
}

- (void)didClickTakeAudionButton:(UIButton *)sender {
    DDLOG_INFO
}

- (void)didClickShowMoreButton:(UIButton *)sender {
    DDLOG_INFO
    [self changeKeyboard:self.helpKeyboard];
}

- (void)didClickSendButton:(UIButton *)sender {
    DDLOG_INFO
    if ([self.delegate respondsToSelector:@selector(chatToolView:didClickedSendMessage:)]) {
        [self.delegate chatToolView:self didClickedSendMessage:self.inputView.realText];
    }
    [self resetInputView];
}

- (void)didClickIconButton:(UIButton *)sender {
    DDLOG_INFO
    // 正在切换键盘
    [self changeKeyboard:self.emotionKeyboard];
}

#pragma mark -
#pragma mark Getters

- (UIButton *)statusBtn {
    if (nil == _statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.selected = NO;//YES显示键盘、 NO显示声音
        _statusBtn.adjustsImageWhenHighlighted = NO;
        [_statusBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_statusBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_statusBtn addTarget:self action:@selector(didChangeToolViewStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusBtn;
}

- (UIButton *)audioBtn {
    if (nil == _audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.hidden = YES;
        [_audioBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_audioBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_audioBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_audioBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_audioBtn setBackgroundImage:[UIImage resizedImageNamed:@"VoiceBtn_Black"] forState:UIControlStateNormal];
        [_audioBtn setBackgroundImage:[UIImage resizedImageNamed:@"VoiceBtn_BlackHL"] forState:UIControlStateHighlighted];
        [_audioBtn addTarget:self action:@selector(didClickTakeAudionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}

- (UIButton *)moreBtn {
    if (nil == _moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(didClickShowMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)sendBtn {
    if (nil == _sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.hidden = YES;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:CHAT_SEND_BTN_FONT];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBtn"] forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage resizedImageNamed:@"GreenBtnHighlight"] forState:UIControlStateHighlighted];
        [_sendBtn addTarget:self action:@selector(didClickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)iconBtn {
    if (nil == _iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_iconBtn setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_iconBtn addTarget:self action:@selector(didClickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconBtn;
}

- (UIView *)inputToolView {
    if (nil == _inputToolView) {
        _inputToolView = [[UIView alloc] init];
        [_inputToolView addSubview:self.iconBtn];
        [_inputToolView addSubview:self.inputView];
        [_inputToolView addSubview:self.lineView];
        [self layoutInputToolSubviews];
    }
    return _inputToolView;
}

- (ZHBEmotionTextView *)inputView {
    if (nil == _inputView) {
        _inputView = [[ZHBEmotionTextView alloc] init];
        _inputView.font = CHAT_MESSAGE_FONT;
        _inputView.backgroundColor = [UIColor clearColor];
        _inputView.tintColor = [UIColor grayColor];
        _inputView.delegate = self;
    }
    return _inputView;
}

- (UIView *)lineView {
    if (nil == _lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIImageView *)bgImageView {
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage resizedImageNamed:@"buttontoolbarBkg_white"];
    }
    return _bgImageView;
}

- (ZHBEmotionKeyboard *)emotionKeyboard
{
    if (nil == _emotionKeyboard) {
        _emotionKeyboard = [ZHBEmotionKeyboard emotionKeyboard];
        _emotionKeyboard.height = ZHBSystemKeyboardH_V;
    }
    return _emotionKeyboard;
}

- (TXLHelpKeyboard *)helpKeyboard
{
    if (nil == _helpKeyboard) {
        _helpKeyboard = [TXLHelpKeyboard helpKeyboard];
        _helpKeyboard.height = ZHBSystemKeyboardH_V;
        __weak typeof(self) weakSelf = self;
        _helpKeyboard.shareOperation = ^(TXLShareType type) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(chatToolView:didSelectedShareType:)]) {
                [strongSelf.delegate chatToolView:strongSelf didSelectedShareType:type];
            }
        };
    }
    return _helpKeyboard;
}

@end
