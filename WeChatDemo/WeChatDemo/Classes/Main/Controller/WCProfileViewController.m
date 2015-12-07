//
//  WCProfileViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface WCProfileViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgUnitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件


@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    //加载电子名片信息
    [self loadVCard];
    
}

/**
 *  加载电子名片信息
 */
- (void)loadVCard{
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    //设置头像
    if (myvCard.photo) {
        self.headerView.image = [UIImage imageWithData:myvCard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myvCard.nickname;
    //设置微信号
    self.weixinNumLabel.text = [WCUserInfo sharedWCUserInfo].userName;
    //公司
    self.orgNameLabel.text = myvCard.orgName;
    //部门
    if (myvCard.orgUnits.count > 0) {
        self.orgUnitLabel.text = myvCard.orgUnits[0];
    }
    //职位
    self.titleLabel.text = myvCard.title;
    //电话
#warning myvCard.telecomsAddresses这个get方法，没有对电子名片的xml数据进行解析
    //使用note字段充当电话
    self.phoneLabel.text = myvCard.note;
    //邮件
    // myvCard.emailAddresses 用mailer充当邮件
    self.emailLabel.text = myvCard.mailer;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取cell的tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    //判断
    if (tag == 2) {//不做任何操作
        WCLog(@"不做任何操作");
        return;
    }
    
    if (tag == 0) {//选择照片
        WCLog(@"选择照片");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }else{//跳到下一个控制器
        WCLog(@"跳到下一个控制器");
    }
    
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2) {//取消
    
        WCLog(@"取消");
        return;
        
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    imagePicker.delegate = self;
    //设置允许编辑
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {//照相
         WCLog(@"照相");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{//相册
         WCLog(@"相册");
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    WCLog(@"%@",info);
    //获取图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headerView.image = image;
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
     Warning: Attempt to present <UIImagePickerController: 0x7c40a400>  on <WCProfileViewController: 0x7a19b5b0> which is already presenting (null)
     模拟器问题，换模拟器
     */
}

@end
