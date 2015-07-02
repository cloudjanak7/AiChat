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

@interface ZHBXMPPTool ()<XMPPStreamDelegate>

@property (nonatomic, strong, readwrite) XMPPStream *xmppStream;

@property (nonatomic, copy) XMPPResultCallBack callBack;

@end

@implementation ZHBXMPPTool

#pragma mark -
#pragma mark Life Cycle

ZHBSingletonM(XMPPTool)

#pragma mark -
#pragma mark Public Methods

- (void)userLogin:(XMPPResultCallBack)callBack {
    self.callBack = callBack;
    if ([self.xmppStream isConnecting]) {
        DDLogWarn(@"XMPP服务器已经连接");
    }
    [self.xmppStream disconnect];
    DDLogWarn(@"取消上次连接");
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

#pragma mark -
#pragma mark XMPPStream Delegate

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    DDLogError(@"连接服务器超时");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DDLogInfo(@"连接服务器成功");
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DDLogWarn(@"与服务器断开连接");
    DDLogVerbose(@"error:\n%@", error);
    if (error && self.callBack) {
        self.callBack(XMPPStatusTypeNetErr);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    DDLogInfo(@"验证密码成功");
    [self sendOnlineToHost];
    if (self.callBack) {
        self.callBack(XMPPStatusTypeLoginSuccess);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    DDLogError(@"验证密码失败");
    DDLogVerbose(@"error:\n%@", error);
    if (self.callBack) {
        self.callBack(XMPPStatusTypeLoginFailure);
    }
}


#pragma mark -
#pragma mark Private Methods

- (void)connectToHost {
    NSAssert(nil != self.xmppStream, @"xmppStream未设置");
    DDLogInfo(@"开始连接服务器");
    XMPPJID *myJID = [XMPPJID jidWithUser:[ZHBUserInfo sharedUserInfo].name domain:xmppDoMain resource:[UIDevice hardWareName]];
    self.xmppStream.myJID = myJID;
    self.xmppStream.hostName = xmppHostName;
    self.xmppStream.hostPort = xmppHostPort;

    [self.xmppStream connectWithTimeout:xmppTimeout error:nil];
}

- (void)sendPwdToHost {
    DDLogInfo(@"发送密码到服务器进行确认");
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:[ZHBUserInfo sharedUserInfo].password error:&error];
}

- (void)sendOnlineToHost {
    DDLogInfo(@"设置在线状态");
    XMPPPresence *presence = [XMPPPresence presence];
    DDLogVerbose(@"%@", presence);
    [self.xmppStream sendElement:presence];
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
    }
    return _xmppStream;
}

#pragma mark Setters


@end
