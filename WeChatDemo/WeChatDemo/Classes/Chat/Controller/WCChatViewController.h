//
//  WCChatViewController.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface WCChatViewController : UIViewController

/** 好友的数据存储 */
@property(nonatomic,strong) XMPPUserCoreDataStorageObject *friendStorage;

@end
