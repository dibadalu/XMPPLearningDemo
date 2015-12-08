//
//  WCUserInfo.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCUserInfo.h"

//别名
#define UserNameKey @"userName"
#define LoginStatusKey @"loginStatus"
#define PwdKey @"pwd"
//定义域名
static NSString *domain = @"dibadalu.local";

@implementation WCUserInfo

singleton_implementation(WCUserInfo);

- (void)saveUserInfoToSanbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:UserNameKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults synchronize];
    
    
}

- (void)loadUserInfoFromSanbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName = [defaults objectForKey:UserNameKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.pwd = [defaults objectForKey:PwdKey];
    
}

- (NSString *)jid{
    
    return [NSString stringWithFormat:@"%@@%@",self.userName,domain];
}

@end
