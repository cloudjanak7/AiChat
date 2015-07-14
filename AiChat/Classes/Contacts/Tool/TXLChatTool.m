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
#import "XXMessagesTool.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import <ReactiveCocoa.h>

#define MAX_HISTORY_MESSAGES_COUNT 10

@interface TXLChatTool ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) RACSubject *freshSignal;

@property (nonatomic, strong, readwrite) RACSubject *historySignal;

/**
 *  @brief  最新消息请求
 */
@property (nonatomic, strong) NSFetchedResultsController *freshResultsController;
/**
 *  @brief  请求上下文
 */
@property (nonatomic, strong) NSManagedObjectContext *messageContext;
/**
 *  @brief  存数所有获取的消息
 */
@property (nonatomic, strong, readwrite) NSMutableArray *messages;
/**
 *  @brief  存储历史消息
 */
@property (nonatomic, strong) NSMutableArray *historyMessages;
/**
 *  @brief  最旧一条消息的时间
 */
@property (nonatomic, strong) NSDate *farthestDate;
/**
 *  @brief  最新一条消息的时间
 */
@property (nonatomic, strong) NSDate *latestDate;

@property (nonatomic, assign, getter=canResetUnreadMessages) BOOL reset;

@end
#warning 未考虑离线消息的读取时间、待实现。
@implementation TXLChatTool

#pragma mark -
#pragma mark Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.reset = YES;
    }
    return self;
}

- (void)dealloc {
    [ZHBXMPPTool sharedXMPPTool].chatJid = nil;
}

#pragma mark -
#pragma mark NSFetchedResultsController Delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (0 == controller.fetchedObjects.count) return;
    if (!((XMPPMessageArchiving_Message_CoreDataObject *)[self.freshResultsController.fetchedObjects lastObject]).body) return;
    [self updateFetchedResults];
}

#pragma mark -
#pragma mark Public Methods
- (void)sendMessage:(NSString *)message {
    [[ZHBXMPPTool sharedXMPPTool] sendMessage:message toJID:self.toUser.jid];
}

#pragma mark 获取历史消息
- (void)loadHistoryMessages {
    DDLOG_INFO
    
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@ AND timestamp < %@", [ZHBUserInfo sharedUserInfo].jid, self.toUser.jid.bare, self.farthestDate];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:xmppMessageArchivingMessageCoreDataObject];
    request.sortDescriptors = @[timeSort];
    request.predicate = predicate;
    request.fetchLimit = MAX_HISTORY_MESSAGES_COUNT;
    DDLogInfo(@"查询条件:");
    DDLogVerbose(@"%@", request);
    
    NSFetchedResultsController *historyResultesController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.messageContext sectionNameKeyPath:nil cacheName:nil];

    NSError *error = nil;
    if (![historyResultesController performFetch:&error]) {
        DDLogError(@"获取消息失败:\n%@", error);
    } else {
        NSInteger messageCount = historyResultesController.fetchedObjects.count;
        if (0 == messageCount) {
            [(RACSubject *)self.historySignal sendNext:@(0)];
            return;
        };
        
        NSMutableArray *fetchedResults = [NSMutableArray array];
        for (NSInteger index = messageCount - 1; index >= 0; index --) {
            [fetchedResults addObject:historyResultesController.fetchedObjects[index]];
        }
        [self.historyMessages insertObjects:fetchedResults atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetchedResults.count)]];
        [self.messages insertObjects:fetchedResults atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fetchedResults.count)]];
        XMPPMessageArchiving_Message_CoreDataObject *message = [fetchedResults firstObject];
        self.farthestDate = message.timestamp;
        if (self.canResetUnreadMessages) {
            [[ZHBXMPPTool sharedXMPPTool] resetUnreadMessage:self.toUser.jid.bare];
            [[XXMessagesTool sharedMessagesTool] updateFetchedResults];
            self.reset = NO;
        }
        [(RACSubject *)self.historySignal sendNext:@(fetchedResults.count - 1)];
    }
}

#pragma mark -
#pragma mark Private Methods

#pragma mark 获取最新消息
- (void)loadFreshMessages {
    DDLOG_INFO
    NSError *error = nil;
    if (![self.freshResultsController performFetch:&error]) {
        DDLogError(@"获取消息失败:\n%@", error);
    } else if (self.freshResultsController.fetchedObjects.count > 0) {
        [self updateFetchedResults];
    }
}

- (void)updateFetchedResults {
    [self.messages removeAllObjects];
    [self.messages addObjectsFromArray:self.historyMessages];
    [self.messages addObjectsFromArray:self.freshResultsController.fetchedObjects];
    self.latestDate = ((XMPPMessageArchiving_Message_CoreDataObject *)[self.freshResultsController.fetchedObjects lastObject]).timestamp;
    [[ZHBXMPPTool sharedXMPPTool] resetUnreadMessage:self.toUser.jid.bare];
    [[XXMessagesTool sharedMessagesTool] updateFetchedResults];
    [(RACSubject *)self.freshSignal sendNext:nil];
}

#pragma mark -
#pragma mark Getters

- (NSMutableArray *)messages {
    if (nil == _messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (NSMutableArray *)historyMessages {
    if (nil == _historyMessages) {
        _historyMessages = [[NSMutableArray alloc] init];
    }
    return _historyMessages;
}

- (NSDate *)latestDate {
    if (nil == _latestDate) {
        _latestDate = [NSDate date];
    }
    return _latestDate;
}

- (NSDate *)farthestDate {
    if (nil == _farthestDate) {
        _farthestDate = [NSDate date];
    }
    return _farthestDate;
}

- (RACSignal *)freshSignal {
    if (nil == _freshSignal) {
        _freshSignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _freshSignal;
}

- (RACSignal *)historySignal {
    if (nil == _historySignal) {
        _historySignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _historySignal;
}

- (NSManagedObjectContext *)messageContext {
    if (nil == _messageContext) {
        _messageContext = [ZHBXMPPTool sharedXMPPTool].xmppMessageStorage.mainThreadManagedObjectContext;
    }
    return _messageContext;
}

- (NSFetchedResultsController *)freshResultsController {
    if (nil == _freshResultsController) {
        //设置查询条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@ AND timestamp > %@", [ZHBUserInfo sharedUserInfo].jid, self.toUser.jid.bare, self.latestDate];
        
        NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:xmppMessageArchivingMessageCoreDataObject];
        request.sortDescriptors = @[timeSort];
        request.predicate = predicate;
        DDLogInfo(@"查询条件:");
        DDLogVerbose(@"%@", request);
        
        _freshResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.messageContext sectionNameKeyPath:nil cacheName:nil];
        _freshResultsController.delegate = self;
    }
    return _freshResultsController;
}

#pragma mark Setters
- (void)setToUser:(XMPPUserCoreDataStorageObject *)toUser {
    _toUser = toUser;
    [ZHBXMPPTool sharedXMPPTool].chatJid = _toUser.jid.bare;
    [self loadHistoryMessages];
    [self loadFreshMessages];
}

@end
