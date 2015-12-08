//
//  WCUserInfo.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

/** 域名 */
static NSString *domain = @"dibadalu.local";

@interface WCUserInfo : NSObject

singleton_interface(WCUserInfo);

/** 用户名 */
@property(nonatomic,copy) NSString *userName;
/** 密码 */
@property(nonatomic,copy) NSString *pwd;
/** 登录的状态 YES表示登录过，NO表示注销*/
@property(nonatomic,assign) BOOL loginStatus;

/** 注册的用户名 */
@property(nonatomic,copy) NSString *registerUserName;
/** 注册的密码 */
@property(nonatomic,copy) NSString *registerPwd;
/** 字符串类型jid */
@property(nonatomic,copy) NSString *jid;

/** 加载沙盒的用户数据 */
- (void)loadUserInfoFromSanbox;

/** 保存用户数据到沙盒 */
- (void)saveUserInfoToSanbox;



@end
