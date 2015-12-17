//
//  WCMessageCell.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCMessageCell.h"
#import "WCMessageChatView.h"

@interface WCMessageCell ()

/** 聊天消息界面 */
@property(nonatomic,weak) WCMessageChatView *chatView;

@end

@implementation WCMessageCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ChatCell";
    WCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WCMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
    
}

#pragma mark - 添加所有可能显示的子控件，并设置一次性属性
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor yellowColor];
        //添加子控件
        [self setChirdView];
        
    }
    return self;
    
}

/**
 *  添加子控件
 */
- (void)setChirdView{
    
    WCMessageChatView  *chatView = [[WCMessageChatView alloc] init];
    [self.contentView addSubview:chatView];
    self.chatView = chatView;
    
}

/**
 *  接收来自外界的frame数据模型
 */
- (void)setMessageModelFrame:(WCMessageModelFrame *)messageModelFrame{

    //将frame数据模型传递给子控件
    self.chatView.messageModelFrame = messageModelFrame;

}


@end
