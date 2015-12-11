//
//  WCMessage.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/11.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCMessageModel : NSObject

/** 消息内容 */
@property (nonatomic, strong) NSString * body;


/** 带属性的消息内容 */
@property (nonatomic, copy) NSAttributedString *attributedBody;
/** 消息的时间 */
@property (nonatomic,copy) NSString *time ;
/** 如果是YES就是当前用户  如果是NO就是聊天的用户 */
@property (nonatomic,assign) BOOL isCurrentUser;
/** 谁发的消息 */
@property (nonatomic,copy) NSString *from;
/** 发给谁的消息 */
@property (nonatomic,copy) NSString *to ;
/** 聊天用户的头像 */
@property (nonatomic,weak) UIImage *otherPhoto;
/** 用户自己的头像 */
@property (nonatomic,strong) NSData *headImage;
/** 是否隐藏时间 */
@property (nonatomic,assign) BOOL hiddenTime;

@end
