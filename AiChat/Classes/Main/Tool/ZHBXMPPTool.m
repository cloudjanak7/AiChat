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
#import "NSString+Helper.h"
#import "UIDevice+Hardware.h"
#import <ReactiveCocoa.h>

NSString * const kXMPPMessageBodyTypeText  = @"text";
NSString * const kXMPPMessageBodyTypeImage = @"image";
NSString * const kXMPPMessageBodyTypeVoice = @"voice";
NSString * const kXMPPMessageBodyType = @"bodyType";

@interface ZHBXMPPTool ()<XMPPStreamDelegate, XMPPRosterDelegate, XMPPRoomDelegate, XMPPvCardAvatarDelegate, XMPPvCardTempModuleDelegate>

@property (nonatomic, strong, readwrite) XMPPStream *xmppStream;

@property (nonatomic, strong, readwrite) XMPPvCardTempModule *xmppvCardModule;

@property (nonatomic, strong, readwrite) XMPPvCardAvatarModule *xmppAvatarModule;

@property (nonatomic, strong, readwrite) XMPPRoster *xmppRoster;

@property (nonatomic, strong, readwrite) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong, readwrite) XMPPMessageArchivingCoreDataStorage *xmppMessageStorage;

@property (nonatomic, strong, readwrite) XMPPRoomCoreDataStorage *xmppRoomStorage;

@property (nonatomic, strong, readwrite) XMPPRoom *xmppRoom;

@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage; /**< 电子名片存储 */

@property (nonatomic, strong) XMPPReconnect *xmppReconnect; /**< 自动重连模块 */

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessage; /**< 聊天消息模块 */

@property (nonatomic, copy) XMPPResultCallBack callBack; /**< 登录注册回掉block */

@property (nonatomic, assign, getter=isRegisterOperation) BOOL registerOperation; /**< 是否为注册操作 */

/*! @brief  <#Description#> */
@property (nonatomic, strong, readwrite) RACSubject *rac_myVCardUpdateSignal;

/*! @brief  <#Description#> */
@property (nonatomic, strong, readwrite) RACSubject *rac_messageUpdateSignal;

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
    self.callBack = nil;
    [self.xmppStream disconnect];
    self.callBack = callBack;
    [self connectToHost];
}

- (void)userRegister:(XMPPResultCallBack)callBack {
    self.registerOperation = YES;
    self.callBack = nil;
    [self.xmppStream disconnect];
    self.callBack = callBack;
    [self connectToHost];
}

- (void)userLogout {
    [ZHBUserInfo sharedUserInfo].autoLogin = NO;
    [[ZHBUserInfo sharedUserInfo] saveInfoToSanbox];
    [self sendOfflineToHost];
    [self.xmppStream disconnect];
}

- (void)sendMessage:(NSString *)message toJID:(XMPPJID *)jid bodyType:(NSString *)type {
    DDLOG_INFO
    XMPPMessage *xmppMessage = [XMPPMessage messageWithType:@"chat" to:jid];
    [xmppMessage addAttributeWithName:kXMPPMessageBodyType stringValue:type];
    [xmppMessage addBody:message];
    DDLogInfo(@"发送消息-->%@", jid);
    [self.xmppStream sendElement:xmppMessage];
}

- (BOOL)resetUnreadMessage:(NSString *)fromJidStr {
    return [self updateUnreadMessage:fromJidStr reset:YES];
}

- (BOOL)userExistsWithJID:(NSString *)jidStr {
    NSRange range = [[jidStr trimString] rangeOfString:[NSString stringWithFormat:@"@%@", kXmppDoMain]];
    if (NSNotFound == range.location) {
        jidStr = [NSString stringWithFormat:@"%@@%@", jidStr, kXmppDoMain];
    }
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    return [self.xmppRosterStorage userExistsWithJID:jid xmppStream:self.xmppStream];
}

- (void)subscribeUser:(NSString *)jidStr {
    NSRange range = [[jidStr trimString] rangeOfString:[NSString stringWithFormat:@"@%@", kXmppDoMain]];
    if (NSNotFound == range.location) {
        jidStr = [NSString stringWithFormat:@"%@@%@", jidStr, kXmppDoMain];
    }
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    [self.xmppRoster subscribePresenceToUser:jid];
}

