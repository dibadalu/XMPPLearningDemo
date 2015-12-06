//
//  WCBaseLoginViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

#pragma mark - 登录
- (void)login{
    
    /*
     * 官方的登录实现
     * 1.把用户名和密码放在UserInfo的单例
     
     * 2.调用AppDelegate的一个connect连接服务器并登录
     */
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    //登录之前给个提示
#warning 注意显示在当前控制器的view上
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    
    //用户登录
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.registerOperation = NO;
#warning weak self弱引用
    __weak typeof(self) weakSelf = self;
    [app xmppUserLogin:^(XMPPResultType type) {
        //处理请求结果
        [weakSelf handleResultType:type];
    }];
    
    
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
    
    //更改用户的登录状态为YES
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    //把用户登录成功的数据，保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功来到主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}

@end
