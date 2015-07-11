//
//  ZHBXMPPTool.m
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"
#import "ZHBXMPPConst.h"
#import "UIDevice+Hardware.h"

@interface ZHBXMPPTool ()<XMPPStreamDelegate, XMPPRosterDelegate>

@property (nonatomic, strong, readwrite) XMPPStream *xmppStream;

@property (nonatomic, strong, readwrite) XMPPvCardTempModule *xmppvCardModule;

@property (nonatomic, strong, readwrite) XMPPRoster *xmppRoster;

@property (nonatomic, strong, readwrite) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong, readwrite) XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;

@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
/**
 *  @brief  自动重连模块
 */
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
/**
 *  @brief  聊天消息模块
 */
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessage;

@property (nonatomic, copy) XMPPResultCallBack callBack;

@property (nonatomic, assign, getter=isRegisterOperation) BOOL registerOperation;

@end

@implementation ZHBXMPPTool

#pragma mark -
#pragma mark Life Cycle

ZHBSingletonM(XMPPTool)

- (void)dealloc {
    [self teardownXMPP];
}

#pragma mark -
#pragma mark Public Methods

- (void)userLogin:(XMPPResultCallBack)callBack {
    self.registerOperation = NO;
    self.callBack = callBack;
    [self.xmppStream disconnect];
    [self connectToHost];
}

- (void)userRegister:(XMPPResultCallBack)callBack {
    self.registerOperation = YES;
    self.callBack = callBack;
    [self.xmppStream disconnect];
    [self connectToHost];
}

- (void)userLogout {
    
}

- (void)disConnectFromHost {
    [self sendOfflineToHost];
    [self.xmppStream disconnect];
}

- (void)sendMessage:(NSString *)message toJID:(XMPPJID *)jid {
    DDLOG_INFO
    XMPPMessage *xmppMessage = [XMPPMessage messageWithType:@"chat" to:jid];
    [xmppMessage addBody:message];
    DDLogInfo(@"发送消息-->%@", jid);
    [self.xmppStream sendElement:xmppMessage];
}

- (BOOL)resetUnreadMessage:(NSString *)fromJidStr {
    return [self updateUnreadMessage:fromJidStr reset:YES];
}

#pragma mark -
#pragma mark XMPPStream Delegate

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    DDLOG_INFO
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DDLOG_INFO
    if (self.isRegisterOperation) {
        [self.xmppStream registerWithPassword:[ZHBUserInfo sharedUserInfo].password error:nil];
    } else {
        [self sendPwdToHost];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DDLOG_INFO
    DDLogError(@"error:\n%@", error);
    if (error && self.callBack) {
        self.callBack(XMPPStatusTypeNetErr);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    DDLOG_INFO
    [self sendOnlineToHost];
    [ZHBUserInfo sharedUserInfo].autoLogin = YES;
    [[ZHBUserInfo sharedUserInfo] saveInfoToSanbox];
    if (self.callBack) {
        self.callBack(XMPPStatusTypeLoginSuccess);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    DDLOG_INFO
    DDLogError(@"error:\n%@", error);
    if (self.callBack) {
        self.callBack(XMPPStatusTypeLoginFailure);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    DDLOG_INFO
    DDLogError(@"error\n:%@", error);
    if (self.callBack) {
        self.callBack(XMPPStatusTypeRegisterFailure);
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    DDLOG_INFO
    if (self.callBack) {
        self.callBack(XMPPStatusTypeRegisterSuccess);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//#warning 这样做在网络状况不好时，好友没有刷新到最新的消息，但是这边未读消息数没有添加，未读消息数就会不准确，如果不判断，重复读取会不会性能低下？
//    if (!message.body || [self.chatJid isEqualToString:message.from.bare]) return;
    if (!message.body) return;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf addUnreadMessage:message.from.bare];
    });
}

#pragma mark -
#pragma mark XMPPRoster Delegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    DDLOG_INFO
}

#pragma mark -
#pragma mark Private Methods

- (void)connectToHost {
    XMPPJID *myJID = [XMPPJID jidWithUser:[ZHBUserInfo sharedUserInfo].name domain:xmppDoMain resource:[UIDevice hardWareName]];
    self.xmppStream.myJID = myJID;
    self.xmppStream.hostName = xmppHostName;
    self.xmppStream.hostPort = xmppHostPort;

    [self.xmppStream connectWithTimeout:xmppTimeout error:nil];
}

- (void)sendPwdToHost {
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:[ZHBUserInfo sharedUserInfo].password error:&error];
}

