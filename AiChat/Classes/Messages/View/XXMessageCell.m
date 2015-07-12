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
#import "NSDate+Helper.h"
#import <ReactiveCocoa.h>

@interface XXMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *imagesView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIButton *unreadMessageBtn;

@end

@implementation XXMessageCell

#pragma mark -
#pragma mark Life Cycle
- (void)awakeFromNib {

}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

- (void)updateUnreadMessage {
    NSNumber *unreadMessages = self.contactMessage.friendUser.unreadMessages;
    if (unreadMessages.integerValue > 0) {
        self.unreadMessageBtn.hidden = NO;
        [self.unreadMessageBtn setTitle:[unreadMessages stringValue] forState:UIControlStateNormal];
    } else {
        self.unreadMessageBtn.hidden = YES;
    }
}

- (void)setupCell {
    self.timeLbl.text = [self.contactMessage.recentMessage.mostRecentMessageTimestamp timeString];
    self.titleLbl.text = self.contactMessage.recentMessage.bareJidStr;
    self.subTitleLbl.text = self.contactMessage.recentMessage.mostRecentMessageBody;
    [self updateUnreadMessage];
}

#pragma mark -
#pragma mark Setters

- (void)setContactMessage:(XXContactMessage *)contactMessage {
    _contactMessage = contactMessage;
    [self setupCell];
}

@end
