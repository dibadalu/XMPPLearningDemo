//
//  WCProfileViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileTableViewController.h"


@interface WCProfileViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WCEditProfileTableViewControllerDelegate>

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
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;//获取个人的电子名片信息
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
        // sender 传递给下一个控制器的参数
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];

    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取编辑个人信息的控制器
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCEditProfileTableViewController class]]) {
        WCEditProfileTableViewController *editVc = destVc;
        editVc.delegate = self;//设置代理
        editVc.cell = sender;
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
    
    //更新数据
    [self editProfileTableViewControllerDidSave];
    
}

#pragma mark - WCEditProfileTableViewControllerDelegate
- (void)editProfileTableViewControllerDidSave{
    
    //保存
    //更新到服务器
    //获取当前的电子名片信息
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //图片
     myVCard.photo = UIImagePNGRepresentation(self.headerView.image);

    //昵称
    myVCard.nickname = self.nickNameLabel.text;
    
    //公司
    myVCard.orgName = self.orgNameLabel.text;
    
    //部门
    if (self.orgUnitLabel.text > 0) {
        myVCard.orgUnits = @[self.orgUnitLabel.text];
    }
    
    //职位
    myVCard.title = self.titleLabel.text;
    
    //电话
    myVCard.note = self.phoneLabel.text;
    
    //邮件
    myVCard.mailer = self.emailLabel.text;
    
    //这个方法内部会实现数据上传到服务器
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myVCard];
    

}



@end

/*
 Warning: Attempt to present <UIImagePickerController: 0x7c40a400>  on <WCProfileViewController: 0x7a19b5b0> which is already presenting (null)
 模拟器问题，换模拟器
 */
