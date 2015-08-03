//
//  TXLChatVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/4.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLChatVC.h"
#import "TXLChatTool.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "TXLChatCell.h"
#import "TXLChatToolView.h"
#import <MJRefresh.h>
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIImage+Helper.h"

@interface TXLChatVC ()<UITableViewDelegate, UITableViewDataSource>

/*! @brief  聊天内容列表 */
@property (nonatomic, weak) UITableView *contentTV;
/*! @brief  底部工具条 */
@property (nonatomic, weak) TXLChatToolView *bottomToolView;
/*! @brief  背景图片 */
@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, strong) TXLChatTool *chatTool;

@property (nonatomic, strong) NSMutableDictionary *heightDict;

@end

@implementation TXLChatVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupSignal];
    self.navigationItem.title = self.friendUser.displayName;
    self.chatTool.toUser = self.friendUser;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Event Response
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbEndFrm  = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrm.size.height;
    [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kbHeight);
    }];
    [self scrollToLastMessage];

}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (self.bottomToolView.isChangingKeyboard) return;
    [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [self scrollToLastMessage];
}

#pragma mark -
#pragma mark Private Methods

- (void)scrollToLastOldMessage:(NSNumber *)lastIndex {
    NSInteger index = [lastIndex integerValue];
    if (index >= self.chatTool.messages.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.contentTV scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)scrollToLastMessage {
    NSInteger messagesCount = [self.contentTV numberOfRowsInSection:0];
    if (0 == messagesCount) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:messagesCount - 1 inSection:0];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.contentTV scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)setupView {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plugin_contentlist_backgroud"]];
    [self.view addSubview:bgView];
    self.bgImageView = bgView;
    [self setupTableView];
    [self setupBottomToolView];
    [self layoutViewSubviews];
}

- (void)setupTableView {
    UITableView *contentTV = [[UITableView alloc] init];
    contentTV.delegate = self;
    contentTV.dataSource = self;
    [self.view addSubview:contentTV];
    self.contentTV = contentTV;

    @weakify(self);
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.chatTool loadHistoryMessages];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshHeader setTitle:@"加载历史消息" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"加载历史消息" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.contentTV.header = refreshHeader;
    self.contentTV.backgroundColor = [UIColor clearColor];
    self.contentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTV registerNib:[UINib nibWithNibName:NSStringFromClass([TXLChatCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TXLChatCell class])];
}

- (void)setupBottomToolView {
    TXLChatToolView *toolView = [[TXLChatToolView alloc] init];
    __weak typeof(self) weakSelf = self;
    toolView.sendOperation = ^(NSString *message) {
        [weakSelf.chatTool sendMessage:message];
    };
    [self.view addSubview:toolView];
    self.bottomToolView = toolView;
}

- (void)layoutViewSubviews {
    __weak typeof(self) weakSelf = self;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.bottomToolView.mas_top).offset(0);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
    }];
}

- (void)setupSignal {
    @weakify(self);
//    [[[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
//        @strongify(self);
//        return @(self.contentTxtf.text.length > 0);
//    }] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.chatTool sendMessage:self.contentTxtf.text];
//        self.contentTxtf.text = @"";
//        [self.view endEditing:YES];
//    }];
    
    [self.chatTool.rac_freshSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.contentTV reloadData];
            [self scrollToLastMessage];
        });
    }];
    
    [self.chatTool.rac_historySignal subscribeNext:^(NSNumber *lastIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.contentTV.header endRefreshing];
            [self.contentTV reloadData];
            [self scrollToLastOldMessage:(NSNumber *)lastIndex];
        });
    }];
}

#pragma mark - 
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *message = self.chatTool.messages[indexPath.row];
    if (self.heightDict[@([message.timestamp timeIntervalSinceReferenceDate])]) {
        return [self.heightDict[@([message.timestamp timeIntervalSinceReferenceDate])] floatValue];
    } else {
        TXLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TXLChatCell class])];
        cell.message = message;
        self.heightDict[@([message.timestamp timeIntervalSinceReferenceDate])] = @(cell.height);
        return cell.height;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatTool.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TXLChatCell class])];
    if ([self.chatTool.messages[indexPath.row] isKindOfClass:[XMPPMessageArchiving_Message_CoreDataObject class]]) {
        cell.message = self.chatTool.messages[indexPath.row];
    }
    return cell;
}

#pragma mark -
#pragma mark Getters

- (TXLChatTool *)chatTool {
    if (nil == _chatTool) {
        _chatTool = [[TXLChatTool alloc] init];
    }
    return _chatTool;
}

- (NSMutableDictionary *)heightDict {
    if (nil == _heightDict) {
        _heightDict = [[NSMutableDictionary alloc] init];
    }
    return _heightDict;
}

@end
