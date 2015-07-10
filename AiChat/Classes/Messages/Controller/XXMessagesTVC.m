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
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "NSDate+Helper.h"
#import <ReactiveCocoa.h>

@interface XXMessagesTVC ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) XXMessagesTool *messagesTool;

@end

@implementation XXMessagesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 70;
    [self setupSearchBar];
    [self setupSignal];
}


#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesTool.recentContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    XMPPMessageArchiving_Contact_CoreDataObject *contact = (XMPPMessageArchiving_Contact_CoreDataObject *)self.messagesTool.recentContacts[indexPath.row];
    cell.textLabel.text = [contact.mostRecentMessageTimestamp dateString];
    cell.detailTextLabel.text = contact.mostRecentMessageBody;
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
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
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
