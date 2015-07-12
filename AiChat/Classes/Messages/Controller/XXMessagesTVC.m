//
//  XXMessagesTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "XXMessagesTVC.h"
#import "UIView+Frame.h"
#import "XXMessagesTool.h"
#import "NSDate+Helper.h"
#import "XXMessageCell.h"
#import "XXContactMessage.h"
#import "TXLChatVC.h"
#import <ReactiveCocoa.h>

@interface XXMessagesTVC ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) XXMessagesTool *messagesTool;

@end

@implementation XXMessagesTVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupSearchBar];
    [self setupSignal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TXLChatVC class]]) {
        TXLChatVC *chatVc = segue.destinationViewController;
        chatVc.friendUser = sender;
    }
}

#pragma mark -
#pragma mark UITableView Delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XXContactMessage *message = self.messagesTool.recentContacts[indexPath.row];
    [self performSegueWithIdentifier:@"messagestvc2chatvc" sender:message.friendUser];
}

#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesTool.recentContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XXMessageCell class])];
    cell.contactMessage = self.messagesTool.recentContacts[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark Private Methods 
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
    [self.messagesTool.rac_updateSignal subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self reloadRecentMessages];
        });
    }];
}

- (void)setupTableView {
    self.tableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XXMessageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XXMessageCell class])];
}

- (void)reloadRecentMessages {
    [self.tableView reloadData];
    if ([self.messagesTool.allUnreadNum integerValue] > 0) {
        self.navigationController.tabBarItem.badgeValue = [self.messagesTool.allUnreadNum stringValue];
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

#pragma mark -
#pragma mark Getters

- (XXMessagesTool *)messagesTool {
    if (nil == _messagesTool) {
        _messagesTool = [[XXMessagesTool alloc] init];
    }
    return _messagesTool;
}

@end
