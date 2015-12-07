//
//  WCXMPPTool.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCXMPPTool.h"


/**
 *  在代理类实现登录
 * 1.初始化XMPPStream
 * 2.连接到服务器[记得传一个JID]
 * 3.连接到服务器成功后，再发送密码授权
 * 4.授权成功后，发送“在线”
 */

@interface WCXMPPTool ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    
    XMPPvCardTempModule *_vCard;//电子名片
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    
    XMPPvCardAvatarModule *_avatar;//头像模块
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


@implementation WCXMPPTool

singleton_implementation(WCXMPPTool);

#pragma mark - private method
#pragma mark - 初始化XMPPStream
- (void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
#warning 每一个模块添加后都要激活
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    
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
    //从userInfo单例获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {//注册
        user = [WCUserInfo sharedWCUserInfo].registerUserName;
    }else{//登录
        user = [WCUserInfo sharedWCUserInfo].userName;
    }
    
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
    
    //从单例获取密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    
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
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        //主机连接成功后，发送登录的密码进行授权
        [self sendPwdToHost];
    }
    
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

#pragma mark - 授权成功（登录成功）
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

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    //注册成功，回调给注册控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"注册失败--%@",error);
    /*
     注册失败--<iq xmlns="jabber:client" type="error" to="dibadalu.local/6cda2d51"><query xmlns="jabber:iq:register"><username>12345678900</username><password>123456</password></query><error code="409" type="cancel"><conflict xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"/></error></iq>
     */
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
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
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"login"];
    
    
    //4.更改用户的登录状态为NO
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    //把用户登录成功的数据，保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
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
    
    //连接主机，成功后发送“登录”的密码
    [self connectToHost];
}

#pragma mark - 用户注册
- (void)xmppRegister:(XMPPResultBlock)resultBlock{
    
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务器，要断开
    [_xmppStream disconnect];
    
    //连接主机，成功后发送“注册”的密码
    [self connectToHost];
    
}



@end
