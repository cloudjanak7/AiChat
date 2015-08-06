//
//  ZHBChatCell.h
//  AiChat
//
//  Created by 庄彪 on 15/8/5.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
@class XMPPMessageArchiving_Message_CoreDataObject;

@interface ZHBChatCell : UITableViewCell

@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *message;

@property (nonatomic, assign) CGFloat height;

@end
