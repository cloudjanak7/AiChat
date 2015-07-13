//
//  TXLChatCell.h
//  AiChat
//
//  Created by 庄彪 on 15/7/12.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPMessageArchiving_Message_CoreDataObject;

@interface TXLChatCell : UITableViewCell

@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *message;

@property (nonatomic, assign) CGFloat height;

@end
