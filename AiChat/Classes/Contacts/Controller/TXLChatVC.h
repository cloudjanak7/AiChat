//
//  TXLChatVC.h
//  AiChat
//
//  Created by 庄彪 on 15/7/4.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject;

@interface TXLChatVC : UIViewController

@property (nonatomic, strong) XMPPUserCoreDataStorageObject *friendUser;

@end
