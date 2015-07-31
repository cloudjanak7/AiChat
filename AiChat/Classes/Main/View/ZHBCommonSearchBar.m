//
//  ZHBCommonSearchBar.m
//  AiChat
//
//  Created by 庄彪 on 15/7/31.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBCommonSearchBar.h"

@implementation ZHBCommonSearchBar

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundImage = [UIImage imageNamed:@"widget_searchbar_cell_bg"];
        self.placeholder = @"搜索";
        self.showsSearchResultsButton = YES;
        [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"widget_searchbar_textfield"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateHighlighted];
    }
    return self;
}

@end
