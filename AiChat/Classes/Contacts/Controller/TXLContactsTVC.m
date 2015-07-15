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
#import "TXLContactDetailVC.h"
#import "TXLAddFriendVC.h"
#import "UIView+Frame.h"
#import "ZHBPopView.h"
#import <MJRefresh.h>
#import <ReactiveCocoa.h>
@interface TXLContactsTVC ()<UISearchBarDelegate>

@property (nonatomic, strong) TXLContactsTool *contactsTool;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarBtnItem;

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, weak) ZHBPopView *popView;

@end

@implementation TXLContactsTVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupSignal];
    [self setupSearchBar];
}

//-(void)viewDidLayoutSubviews
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TXLContactDetailVC class]]) {
        TXLContactDetailVC *contactDetailVc = segue.destinationViewController;
        contactDetailVc.user = (XMPPUserCoreDataStorageObject *)sender;
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsTool.friends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"contactstvc2detail" sender:self.contactsTool.friends[indexPath.row]];
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

#pragma mark -
#pragma mark UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    cell.imageView.image = [UIImage imageNamed:@"DefaultHead"];
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
    self.tableView.header = refreshHeader;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage imageNamed:@"widget_searchbar_cell_bg"];
    searchBar.placeholder = @"搜索";
    searchBar.showsSearchResultsButton = YES;
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"widget_searchbar_textfield"] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateHighlighted];
    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
}

- (void)setupSignal {
    @weakify(self);
    [self.contactsTool.rac_updateSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];
    
    self.rightBarBtnItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self setupPopView];
        return [RACSignal empty];
    }];
}

- (void)setupPopView {
    DDLOG_INFO
    if (self.popView) {
        [self.popView removeFromSuperview];
        return;
    }
    ZHBPopView *popView = [[ZHBPopView alloc] init];
    popView.frame = CGRectMake(self.view.width - 170, 0, 150, 10);
    [popView addTitle:@"添加好友" image:@"barbuttonicon_InfoSingle" target:self action:@selector(didClickAddFriendButton)];
    [popView addTitle:@"创建群组" image:@"barbuttonicon_InfoMulti" target:self action:@selector(didClickCreateChatRoomButton)];
    [self.view addSubview:popView];
    self.popView = popView;
}

#pragma mark -
#pragma mark Event Response

- (void)didClickAddFriendButton {
    DDLOG_INFO
    [self.popView removeFromSuperview];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TXLAddFriendVC *addFriendVc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TXLAddFriendVC"];
    [self.navigationController pushViewController:addFriendVc animated:YES];
}

- (void)didClickCreateChatRoomButton {
    DDLOG_INFO
    [self.popView removeFromSuperview];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TXLAddFriendVC *newChatRoomTvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TXLNewChatRoomTVC"];
    [self.navigationController pushViewController:newChatRoomTvc animated:YES];
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
