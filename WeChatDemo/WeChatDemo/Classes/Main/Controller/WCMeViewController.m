//
//  WCMeViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"

@interface WCMeViewController ()

- (IBAction)logoutBtnClick:(id)sender;


@end

@implementation WCMeViewController


- (IBAction)logoutBtnClick:(id)sender {
    
    //直接调用AppDelegate类的注销方法
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app xmppUserLogout];
}
@end
