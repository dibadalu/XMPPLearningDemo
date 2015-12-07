//
//  AppDelegate.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    WCLog(@"%@",path);
    
    //打开XMPP的日志
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //设置导航栏的背景
    [WCNavigationController setupNavTheme];
    
    //从沙盒加载用户的数据到单例
    [[WCUserInfo sharedWCUserInfo] loadUserInfoFromSanbox];
    
    //判断用户的登录状态,如果YES直接来到主界面
    if ([WCUserInfo sharedWCUserInfo].loginStatus) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
        //自动登录到服务器
        [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
    }
    
    return YES;
}

@end
