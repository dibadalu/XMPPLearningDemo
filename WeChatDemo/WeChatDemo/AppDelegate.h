//
//  AppDelegate.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMPPResultTypeLoginSuccess,
    XMPPResultTypeLoginFailure,
    XMPPResultTypeNetErr,
    XMPPResultTypeRegisterSuccess,
    XMPPResultTypeRegisterFailure
}XMPPResultType;

//设置block的别名
typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 注册操作标识 YES表示注册，NO表示登录 */
@property(nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;

/** 用户注销 */
- (void)xmppUserLogout;

/** 用户登录 */
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/** 用户注册 */
- (void)xmppRegister:(XMPPResultBlock)resultBlock;





@end

