//
//  WCMessageModelFrame.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  frame数据模型：存放数据模型 + 所有子控件的frame + cell的高度

#import <Foundation/Foundation.h>
@class WCMessageModel;

@interface WCMessageModelFrame : NSObject

/** 数据模型 */
@property(nonatomic,strong) WCMessageModel *messageModel;

/** 所有子控件的frame */
/** 时间的frame */
@property (nonatomic,assign,readonly) CGRect timeF;
/** 头像的frame */
@property (nonatomic,assign,readonly) CGRect headF;
/** 内容的frame */
@property (nonatomic,assign,readonly) CGRect contentF;
/** 聊天单元的frame */
@property (nonatomic,assign,readonly) CGRect  chatF;

/** cell的高度 */
@property(nonatomic,assign,readonly) CGFloat cellHeight;



@end
