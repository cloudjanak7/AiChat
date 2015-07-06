//
//  TXLChatTool.m
//  AiChat
//
//  Created by 庄彪 on 15/7/6.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLChatTool.h"
#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"
#import "ZHBXMPPConst.h"
#import <ReactiveCocoa.h>

@interface TXLChatTool ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) RACSubject *updateSignal;

@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@property (nonatomic, strong, readwrite) NSArray *messages;

@end

@implementation TXLChatTool

#pragma mark -
#pragma mark Life Cycle

#pragma mark -
#pragma mark NSFetchedResultsController Delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self loadMessages];
}


#pragma mark -
#pragma mark Private Methods
- (void)loadMessages {
    DDLogInfo(@"%@::%@", THIS_FILE, THIS_METHOD);
    // 上下文
    NSManagedObjectContext *context = [ZHBXMPPTool sharedXMPPTool].xmppMessageStorage.mainThreadManagedObjectContext;
    // 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:xmppMessageArchivingMessageCoreDataObject];
    
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@", [ZHBUserInfo sharedUserInfo].jid, self.friendJid.bare];
    DDLogInfo(@"消息查询条件:");
    DDLogVerbose(@"%@", pre);
    request.predicate = pre;
    
    // 时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 代理
    self.resultsController.delegate = self;
    
    NSError *err = nil;
    [self.resultsController performFetch:&err];
    if (err) {
        DDLogError(@"查询出错");
        DDLogVerbose(@"%@", err);
    } else {
        DDLogInfo(@"消息查询结果:");
        DDLogVerbose(@"%@",self.resultsController.fetchedObjects);
        self.messages = self.resultsController.fetchedObjects;
        [(RACSubject *)self.updateSignal sendNext:nil];
    }
}

#pragma mark -
#pragma mark Getters


#pragma mark Setters

- (void)setFriendJid:(XMPPJID *)friendJid {
    _friendJid = friendJid;
    [self loadMessages];
}

- (RACSignal *)updateSignal {
    if (nil == _updateSignal) {
        _updateSignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _updateSignal;
}




@end
