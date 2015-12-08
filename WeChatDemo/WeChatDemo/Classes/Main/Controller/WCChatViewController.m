//
//  WCChatViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate>{
    
    NSFetchedResultsController *_resultsController;//监听消息
    
}

@property(nonatomic,strong) NSLayoutConstraint *inputViewConstraint;//inputView底部约束
@property(nonatomic,strong) UITableView *tableView;//表格;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化聊天界面
    [self setupView];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //加载聊天消息数据
    [self loadMsg];
}

#pragma mark - 监听键盘
#pragma mark - 显示键盘
- (void)keyboardWillShow:(NSNotification *)noti{
//    NSLog(@"%@",noti.userInfo);
    //获取键盘的高度
    CGRect kyEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kyHeight = kyEndFrm.size.height;

#warning iOS7以下，当屏幕是横屏时，键盘的高度是size.width
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kyHeight = kyEndFrm.size.width;
    }
    self.inputViewConstraint.constant = kyHeight;
    
    //表格滚动到底部
//    [self scrollToTableBottom];
    
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
//    tableView.backgroundColor = [UIColor redColor];
    tableView.delegate = self;
    tableView.dataSource = self;
#warning 代码实现自动布局，要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建输入框view
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置代理
    inputView.textView.delegate = self;
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

#pragma mark - 加载XMPPMessageArchiving数据库的数据显示在表格
- (void)loadMsg{
    
    //上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤和排序
    //当前登录用户的JID
    //当前聊天好友的JID
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid,self.friendJid.bare];
    WCLog(@"%@",pre);
    request.predicate = pre;
    
    //时间的升序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //查询
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;//设置代理
    NSError *error = nil;
    [_resultsController performFetch:&error];
    if (error) {
        WCLog(@"%@",error);
    }
        
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _resultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultsController.fetchedObjects[indexPath.row];
    
    //显示消息
    if ([msg.outgoing boolValue]) {//YES 自己发的
        cell.textLabel.text = [NSString stringWithFormat:@"Me: %@",msg.body];

    }else{//NO 别人发的
       cell.textLabel.text = [NSString stringWithFormat:@"Other: %@",msg.body];
    }
    
    return cell;
}

#pragma mark - tableView代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate 监听消息
#pragma mark - 当数据库的内容发生改变，会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    WCLog(@"数据库的内容发生改变");
    
    //刷新数据
    [self.tableView reloadData];
    //滚动到底部
    [self scrollToTableBottom];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    WCLog(@"%@",textView.text);
    
    NSString *text = textView.text;
    //换行就等于点击了send
    if ([text rangeOfString:@"\n"].length != 0) {
        WCLog(@"发送数据：%@",text);
        [self sendMsgWithText:text];
        //清空textView
        textView.text = nil;
        
    }else{
        WCLog(@"%@",textView.text);

    }
}

#pragma mark - 发送聊天消息
- (void)sendMsgWithText:(NSString *)text{
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    //设置内容
    [msg addBody:text];
    WCLog(@"%@",msg);
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];
    
}

#pragma mark - 滚动到底部
- (void)scrollToTableBottom{
    NSInteger lastRow = _resultsController.fetchedObjects.count - 1;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
