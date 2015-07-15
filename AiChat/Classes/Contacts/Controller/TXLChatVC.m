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
#import <MJRefresh.h>
#import <ReactiveCocoa.h>

@interface TXLChatVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTV;

@property (weak, nonatomic) IBOutlet UITextField *contentTxtf;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong) TXLChatTool *chatTool;

@property (nonatomic, strong) NSMutableDictionary *heightDict;

@end

@implementation TXLChatVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupSignal];
    self.navigationItem.title = self.friendUser.displayName;
    self.chatTool.toUser = self.friendUser;
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
    [self.contentTV scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (BOOL)isValidMessage {
    return (nil != self.contentTxtf.text && self.contentTxtf.text.length > 0);
}

- (void)setupTableView {
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
    self.contentTV.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plugin_contentlist_backgroud"]];
    self.contentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTV registerNib:[UINib nibWithNibName:NSStringFromClass([TXLChatCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TXLChatCell class])];
}

- (void)setupSignal {
    @weakify(self);
    [[[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
        @strongify(self);
        return @(self.contentTxtf.text.length > 0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.chatTool sendMessage:self.contentTxtf.text];
        self.contentTxtf.text = @"";
        [self.view endEditing:YES];
    }];
    
    [self.chatTool.freshSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.contentTV reloadData];
            [self scrollToLastMessage];
        });
    }];
    
    [self.chatTool.historySignal subscribeNext:^(NSNumber *lastIndex) {
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
