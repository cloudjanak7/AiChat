//
//  MeProfileDetailTVC.m
//  AiChat
//
//  Created by 庄彪 on 15/7/30.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "MEProfileDetailTVC.h"
#import "MEProfileEditVC.h"
#import "XMPPvCardTemp.h"
#import "ZHBXMPPTool.h"
#import "ZHBUserInfo.h"

@interface MEProfileDetailTVC ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MEProfileEditVCDelegate>
/*! @brief  头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/*! @brief  昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
/*! @brief  帐号 */
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
/*! @brief  性别 */
@property (weak, nonatomic) IBOutlet UILabel *sexLbl;
/*! @brief  地区 */
@property (weak, nonatomic) IBOutlet UILabel *countyLbl;
/*! @brief  个性签名 */
@property (weak, nonatomic) IBOutlet UILabel *noteLbl;
/*! @brief  个人电子名片 */
@property (nonatomic, strong) XMPPvCardTemp *vCard;

@end

@implementation MEProfileDetailTVC

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self loadProfileDetail];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MEProfileEditVC class]]) {
        MEProfileEditVC *profileEditVc = segue.destinationViewController;
        profileEditVc.delegate = self;
        profileEditVc.cell = sender;
    }
}

#pragma mark -
#pragma mark Life Cycle
/*!
 @brief  加载个人信息
 */
- (void)loadProfileDetail {
    if(self.vCard.photo){
        self.headImageView.image = [UIImage imageWithData:self.vCard.photo];
    }
    self.nickNameLbl.text = self.vCard.nickname;
    self.accountLbl.text = [ZHBUserInfo sharedUserInfo].name;
    self.noteLbl.text = self.vCard.note;
    [self.tableView layoutSubviews];
}

/*!
 @brief  更新个人信息的值
 */
- (void)updateCurrentInfo {
    //获取当前的电子名片信息
    self.vCard.photo = UIImagePNGRepresentation(self.headImageView.image);
    self.vCard.nickname = self.nickNameLbl.text;
    self.vCard.note =  self.noteLbl.text;
    
    [[ZHBXMPPTool sharedXMPPTool].xmppvCardModule updateMyvCardTemp:self.vCard];
}

/*!
 @brief  设置用户头像
 */
- (void)setUserHeadIcon {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(2 == buttonIndex){//取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (0 == buttonIndex) {//照相
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {//相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DDLOG_INFO
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headImageView.image = image;
    [self updateCurrentInfo];
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark MEProfileEditVC Delegate
- (void)didChangedProfileInfo {
    [self updateCurrentInfo];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                [self setUserHeadIcon];
                break;
            case 1:
                //跳转修改页面
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            case 3:
                //跳转二维码信息页面
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            case 4:
                //跳转我的地址页面
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            default:
                break;
        }
    }
    if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                //弹出修改性别
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            case 1:
                //跳转地区选择界面
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            case 2:
                //跳转修改界面
                [self performSegueWithIdentifier:@"profile2edit" sender:cell];
                break;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Getters

- (XMPPvCardTemp *)vCard {
    if (nil == _vCard) {
        _vCard = [ZHBXMPPTool sharedXMPPTool].xmppvCardModule.myvCardTemp;
    }
    return _vCard;
}

@end
