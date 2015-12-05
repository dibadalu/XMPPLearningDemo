//
//  AppDelegate.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"

/**
 *  在代理类实现登录
 * 1.初始化XMPPStream
 * 2.连接到服务器[记得传一个JID]
 * 3.连接到服务器成功后，再发送密码授权
 * 4.授权成功后，发送“在线”
 */

@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

//1.初始化XMPPStream
- (void)setupXMPPStream;

//2.连接到服务器[传一个JID]
- (void)connectToHost;

//3.连接到服务器成功后，再发送密码授权
- (void)sendPwdToHost;

//4.授权成功后，发送“在线”
- (void)sendOnlineToHost;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置导航栏的背景
    [WCNavigationController setupNavTheme];
    
    return YES;
}

#pragma mark - private method
#pragma mark - 初始化XMPPStream
- (void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    
}

#pragma mark - 连接到服务器
- (void)connectToHost{
    WCLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置JID
    //resource：标识用户登录的客户端
    
    //从沙盒获取用户名
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"dibadalu.local" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器域名
    _xmppStream.hostName = @"dibadalu.local";//不仅可以是域名，还可以是IP地址
    //设置端口 如果服务器端口是5222，可以省略
//        _xmppStream.hostPort = 15222;
    
    //连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        WCLog(@"%@",error);
    };
    
    
}

#pragma mark - 连接到服务器成功后，再发送密码授权
- (void)sendPwdToHost{
    WCLog(@"再发送密码授权");
    NSError *error = nil;
    
    //从沙盒获取密码
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}

#pragma mark - 授权成功后，发送“在线”消息
- (void)sendOnlineToHost{
    WCLog(@"发送在线消息");
    XMPPPresence *presence = [XMPPPresence presence];
    WCLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}


#pragma mark - XMPPStream的代理
#pragma mark - 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    WCLog(@"与主机连接成功");
    
    //主机连接成功后，发送密码进行授权
    [self sendPwdToHost];
    
}

#pragma mark - 与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误，代表连接失败 如端口错误： Error Domain=NSPOSIXErrorDomain Code=61 "Connection refused" UserInfo=0x7fb43b7aa6b0 {NSLocalizedDescription=Connection refused, NSLocalizedFailureReason=Error in connect() function}
    //如果没有错误，表示正常的断开连接（人为断开）
    
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetErr);
    }
    
    WCLog(@"与主机断开连接:%@",error);
    
}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    WCLog(@"授权成功");
    
    //发送“在线”消息
    [self sendOnlineToHost];
    
    //回调控制器登录成功
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }

}

#pragma mark - 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    WCLog(@"授权失败--%@",error);
   
#warning 注意判断有无值
    //判断block有无值，再回调给“登录控制器”
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    
    
}

#pragma mark - puplic method
#pragma mark - 注销
- (void)xmppUserLogout{
    
    //1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
    //3.回到登录界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
    
}

#pragma mark - 用户登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    //先把block存起来
    _resultBlock = resultBlock;
    
    /*
     Error Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd3f8e698c0 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
     */
    //如果以前连接过服务器，要断开
    [_xmppStream disconnect];
    
    //连接主机，成功后发送密码
    [self connectToHost];
}

@end
