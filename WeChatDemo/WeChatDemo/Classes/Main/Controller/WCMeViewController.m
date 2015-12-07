//
//  WCMeViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

//如何使用CoreData获取数据
//1.上下文[关联到数据]
//2.FetchRequest
//3.设置过滤和排序
//4.执行请求获取数据

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface WCMeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号


- (IBAction)logoutBtnClick:(id)sender;


@end

@implementation WCMeViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"我";
    
    //获取当前用户的个人信息
    //XMPP框架提供了一个方法直接获取个人信息
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    //设置头像
    if (myvCard.photo) {
        self.headerView.image = [UIImage imageWithData:myvCard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myvCard.nickname;
    //设置微信号
    NSString *userName = [WCUserInfo sharedWCUserInfo].userName;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号：%@",userName];
    
    
}

- (IBAction)logoutBtnClick:(id)sender {
    

    //直接调用AppDelegate类的注销方法
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app xmppUserLogout];
    
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogout];
}
@end
