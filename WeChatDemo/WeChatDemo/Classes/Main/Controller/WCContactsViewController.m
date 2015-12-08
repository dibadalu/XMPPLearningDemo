//
//  WCContactsViewController.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCContactsViewController.h"

@interface WCContactsViewController ()<NSFetchedResultsControllerDelegate>{
    
    NSFetchedResultsController *_resultsController;//可以监听数据库的改变
}

@property(nonatomic,strong) NSArray *friends;

@end

@implementation WCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库里加载好友列表显示
    [self loadFriends2];
   
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

- (void)loadFriends2{
    
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
//    self.friends = [context executeFetchRequest:request error:nil];
//    WCLog(@"%@",self.friends);
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;//设置代理
    NSError *error = nil;
    [_resultsController performFetch:&error];
    if (error) {
        WCLog(@"%@",error);
    }
    
}

#pragma mark - NSFetchedResultsControllerDelegate 
#pragma mark - 当数据库的内容发生改变，会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    WCLog(@"数据库的内容发生改变");
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - tableView 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.friends.count;
    return _resultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    //sectionNum
    // 0 - 在线
    // 1 - 离开
    // 2 - 离线
    
    //获取对应的好友
//    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
    }
    cell.textLabel.text = friend.jidStr;

    
    return cell;
}


@end
