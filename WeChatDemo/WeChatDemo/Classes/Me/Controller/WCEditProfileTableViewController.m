//
//  WCEditProfileTableViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/7.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCEditProfileTableViewController.h"
#import "XMPPvCardTemp.h"

@interface WCEditProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题和TextField的默认值
    self.title = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;
    
    //添加导航栏上的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    
    
}

- (void)saveBtnClick{
    
    WCLog(@"点击了保存按钮");
    
    //1.更改cell的detailTextLabel的text
    self.cell.detailTextLabel.text = self.textField.text;
    
    //刷新
    [self.cell layoutSubviews];
    
    //2.当前的控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //3.通知代理
    if ([self.delegate respondsToSelector:@selector(editProfileTableViewControllerDidSave)]) {
        [self.delegate editProfileTableViewControllerDidSave];
    }
}


@end
