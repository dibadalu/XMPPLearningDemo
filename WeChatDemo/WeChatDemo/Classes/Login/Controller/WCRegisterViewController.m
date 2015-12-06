//
//  WCRegisterViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//
#warning 在storyboard拷贝要记得取消关联

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLaoutConstraint;

- (IBAction)registerBtnClick:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftLayoutConstraint.constant = 10;
        self.rightLaoutConstraint.constant = 10;
    }
    
    //设置textFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置按钮的背景图片
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

}


- (IBAction)registerBtnClick:(id)sender {
    
    //1.把用户注册的数据保存到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUserName = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    
    //2.调用AppDelegate的xmppRegister方法
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.registerOperation = YES;//标识注册操作
    [app xmppRegister:^(XMPPResultType type) {
        
    }];
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
