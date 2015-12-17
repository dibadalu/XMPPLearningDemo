//
//  WCChatViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "WCMessageModel.h"
#import "WCMessageModelFrame.h"
#import "WCMessageCell.h"
#import "XMPPvCardTemp.h"


@interface WCChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    NSFetchedResultsController *_resultsController;
    
}

@property(nonatomic,strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
@property(nonatomic,strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束

@property(nonatomic,strong) UITableView *tableView;//表格;

@property(nonatomic,strong) HttpTool *httpTool;//http工具类

/** 消息frame模型数组：每一个frame模型存放一条消息 */
@property(nonatomic,strong) NSMutableArray *msgModelFrames;


@end

@implementation WCChatViewController
#pragma mark - 懒方法
- (HttpTool *)httpTool{

    if (!_httpTool) {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
    
}

- (NSMutableArray *)msgModelFrames{
    if (!_msgModelFrames) {
        _msgModelFrames = [NSMutableArray array];
    }
    return _msgModelFrames;
}

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化聊天界面
    [self setupView];
    
    //加载聊天消息数据
    [self loadMsg];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 初始化聊天界面
/**
 * 代码方式实现自动布局 VFL
 */
- (void)setupView{
    //代码方式实现自动布局 VFL
    //创建一个tableView
    UITableView *tableView = [[UITableView alloc] init];
    //    tableView.backgroundColor = [UIColor redColor];
    tableView.allowsSelection = NO;//cell不可选中
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
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
    //监听add按钮
    [inputView.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    //    WCLog(@"%@",vContraints);
    //添加inputView高度约束
    self.inputViewHeightConstraint = vContraints[2];
    //添加inputView底部约束
    self.inputViewBottomConstraint = [vContraints lastObject];
    
    
}

#pragma mark - 加载聊天消息数据
/**
 *  XMPPMessageArchiving数据库
 */
- (void)loadMsg{
    
    //从CoreData数据库获取数据
    //上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤和排序
    //当前登录用户的JID
    //当前聊天好友的JID
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid,self.friendJid.bare];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid,self.friendStorage.jid.bare];
    //    WCLog(@"%@",pre);
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
    if (_resultsController.fetchedObjects.count) {//有聊天数据
        
        //1.消息转模型
        [self dataToModel];
        
        //2.滚动到底部
        [self scrollToTableBottom];
    }
    
}

#pragma mark - 消息转模型
- (void)dataToModel{
    
    //获取聊天消息数组
    NSArray *msgs = _resultsController.fetchedObjects;
    //遍历聊天消息数组，将消息转换成模型
    for (XMPPMessageArchiving_Message_CoreDataObject *msg in msgs) {
        WCMessageModel *msgModel = [[WCMessageModel alloc] init];
        msgModel.body = msg.body;
        msgModel.time = [self timeStrWithTimeDate:msg.timestamp];
        msgModel.to = msg.bareJidStr;
        msgModel.otherPhoto = self.friendStorage.photo;//聊天用户的头像
        msgModel.headImage = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp.photo;//登录用户的头像
        msgModel.hiddenTime = NO; //隐藏时间
        msgModel.isCurrentUser = [msg.outgoing boolValue];//标记是否当前用户发送的
        
        WCMessageModelFrame *modelFrame = [[WCMessageModelFrame alloc] init];
        modelFrame.messageModel = msgModel;
        //将消息模型放进消息模型数组
        [self.msgModelFrames addObject:modelFrame];
    }
    
}

/**
 *  设置日期格式，并返回time字符串
 */
- (NSString *)timeStrWithTimeDate:(NSDate *)date{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //如果是真机调试，转换欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设置日期格式（声明字符串里面每个数字和单词的含义）
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [fmt stringFromDate:date];
    
    return timeStr;
}

#pragma mark - 键盘的触发事件
/**
 *  即将显示键盘
 */
- (void)keyboardWillShow:(NSNotification *)noti{
    
//    NSLog(@"%@",noti.userInfo);
    //获取键盘的高度
    CGRect kyEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kyHeight = kyEndFrm.size.height;

#warning iOS7以下，当屏幕是横屏时，键盘的高度是size.width
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kyHeight = kyEndFrm.size.width;
    }
    self.inputViewBottomConstraint.constant = kyHeight;
    
}
/**
 *  即将隐藏键盘
 */
- (void)keyboardWillHide:(NSNotification *)noti{
    //隐藏键盘的时候，距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}


/**
 *  选中“+”号按钮，触发监听事件
 */
- (void)addBtnClick{
    
    //打开图库
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 系统图库方法
/**
 *  选择完图片调用
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    WCLog(@"%@",info);
    //    UIImagePickerControllerOriginalImage
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //把图片发送到文件服务器
    /*
     *put
     *1.put实现文件上传没post繁琐，而且比post快
     *2.put的文件上传路径就是下载路径
     *  http://localhost:8080/imfileserver/Upload/Image/图片名
     */
    //1.取文件名 用户名 + 时间20151210
    NSString *userName = [WCUserInfo sharedWCUserInfo].userName;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [dateformatter stringFromDate:[NSDate date]];
    NSString *fileName = [userName stringByAppendingString:timeStr];
    
    //2.拼接上传路径
    NSString *uploadUrl = [@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:fileName];
    
    //3.使用HTTP put上传到文件服务器
#warning 图片上传使用jpg格式，因为该文件服务器只接受jpg格式
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
        if (!error) {
            WCLog(@"上传成功");
            //图片发送成功，把图片的URL传openfire的服务器
            [self sendMsgWithText:uploadUrl bodyType:@"image"];
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITextViewDelegate代理方法
- (void)textViewDidChange:(UITextView *)textView{
    
    //    WCLog(@"%@",textView.text);
    //获取contentSize
    CGSize size = textView.contentSize;
    CGFloat contentH = size.height;
    //    WCLog(@"textView的contentSize的高度%f",contentH);
    
    //粗略判断，设置inputView的高度最大为3行
    if (contentH > 33 && contentH < 67) {//大于33，超过1行的高度,小于67，高度在3行内
        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    //换行就等于点击了send
    if ([text rangeOfString:@"\n"].length != 0) {
        WCLog(@"发送数据：%@",text);
        
        //去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self sendMsgWithText:text bodyType:@"text"];
        //清空textView
        textView.text = nil;
        
        //发送完消息，inputView高度变回50
        self.inputViewHeightConstraint.constant = 50;
        
    }else{
        WCLog(@"输入数据：%@",textView.text);
        
    }
    
}

/**
 *  发送聊天消息
 *
 *  @param text     内容
 *  @param bodyType 内容类型（text、image）
 */
- (void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType{
    
    //创建消息对象，并指定好友jid
//    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendStorage.jid];
    //设置内容类型
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    //设置内容
    [msg addBody:text];
    //    WCLog(@"%@",msg);
    //发送聊天消息
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];
    
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return _resultsController.fetchedObjects.count;
    return self.msgModelFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    WCMessageCell *cell = [WCMessageCell messageCellWithTableView:tableView];
    WCMessageModelFrame *msgModelFrame = self.msgModelFrames[indexPath.row];//取出frame数据模型
    //传递给cell
    cell.messageModelFrame = msgModelFrame;
    
    return cell;
    
}



#pragma mark - tableView代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WCMessageModelFrame *msgModelFrame = self.msgModelFrames[indexPath.row];
    return msgModelFrame.cellHeight;
    
}

#pragma mark - NSFetchedResultsControllerDelegate代理方法
/**
 *  当数据库的内容发生改变，会调用这个方法
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    WCLog(@"数据库的内容发生改变");
    
    XMPPMessageArchiving_Message_CoreDataObject *msg = [_resultsController.fetchedObjects lastObject];
    //将消息转换成模型
    [self dataToModelWith:msg];
        
}

#pragma mark - 将消息转换成模型
- (void)dataToModelWith:(XMPPMessageArchiving_Message_CoreDataObject *)msg{
    
    
    if (msg.body.length > 0) {//有内容
        //将消息转换成模型，并存进消息模型数组
        WCMessageModel *msgModel = [[WCMessageModel alloc] init];
        msgModel.body = msg.body;
//        msgModel.time = [NSString stringWithFormat:@"%@",msg.timestamp];
        msgModel.time = [self timeStrWithTimeDate:msg.timestamp];

        msgModel.to = msg.bareJidStr;
        msgModel.otherPhoto = self.friendStorage.photo;//聊天用户的头像
        msgModel.headImage = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp.photo;//登录用户的头像
        msgModel.hiddenTime = NO; //隐藏时间
        msgModel.isCurrentUser = [msg.outgoing boolValue];//标记是否当前用户发送的
        
        WCMessageModelFrame *modelFrame = [[WCMessageModelFrame alloc] init];
        modelFrame.messageModel = msgModel;
        //将消息模型放进消息模型数组
        [self.msgModelFrames addObject:modelFrame];

        
        //刷新表格
        [self.tableView reloadData];
        
        //滚动到底部
        [self scrollToTableBottom];
        
    }
    
}

/**
 *  滚动到底部
 */
- (void)scrollToTableBottom{
    
    NSInteger lastRow = _resultsController.fetchedObjects.count - 1;
    if (lastRow < 0) {//如果行数小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end


//获取聊天消息对象
//    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultsController.fetchedObjects[indexPath.row];
//    //显示消息
//    if ([msg.outgoing boolValue]) {//YES 自己发的
//        NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
//        //判断是图片还是纯文本
//        if ([chatType isEqualToString:@"image"]) {
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead_qq"]];
//        }else if ([chatType isEqualToString:@"text"]){
//            cell.textLabel.text = [NSString stringWithFormat:@"Me: %@",msg.body];
//        }
//    }else{//NO 别人发的
//        cell.textLabel.text = [NSString stringWithFormat:@"Other: %@",msg.body];
//#warning 注意清空image ,另外spark客户端无法演示发送图片
//        cell.imageView.image = nil;
//    }

