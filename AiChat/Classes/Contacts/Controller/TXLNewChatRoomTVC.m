//
//  TXLNewChatRoomTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/15.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLNewChatRoomTVC.h"
#import "TXLContactsTool.h"
#import "ZHBXMPPTool.h"
#import "XMPPUserCoreDataStorageObject.h"
#import <ReactiveCocoa.h>

@interface TXLNewChatRoomTVC ()

@property (nonatomic, strong) TXLContactsTool *contactsTool;

@property (nonatomic, strong) NSMutableArray *chatRoomMembers;

@end

@implementation TXLNewChatRoomTVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    [self setupSignal];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsTool.friends.count;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *user = self.contactsTool.friends[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (UITableViewCellAccessoryNone == cell.accessoryType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.chatRoomMembers addObject:user];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.chatRoomMembers removeObject:user];
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [UIImage imageNamed:@"DefaultHead"];
    cell.textLabel.text = ((XMPPUserCoreDataStorageObject *)self.contactsTool.friends[indexPath.row]).jidStr;
    return cell;
}

#pragma mark -
#pragma mark Private Methods
- (void)setupTableView {
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupSignal {
    @weakify(self);
    [self.contactsTool.rac_updateSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)setupNav {
    self.navigationItem.title = @"邀请好友";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = barItem;
    @weakify(self);
    barItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[ZHBXMPPTool sharedXMPPTool] createChatRoom];
        for (XMPPUserCoreDataStorageObject *user in self.chatRoomMembers) {
            [[ZHBXMPPTool sharedXMPPTool].xmppRoom inviteUser:user.jid withMessage:@"来吧、勇士"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
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

- (NSMutableArray *)chatRoomMembers {
    if (nil == _chatRoomMembers) {
        _chatRoomMembers = [[NSMutableArray alloc] init];
    }
    return _chatRoomMembers;
}

@end