- (void)sendOnlineToHost {
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

- (void)sendOfflineToHost {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)setupXMPP {
    [self.xmppReconnect activate:self.xmppStream];
    [self.xmppvCardModule activate:self.xmppStream];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppMessage activate:self.xmppStream];
}

- (void)teardownXMPP {
    [self.xmppStream removeDelegate:self];
    
    [self.xmppReconnect deactivate];
    [self.xmppvCardModule deactivate];
    [self.xmppRoster deactivate];
    [self.xmppMessage deactivate];
    
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppvCardModule = nil;
    self.xmppvCardStorage = nil;
    self.xmppRoster = nil;
    self.xmppRosterStorage = nil;
    self.xmppMessage = nil;
    self.xmppMessageStorage = nil;
//    _xmppvCardAvatarModule = nil;
//    _xmppCapabilities = nil;
//    _xmppCapabilitiesStorage = nil;
}

- (void)addUnreadMessage:(NSString *)fromJidStr {
    [self updateUnreadMessage:fromJidStr reset:NO];
}

/**
 *  @brief  更新联系人未读消息数
 *
 *  @param fromJidStr 消息发送方jid
 *  @param reset      YES（重置未读消息数） NO（增加未读消息数）
 *
 *  @return YES更新成功 NO更新失败
 */
- (BOOL)updateUnreadMessage:(NSString *)fromJidStr reset:(BOOL)reset {
    NSManagedObjectContext *context = self.xmppRosterStorage.mainThreadManagedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:xmppUserCoreDataStorageObject];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND jidStr = %@", [ZHBUserInfo sharedUserInfo].jid, fromJidStr];
    request.predicate = pre;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    if (![resultsController performFetch:&err]) {
        DDLogError(@"获取消息联系人失败:\n%@", err);
        return NO;
    } else {
        XMPPUserCoreDataStorageObject *user = resultsController.fetchedObjects.firstObject;
        NSUInteger unreadMessage = [user.unreadMessages integerValue];
        unreadMessage = (reset ? 0 : unreadMessage + 1);
        user.unreadMessages = @(unreadMessage);
    }
    err = nil;
    [context save:&err];
    if (err) {
        DDLogError(@"更新联系人未读消息数失败:\n%@", err);
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Getters

- (XMPPStream *)xmppStream {
    if (nil == _xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
#if !TARGET_IPHONE_SIMULATOR
        DDLogInfo(@"开启后台连接");
        _xmppStream.enableBackgroundingOnSocket = YES;
#else
        DDLogWarn(@"模拟器不支持后台连接");
#endif
        [self setupXMPP];
    }
    return _xmppStream;
}

- (XMPPReconnect *)xmppReconnect {
    if (nil == _xmppReconnect) {
        _xmppReconnect = [[XMPPReconnect alloc] init];
    }
    return _xmppReconnect;
}

- (XMPPvCardCoreDataStorage *)xmppvCardStorage {
    if (nil == _xmppvCardStorage) {
        _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    }
    return _xmppvCardStorage;
}

- (XMPPvCardTempModule *)xmppvCardModule {
    if (nil == _xmppvCardModule) {
        _xmppvCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage];
    }
    return _xmppvCardModule;
}

- (XMPPRosterCoreDataStorage *)xmppRosterStorage {
    if (nil == _xmppRosterStorage) {
        _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        _xmppRosterStorage.autoRemovePreviousDatabaseFile = NO;
        _xmppRosterStorage.autoRecreateDatabaseFile = NO;
    }
    return _xmppRosterStorage;
}

- (XMPPRoster *)xmppRoster {
    if (nil == _xmppRoster) {
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _xmppRoster.autoFetchRoster = YES;
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    }
    return _xmppRoster;
}

- (XMPPMessageArchivingCoreDataStorage *)xmppMessageStorage {
    if (nil == _xmppMessageStorage) {
        _xmppMessageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    }
    return _xmppMessageStorage;
}

- (XMPPMessageArchiving *)xmppMessage {
    if (nil == _xmppMessage) {
        _xmppMessage = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageStorage];
    }
    return _xmppMessage;
}

#pragma mark Setters


@end
