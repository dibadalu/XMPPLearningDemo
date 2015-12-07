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
- (IBAction)textChange;

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
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    //0.判断用户输入的是否为手机号码
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    //1.把用户注册的数据保存到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUserName = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;

    //2.调用WCXMPPTool的xmppRegister方法
    [WCXMPPTool sharedWCXMPPTool].registerOperation = YES;//标识注册操作
    //提示
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppRegister:^(XMPPResultType type) {
        [weakSelf handleResultType:type];
    }];
}

#pragma mark - 处理注册结果
- (void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        //隐藏之前的提示
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                //回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                //通知代理做事情
                if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)]) {
                    [self.delegate registerViewControllerDidFinishRegister];
                }
                break;
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败，用户名重复" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                [MBProgressHUD showError:@"网络繁忙!" toView:self.view];
                break;
                
        }
    });
    
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textChange {
    
    WCLog(@"text");
    //设置注册按钮的可用状态
//    BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
    BOOL enabled = self.userField.hasText && self.pwdField.hasText;
    self.registerBtn.enabled = enabled;
}


@end
