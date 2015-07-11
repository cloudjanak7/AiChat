//
//  XXContactMessage.h
//  AiChat
//
//  Created by 庄彪 on 15/7/11.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPMessageArchiving_Contact_CoreDataObject;
@class XMPPUserCoreDataStorageObject;

@interface XXContactMessage : NSObject

@property (nonatomic, strong) XMPPMessageArchiving_Contact_CoreDataObject *recentMessage;

@property (nonatomic, strong) XMPPUserCoreDataStorageObject *friendUser;

@end
