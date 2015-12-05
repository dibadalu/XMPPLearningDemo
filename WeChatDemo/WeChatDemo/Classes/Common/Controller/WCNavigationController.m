//
//  WCNavigationController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

+ (void)initialize{
    
    
}

/**
 *  设置导航栏的主题
 */
+ (void)setupNavTheme{
    //设置导航栏的样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //1.设置导航栏的背景
    //高度不会拉伸，但是宽度会自动拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    //2.设置栏的字体
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
     //3.设置状态栏的样式
    //Xcode5后，状态栏的样式由导航控制器决定
#warning 记得在info.plist设置相关属性
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// 结论：如果控制器是由导航控制器管理的，设置状态栏的样式时，要在导航控制器设置
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
