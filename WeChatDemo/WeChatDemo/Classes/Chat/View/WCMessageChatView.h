//
//  WCMessageView.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  聊天界面

#import <UIKit/UIKit.h>
@class WCMessageModelFrame;

@interface WCMessageChatView : UIView

/** frame数据模型 */
@property(nonatomic,strong) WCMessageModelFrame *messageModelFrame;


@end
