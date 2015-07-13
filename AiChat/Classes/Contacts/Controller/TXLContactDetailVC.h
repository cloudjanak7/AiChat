//
//  TXLContactDetailVC.h
//  AiChat
//
//  Created by 庄彪 on 15/7/13.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject;

@interface TXLContactDetailVC : UIViewController

@property (nonatomic, strong) XMPPUserCoreDataStorageObject *user;

@end
