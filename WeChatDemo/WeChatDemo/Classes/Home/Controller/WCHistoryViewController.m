//
//  WCHistoryViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/10.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCHistoryViewController.h"

@interface WCHistoryViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


@end

@implementation WCHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxx:) name:UIKeyboardDidShowNotification object:nil];
    //监听登录状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusDidChange:) name:WCLoginStatusDidChangeNotification object:nil];
    
}

#pragma mark - action method
- (void)loginStatusDidChange:(NSNotification *)noti{
    
    WCLog(@"%@",noti.userInfo);
    
    //通知是在子线程被调用，UI刷新要放在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取登录状态
        int status = [noti.userInfo[WCLoginStatus] intValue];
        switch (status) {
            case XMPPResultTypeConnecting:
                WCLog(@"正在连接");
                [self.indicatorView startAnimating];
                break;
            case XMPPResultTypeNetErr:
                WCLog(@"连接失败");
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginSuccess:
                WCLog(@"登录成功");
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginFailure:
                WCLog(@"登录失败");
                [self.indicatorView stopAnimating];
                break;
        }
    });
    
}





@end
