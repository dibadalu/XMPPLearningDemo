//
//  WCXMPPTool.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

//枚举
typedef enum {
    XMPPResultTypeConnecting,//连接中
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络连接失败
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

/** 登录状态 */
extern NSString *const WCLoginStatusDidChangeNotification;

//设置block的别名
typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

#define WCLoginStatus @"longinStatus"

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool);

/** xmppStream */
@property(nonatomic,strong,readonly) XMPPStream *xmppStream;
/** 电子名片 */
@property(nonatomic,strong,readonly) XMPPvCardTempModule *vCard;
/** 花名册的数据存储 */
@property(nonatomic,strong,readonly) XMPPRosterCoreDataStorage *rosterStorage;
/** 花名册模块 */
@property(nonatomic,strong,readonly) XMPPRoster *roster;
/** 聊天的数据存储 */
@property(nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *msgStorage;


/** 注册操作标识 YES表示注册，NO表示登录 */
@property(nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;

/** 用户注销 */
- (void)xmppUserLogout;

/** 用户登录 */
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/** 用户注册 */
- (void)xmppRegister:(XMPPResultBlock)resultBlock;



@end
