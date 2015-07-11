//
//  XXMessageCell.m
//  AiChat
//
//  Created by 庄彪 on 15/7/10.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "XXMessageCell.h"
#import "XXContactMessage.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "NSDate+XMPPDateTimeProfiles.h"

@interface XXMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *imagesView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation XXMessageCell

#pragma mark -
#pragma mark Life Cycle

- (void)awakeFromNib {
#warning TODO 设置样式
}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

- (void)setupCell {
    self.timeLbl.text = [self.contactMessage.recentMessage.mostRecentMessageTimestamp xmppTimeString];
    self.titleLbl.text = self.contactMessage.recentMessage.bareJidStr;
    self.subTitleLbl.text = self.contactMessage.recentMessage.mostRecentMessageBody;
    DDLogInfo(@"unreadMessages:%@", self.contactMessage.friendUser.unreadMessages);
}

#pragma mark -
#pragma mark Setters

- (void)setMessage:(XMPPMessageArchiving_Contact_CoreDataObject *)message {
    [self setupCell];
}

- (void)setContactMessage:(XXContactMessage *)contactMessage {
    _contactMessage = contactMessage;
    [self setupCell];
}


@end
