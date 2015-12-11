//
//  WCContactCell.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/11.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCContactCell : UITableViewCell


/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
/////** 好友名称 */
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
/** 状态：在线\离线\离开 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
