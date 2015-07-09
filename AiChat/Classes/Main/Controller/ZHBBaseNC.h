//
//  ZHBBaseNC.h
//  AiChat
//
//  Created by 庄彪 on 15/7/9.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Helper.h"

typedef NS_ENUM(NSUInteger, TabBarItemTag) {
    TabBarItemTagOfMessages = 0,
    TabBarItemTagOfContacts,
    TabBarItemTagOfDiscover,
    TabBarItemTagOfMe
};

@interface ZHBBaseNC : UINavigationController

@end
