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
- (IBAction)cancel:(id)sender;


@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"其它方式登录";
    
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
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    //登录之前给个提示
#warning 注意显示在当前控制器的view上
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    
    //用户登录
    AppDelegate *app = [UIApplication sharedApplication].delegate;
#warning weak self弱引用
    __weak typeof(self) weakSelf = self;
    [app xmppUserLogin:^(XMPPResultType type) {
        //处理请求结果
        [weakSelf handleResultType:type];
    }];
    
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 处理请求结果
- (void)handleResultType:(XMPPResultType)type{

    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                WCLog(@"登录成功");
                //登录到主界面
                [self enterMainView];
                break;
            case XMPPResultTypeLoginFailure:
                WCLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或密码不正确" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                WCLog(@"网络超时");
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
        }
    });
    
}

/**
 *  登录到主界面
 */
- (void)enterMainView{
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功来到主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}


- (void)dealloc{
    WCLog(@"%s",__func__);
}




@end
