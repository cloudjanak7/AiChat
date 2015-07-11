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
#import <MJRefresh.h>
#import <ReactiveCocoa.h>

#define MESSAGE_OF_INDEX(index) ((XMPPMessageArchiving_Message_CoreDataObject *)self.chatTool.messages[index])

@interface TXLChatVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTV;

@property (weak, nonatomic) IBOutlet UITextField *contentTxtf;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong) TXLChatTool *chatTool;

@end

@implementation TXLChatVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    [[[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
        @strongify(self);
        return @(self.contentTxtf.text.length > 0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.chatTool sendMessage:self.contentTxtf.text];
        self.contentTxtf.text = @"";
        [self.view endEditing:YES];
    }];
    
    self.chatTool.friendJid = self.friendUser.jid;
    
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
#pragma mark Private Methods

- (void)scrollToLastOldMessage:(NSNumber *)lastIndex {
    NSInteger index = [lastIndex integerValue];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.contentTV scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollToLastMessage {
    NSInteger messagesCount = self.chatTool.messages.count;
    if (0 == messagesCount || 1 == messagesCount) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:messagesCount - 1 inSection:0];
    [self.contentTV scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (BOOL)isValidMessage {
    return (nil != self.contentTxtf.text && self.contentTxtf.text.length > 0);
}

#pragma mark - 
#pragma mark UITableView Delegate


#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatTool.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = MESSAGE_OF_INDEX(indexPath.row).body;
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

//- (void)setFriendUser:(XMPPUserCoreDataStorageObject *)friendUser {
//    _friendUser = friendUser;
//    self.chatTool.friendJid = _friendUser.jid;
//}

@end
