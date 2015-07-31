//
//  MEProfileEditVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "MEProfileEditVC.h"
#import <ReactiveCocoa.h>

@interface MEProfileEditVC ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITextField *contentTxtf;

@end

@implementation MEProfileEditVC

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultValue];
    [self setupSignal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Private Methods 

- (void)setupDefaultValue {
    self.title = self.cell.textLabel.text;
    self.contentTxtf.text = self.cell.detailTextLabel.text;
    [self.contentTxtf becomeFirstResponder];
}

- (void)setupSignal {
    @weakify(self);
    [[[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            BOOL needSave = NO;
            if (![self.contentTxtf.text isEqualToString:self.cell.detailTextLabel.text]) {
                self.cell.detailTextLabel.text = self.contentTxtf.text;
                [self.cell layoutSubviews];
                needSave = YES;
            }
            [subscriber sendNext:@(needSave)];
            return nil;
        }];
    }] subscribeNext:^(NSNumber *needSave) {
        @strongify(self);
        if ([needSave boolValue]) {
            if ([self.delegate respondsToSelector:@selector(didChangedProfileInfo)]) {
                [self.delegate didChangedProfileInfo];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
