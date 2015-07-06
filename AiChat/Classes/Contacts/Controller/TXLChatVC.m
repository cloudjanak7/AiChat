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
#import <ReactiveCocoa.h>

#define MESSAGE_OF_INDEX(index) ((XMPPMessageArchiving_Message_CoreDataObject *)self.chatTool.messages[index])

@interface TXLChatVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTV;

@property (nonatomic, strong) TXLChatTool *chatTool;

@end

@implementation TXLChatVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [self.chatTool.updateSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentTV reloadData];
        });
    }];
    
    self.chatTool.friendJid = self.friendUser.jid;
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
