//
//  WCEditProfileTableViewController.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileTableViewControllerDelegate <NSObject>

@optional
- (void)editProfileTableViewControllerDidSave;

@end

@interface WCEditProfileTableViewController : UITableViewController

@property(nonatomic,strong) UITableViewCell *cell;

@property(nonatomic,weak) id<WCEditProfileTableViewControllerDelegate> delegate;


@end
