//
//  XXMessagesTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "XXMessagesTVC.h"
#import "UIView+Frame.h"

@interface XXMessagesTVC ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation XXMessagesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
}


#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"1212";
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


@end
