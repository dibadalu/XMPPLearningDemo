//
//  WCContactsViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCContactsViewController.h"

@interface WCContactsViewController ()

@property(nonatomic,strong) NSArray *friends;

@end

@implementation WCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库里加载好友列表显示
    [self loadFriends];
   
}

#pragma mark - 从数据库里加载好友列表显示
- (void)loadFriends{
    
    //如何使用CoreData获取数据
    //1.上下文[关联到数据XMPPRoster.sqlite]
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.FetchRequest[查哪张表]
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤和排序
    //过滤当前登录用户的好友
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //4.执行请求获取数据
    self.friends = [context executeFetchRequest:request error:nil];
    WCLog(@"%@",self.friends);
    
    
}

#pragma mark - tableView 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取对应的好友
    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    cell.textLabel.text = friend.jidStr;
    
    
    return cell;
}


@end
