//
//  TXLContactsTool.m
//  AiChat
//
//  Created by 庄彪 on 15/7/3.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "TXLContactsTool.h"
#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"
#import "ZHBXMPPConst.h"
#import <RACSubject.h>

@interface TXLContactsTool ()

@property (nonatomic, strong, readwrite) RACSubject *rac_updateSignal;

@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@property (nonatomic, strong, readwrite) NSArray *friends;

@end

@implementation TXLContactsTool

#pragma mark -
#pragma mark Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self loadContactsList];
    }
    return self;
}

#pragma mark -
#pragma mark Private Methods
- (void)loadContactsList {
    DDLOG_INFO
    NSError *err = nil;
    if (![self.resultsController performFetch:&err]) {
        DDLogError(@"%@", err);
    } else {
        [self updateFetchedResults];
    }
}

- (void)updateFetchedResults {
    self.friends = self.resultsController.fetchedObjects;
    [(RACSubject *)self.rac_updateSignal sendNext:nil];
}

#pragma mark -
#pragma mark Getters
- (NSFetchedResultsController *)resultsController {
    if (nil == _resultsController) {
        NSManagedObjectContext *context = [ZHBXMPPTool sharedXMPPTool].xmppRosterStorage.mainThreadManagedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kXmppUserCoreDataStorageObject];

        NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", [ZHBUserInfo sharedUserInfo].jid];
        request.predicate = pre;
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        request.sortDescriptors = @[sort];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    }
    return _resultsController;
}

- (RACSignal *)rac_updateSignal {
    if (nil == _rac_updateSignal) {
        _rac_updateSignal = [[RACSubject subject] setNameWithFormat:@"%@::%@", THIS_FILE, THIS_METHOD];
    }
    return _rac_updateSignal;
}

@end
