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
    [ZHBUserDefaults setObject:self.name forKey:kUserName];
    [ZHBUserDefaults setObject:self.password forKey:kUserPwd];
    [ZHBUserDefaults setBool:self.canAutoLogin forKey:kLoginStatus];
    [ZHBUserDefaults synchronize];
}

- (void)userInfoFromSanbox {
    self.name      = [ZHBUserDefaults objectForKey:kUserName];
    self.password  = [ZHBUserDefaults objectForKey:kUserPwd];
    self.autoLogin = [ZHBUserDefaults boolForKey:kLoginStatus];
}

#pragma mark -
#pragma mark Getters and Setters

- (NSString *)jid {
    return [NSString stringWithFormat:@"%@@%@", self.name, kXmppDoMain];
}

@end
