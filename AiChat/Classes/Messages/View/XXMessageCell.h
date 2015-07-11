//
//  XXMessageCell.h
//  AiChat
//
//  Created by 庄彪 on 15/7/10.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXContactMessage;

@interface XXMessageCell : UITableViewCell

@property (nonatomic, strong) XXContactMessage *contactMessage;

@end
