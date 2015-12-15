//
//  WCMessageModelFrame.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCMessageModelFrame.h"
#import "WCMessageModel.h"


#define WCScreenWidth ([UIScreen mainScreen].bounds.size.width) //屏幕宽度
#define WCHeadIconW 40 //头像宽度
#define WCContentFont [UIFont systemFontOfSize:15] //内容字体
#define WCContentEdgeInsets 20 //聊天内容的文字距离四边的距离

@implementation WCMessageModelFrame

/**
 *  接收来自外界的数据模型，并且设置所有子控件的frame
 */
- (void)setMessageModel:(WCMessageModel *)messageModel{

 
    _messageModel = messageModel;
    CGFloat padding = 10;  //间距为10
    
    //1.设置时间的frame (不需要隐藏时间)
    if(messageModel.hiddenTime==NO){
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = WCScreenWidth;
        CGFloat timeH = 30;
        _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    //2.设置头像
    CGFloat iconW = WCHeadIconW;
    CGFloat iconH = iconW;
    CGFloat iconX = 0;
    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
    //如果是自己
    if(messageModel.isCurrentUser){
        
        iconX = WCScreenWidth - iconW - padding;
        
    }else{  //是正在和自己聊天的用户
        
        iconX = padding;
    }
    _headF = CGRectMake(iconX, iconY, iconW, iconH);
    
    //3.设置聊天内容的frame  (聊天内容的宽度最大100  高不限)
    CGSize contentSize = CGSizeMake(200, MAXFLOAT);
    CGRect contentR = [messageModel.body boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WCContentFont} context:nil];
    CGFloat contentW = contentR.size.width + WCContentEdgeInsets * 2;
    CGFloat contentH = contentR.size.height + WCContentEdgeInsets * 2;
    CGFloat contentY = iconY - 2;
    CGFloat contentX = 0;
    //如果是自己
    if(messageModel.isCurrentUser){
        contentX = iconX - padding - contentW;
    }else{  //如果是聊天用户
        contentX = CGRectGetMaxX(_headF) + padding;
    }
    _contentF = CGRectMake(contentX, contentY, contentW, contentH);
    
    //单元格的高度
    CGFloat maxIconY = CGRectGetMaxY(_headF);
    CGFloat maxContentY = CGRectGetMaxY(_contentF);
    _cellHeight = MAX(maxIconY, maxContentY) + 20;
    
    //4.聊天单元view的frame
    _chatF = CGRectMake(0, 0, WCScreenWidth, _cellHeight );
    
}



@end
