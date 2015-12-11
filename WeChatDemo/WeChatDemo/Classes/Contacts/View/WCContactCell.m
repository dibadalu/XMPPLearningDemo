//
//  WCContactCell.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/11.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCContactCell.h"


@interface WCContactCell ()



@end

@implementation WCContactCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ContactCell";
    WCContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
