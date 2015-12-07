//
//  WCLoginViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"

@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置textField和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    //设置按钮的背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    //设置用户名为上次登录的用户名(userInfo单例)
    NSString *userName = [WCUserInfo sharedWCUserInfo].userName;
    self.userLabel.text = userName;
    
}

- (IBAction)loginBtnClick:(id)sender {
    
    //保存用户数据到userInfo单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.userName = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    [super login];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //获取注册控制器
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *nav = destVc;
        if ([nav.topViewController isKindOfClass:[WCRegisterViewController class]]) {            
            //获取根控制器
            WCRegisterViewController *registerVc =(WCRegisterViewController *) nav.topViewController;
            //设置注册控制器的代理
            registerVc.delegate = self;
        }
    }
    
}

#pragma mark - WCRegisterViewControllerDelegate代理
- (void)registerViewControllerDidFinishRegister{
    WCLog(@"完成注册");
    
    //完成注册 userLabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUserName;
    
    //提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
}


@end





