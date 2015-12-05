//
//  WCOtherLoginViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WCOtherLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;


@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftLayoutConstraint.constant = 10;
        self.rightLayoutConstraint.constant = 10;
    }
    
    //设置textFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置按钮的背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
}

#pragma mark - 登录
- (IBAction)loginBtnClick:(id)sender {
    
    /*
     * 官方的登录实现
     * 1.把用户名和密码放在沙盒里
     * 2.调用AppDelegate的一个connect连接服务器并登录
     */
    
    NSString *userName = self.userField.text;
    NSString *pwd = self.pwdField.text;
    
    //保存到沙盒——偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:pwd forKey:@"pwd"];
    [defaults synchronize];
    
    //用户登录
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app xmppUserLogin];
    
}





@end