- (void)createChatRoom {
    [self.xmppRoom activate:self.xmppStream];
    [self.xmppRoom configureRoomUsingOptions:nil];
    [self.xmppRoom joinRoomUsingNickname:@"我是谁" history:nil];
    [self.xmppRoom fetchConfigurationForm];
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
    DDLogError(@"%@", error);
//    if (self.callBack) {
//        self.callBack(XMPPStatusTypeNetErr);
//    }
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
    if (!message.body || [self.chatJid isEqualToString:message.from.bare]) return;
    DDLOG_INFO
    if ([message.type isEqualToString:kMessageTypeChat]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addUnreadMessage:message.from.bare];
        });
    }
}

#pragma mark -
#pragma mark XMPPRoster Delegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    DDLOG_INFO
}

#pragma mark -
#pragma mark XMPPvCardAvatar Delegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid {
    DDLOG_INFO
}

#pragma mark -
#pragma mark XMPPvCardTempModule Delegate
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid {
    DDLOG_INFO
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        if ([jid.bare isEqualToString:[ZHBUserInfo sharedUserInfo].jid]) {
            [(RACSubject *)self.rac_myVCardUpdateSignal sendNext:vCardTemp];
        }
    });

}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    DDLOG_INFO
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error {
    DDLOG_INFO
    DDLogError(@"%@", error);
}

#pragma mark -
#pragma mark XMPPRoom Delegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult {
    DDLOG_INFO
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    DDLOG_INFO
}

- (void)xmppRoomDidLeave:(XMPPRoom *)sender {
    DDLOG_INFO
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    DDLOG_INFO
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult {
    DDLOG_INFO
}

- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError {
    DDLOG_INFO
}

#pragma mark -
#pragma mark Private Methods

- (void)connectToHost {
    XMPPJID *myJID = [XMPPJID jidWithUser:[ZHBUserInfo sharedUserInfo].name domain:kXmppDoMain resource:nil];
    self.xmppStream.myJID = myJID;
    self.xmppStream.hostName = kXmppHostName;
    self.xmppStream.hostPort = kXmppHostPort;

    [self.xmppStream connectWithTimeout:kXmppTimeout error:nil];
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
    [self.xmppAvatarModule activate:self.xmppStream];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppMessage activate:self.xmppStream];
    [self.xmppRoom activate:self.xmppStream];
}

- (void)teardownXMPP {
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    [self.xmppRoom removeDelegate:self];
    [self.xmppvCardModule removeDelegate:self];
    [self.xmppAvatarModule removeDelegate:self];
    
    [self.xmppReconnect deactivate];
    [self.xmppvCardModule deactivate];
    [self.xmppAvatarModule deactivate];
    [self.xmppRoster deactivate];
    [self.xmppMessage deactivate];
    [self.xmppRoom deactivate];
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppvCardModule = nil;
    self.xmppvCardStorage = nil;
    self.xmppRoster = nil;
    self.xmppRosterStorage = nil;
    self.xmppMessage = nil;
    self.xmppMessageStorage = nil;
    self.xmppRoom = nil;
    self.xmppRoomStorage = nil;
    self.xmppAvatarModule = nil;
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kXmppUserCoreDataStorageObject];
    
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
    //发送消息更新信号
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [(RACSubject *)weakSelf.rac_messageUpdateSignal sendNext:nil];
    });

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
        [_xmppvCardModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _xmppvCardModule;
}

- (XMPPvCardAvatarModule *)xmppAvatarModule {
    if (nil == _xmppAvatarModule) {
        _xmppAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardModule];
        _xmppAvatarModule.autoClearMyvcard = NO;
        [_xmppAvatarModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _xmppAvatarModule;
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

- (XMPPRoomCoreDataStorage *)xmppRoomStorage {
    if (nil == _xmppRoomStorage) {
        _xmppRoomStorage = [[XMPPRoomCoreDataStorage alloc] init];
    }
    return _xmppRoomStorage;
}

- (XMPPRoom *)xmppRoom {
    if (nil == _xmppRoom) {
        XMPPJID *roomJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", @"chatroom", kXmppChatRoomDoMain]];
        _xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self.xmppRoomStorage jid:roomJid dispatchQueue:dispatch_get_main_queue()];
        [_xmppRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _xmppRoom;
}

- (RACSignal *)rac_myVCardUpdateSignal {
    if (nil == _rac_myVCardUpdateSignal) {
        _rac_myVCardUpdateSignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _rac_myVCardUpdateSignal;
}

- (RACSignal *)rac_messageUpdateSignal {
    if (nil == _rac_messageUpdateSignal) {
        _rac_messageUpdateSignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _rac_messageUpdateSignal;
}

#pragma mark Setters


@end

