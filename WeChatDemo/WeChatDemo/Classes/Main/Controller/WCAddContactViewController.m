//
//  WCAddContactViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCAddContactViewController.h"

@interface WCAddContactViewController ()<UITextFieldDelegate>

@end

@implementation WCAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //添加好友
    //1.获取好友账号
    NSString *userName = textField.text;
    WCLog(@"%@",userName);
    
    //判断是否是手机号码
    if (![textField isTelphoneNum]) {
        //提示
        [self showAlert:@"请输入手机号码"];
        return YES;
    }
    
    //判断是否是添加自己
    if ([userName isEqualToString:[WCUserInfo sharedWCUserInfo].userName]) {
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
    
    //好友的JID
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",userName,domain];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    
    //判断好友是否已经存在
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:jid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        [self showAlert:@"当前好友已经存在"];
        return YES;
    }
    
    //2.发送好友添加的请求
    // 添加好友，xmpp叫订阅subscribePresence
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:jid];
//    [MBProgressHUD showError:@"添加成功" toView:self.view];
    
    return YES;
}

/**
 *  提示
 */
- (void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}



@end
