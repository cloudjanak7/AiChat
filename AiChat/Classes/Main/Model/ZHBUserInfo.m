//
//  ZHBUserEntity.m
//  AiChat
//
//  Created by 庄彪 on 15/7/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBUserInfo.h"
#import "ZHBXMPPConst.h"

#define ZHBUserDefaults [NSUserDefaults standardUserDefaults]

@implementation ZHBUserInfo

ZHBSingletonM(UserInfo)

#pragma mark -
#pragma mark Public Methods
- (void)saveInfoToSanbox {
    [ZHBUserDefaults setObject:self.name forKey:userName];
    [ZHBUserDefaults setObject:self.password forKey:userPwd];
    [ZHBUserDefaults setObject:@(self.canAutoLogin) forKey:loginStatus];
    [ZHBUserDefaults synchronize];
}

- (void)userInfoFromSanbox {
    self.name      = [[ZHBUserDefaults objectForKey:userName] stringValue];
    self.password  = [[ZHBUserDefaults objectForKey:userPwd] stringValue];
    self.autoLogin = [[ZHBUserDefaults objectForKey:loginStatus] boolValue];
}

#pragma mark -
#pragma mark Getters and Setters

- (NSString *)jid {
    return [NSString stringWithFormat:@"%@@%@", self.name, xmppDoMain];
}

@end
