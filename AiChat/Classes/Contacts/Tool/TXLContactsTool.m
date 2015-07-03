//
//  TXLContactsTool.m
//  AiChat
//
//  Created by 庄彪 on 15/7/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLContactsTool.h"
#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"

@interface TXLContactsTool ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@property (nonatomic, strong, readwrite) NSArray *friends;

@end

@implementation TXLContactsTool

#pragma mark -
#pragma mark Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self loadContactsList];
    }
    return self;
}

#pragma mark -
#pragma mark Private Methods
- (void)loadContactsList {
    DDLogInfo(@"%@ : %@", THIS_FILE, THIS_METHOD);
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [ZHBXMPPTool sharedXMPPTool].xmppRosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [ZHBUserInfo sharedUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.resultsController.delegate = self;
    
    NSError *err = nil;
    [self.resultsController performFetch:&err];
    if (err) {
        DDLogError(@"%@", err);
    } else {
        self.friends = self.resultsController.fetchedObjects;
    }
}

#pragma mark -
#pragma mark Getters

- (NSArray *)friends {
    if (nil == _friends) {
        _friends = [[NSArray alloc] init];
    }
    return _friends;
}

@end
