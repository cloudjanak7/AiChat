//
//  TXLChatVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/4.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLChatVC.h"

@interface TXLChatVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTV;

@end

@implementation TXLChatVC

#pragma mark - UITableView Delegate


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"123123";
    }
    return cell;
}

@end
