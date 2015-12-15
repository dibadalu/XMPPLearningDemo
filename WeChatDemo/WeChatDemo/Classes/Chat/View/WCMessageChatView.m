//
//  WCMessageView.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCMessageChatView.h"
#import "WCMessageModelFrame.h"
#import "WCMessageModel.h"

@interface WCMessageChatView ()

/** 时间 */
@property (nonatomic,weak) UILabel *timeLabel;
/** 正文内容 */
@property (nonatomic,weak) UIButton *contentBtn;
/** 头像 */
@property (nonatomic,weak) UIImageView *headImage;

@end

@implementation WCMessageChatView

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加子控件
        [self setChirdView];
    }
    return self;

}

- (void)setChirdView{
    
    
    //1.时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLabel];
    self.timeLabel=timeLabel;
    
    
    //2.正文内容
    UIButton *contentBtn = [[UIButton alloc]init];
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    contentBtn.titleLabel.numberOfLines = 0;  //多行显示
    contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 20);
    [self addSubview:contentBtn];
    self.contentBtn=contentBtn;
    
    //3.头像
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    self.headImage = headImage;
    
    
}

/**
 *  接收来自外界的frame数据模型
 */
- (void)setMessageModelFrame:(WCMessageModelFrame *)messageModelFrame{
    
    _messageModelFrame = messageModelFrame;
    //取出数据模型
    WCMessageModel *messageModel = messageModelFrame.messageModel;
    
    //设置自己的frame
    self.frame = messageModelFrame.chatF;
    
    //根据frame数据模型给子控件设置frame，根据数据模型给子控件设置数据
    //1.时间的frame
    self.timeLabel.frame = messageModelFrame.timeF;
    self.timeLabel.text = messageModel.time;
    
    //2头像的frame
    if(messageModel.isCurrentUser){  //如果是自己
        
       
        UIImage *head = messageModel.headImage?[UIImage imageWithData:messageModel.headImage]:[UIImage imageNamed:@"DefaultProfileHead_qq"];
        self.headImage.image = head;
        
    }else{  //如果是聊天的用户
        self.headImage.image = messageModel.otherPhoto?messageModel.otherPhoto:[UIImage imageNamed:@"DefaultProfileHead"];
    }
    self.headImage.frame = messageModelFrame.headF;
    
    //3.内容的frame
    [self.contentBtn setTitle:messageModel.body forState:UIControlStateNormal];
    self.contentBtn.frame = messageModelFrame.contentF;
                                       
    //4.设置聊天的背景图片
    if(messageModel.isCurrentUser){  //如果是自己
        
        [self.contentBtn setBackgroundImage:[UIImage stretchedImageWithName:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
        
    }else {  //别人的
        
        [self.contentBtn setBackgroundImage:[UIImage stretchedImageWithName:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
    }

    
}




@end
