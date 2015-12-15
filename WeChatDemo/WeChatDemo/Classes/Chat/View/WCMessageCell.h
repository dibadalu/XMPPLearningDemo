//
//  WCMessageCell.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/15.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCMessageModelFrame;

@interface WCMessageCell : UITableViewCell

/** frame数据模型 */
@property(nonatomic,strong) WCMessageModelFrame *messageModelFrame;

/** 工厂方法（类方法） */
+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
