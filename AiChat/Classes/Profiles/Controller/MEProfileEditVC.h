//
//  MEProfileEditVC.h
//  AiChat
//
//  Created by 庄彪 on 15/7/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEProfileEditVC;

@protocol MEProfileEditVCDelegate <NSObject>

- (void)didChangedProfileInfo;

@end

@interface MEProfileEditVC : UIViewController

/*! @brief  代理 */
@property (nonatomic, weak) id<MEProfileEditVCDelegate> delegate;

/*! @brief  修改的cell */
@property (nonatomic, strong) UITableViewCell *cell;

@end
