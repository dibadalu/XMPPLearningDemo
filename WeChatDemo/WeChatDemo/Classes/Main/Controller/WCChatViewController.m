//
//  WCChatViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDelegate>

@property(nonatomic,strong) NSLayoutConstraint *inputViewConstraint;//inputView底部约束

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化聊天界面
    [self setupView];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听键盘
#pragma mark - 显示键盘
- (void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    //获取键盘的高度
    CGRect kyEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kyHeight = kyEndFrm.size.height;

#warning iOS7以下，当屏幕是横屏时，键盘的高度是size.width
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kyHeight = kyEndFrm.size.width;
    }
    self.inputViewConstraint.constant = kyHeight;
    
}
#pragma mark - 隐藏键盘
- (void)keyboardWillHide:(NSNotification *)noti{
    //隐藏键盘的时候，距离底部的约束永远为0
    self.inputViewConstraint.constant = 0;
}

//-(void)kbFrmWillChange:(NSNotification *)noti{
//    //    NSLog(@"%@",noti.userInfo);
//    
//    // 获取窗口的高度
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    // 键盘结束的Frame
//    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    // 获取键盘结束的y值
//    CGFloat kbEndY = kbEndFrm.origin.y;
//    //inputView底部约束
//    self.inputViewConstraint.constant = windowH - kbEndY;
//}

#pragma mark - 代码方式实现自动布局 VFL
- (void)setupView{
    //代码方式实现自动布局 VFL
    //创建一个tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor redColor];
    tableView.delegate = self;
#warning 代码实现自动布局，要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    
    //创建输入框view
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:inputView];
    
    
    //自动布局
    NSDictionary *views = @{@"tableView":tableView,
                            @"inputView":inputView};
    //水平方向的约束
    //1.tableview水平方向的约束
    NSArray *tableViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHContraints];
    
    //2.inputView水平方向的约束
    NSArray *inputViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHContraints];
    
    //垂直方向的约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vContraints];
    self.inputViewConstraint = [vContraints lastObject];
//    WCLog(@"%@",vContraints);
    
}

#pragma mark - tableView代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}



@end
