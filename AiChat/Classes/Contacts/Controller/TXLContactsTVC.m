//
//  ZHBContactsTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLContactsTVC.h"
#import "TXLContactsTool.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "TXLChatVC.h"
#import <MJRefresh.h>
#import <ReactiveCocoa.h>
@interface TXLContactsTVC ()

@property (nonatomic, strong) TXLContactsTool *contactsTool;

@end

@implementation TXLContactsTVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupSignal];
    @weakify(self);
    [self.contactsTool.rac_updateSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TXLChatVC class]]) {
        TXLChatVC *chatVc = segue.destinationViewController;
        chatVc.friendUser = (XMPPUserCoreDataStorageObject *)sender;
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsTool.friends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"contactstvc2chatvc" sender:self.contactsTool.friends[indexPath.row]];
}

#pragma mark -
#pragma mark UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    cell.textLabel.text = ((XMPPUserCoreDataStorageObject *)self.contactsTool.friends[indexPath.row]).jidStr;
    return cell;
}

#pragma mark -
#pragma mark Private Methods
- (void)setupTableView {
    self.tableView.rowHeight = 60;
    
    @weakify(self);
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.contactsTool loadContactsList];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshHeader setTitle:@"下拉刷新好友列表" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    
    self.tableView.header = refreshHeader;
}

- (void)setupSignal {
    @weakify(self);
    [self.contactsTool.rac_updateSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark -
#pragma mark Getters

- (TXLContactsTool *)contactsTool {
    if (nil == _contactsTool) {
        _contactsTool = [[TXLContactsTool alloc] init];
    }
    return _contactsTool;
}

@end
