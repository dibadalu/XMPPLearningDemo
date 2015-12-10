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

#warning iOS7以及iOS7之前，socket是不支持后台运行，被挂起了，需要在plist做配置

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
        //1秒后自动登录
#warning 一般情况都不会立刻连接，需要等待一会
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
        });
    }
    
#warning iOS8后本地通知需要注册应用，接受通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    return YES;
}

@end
