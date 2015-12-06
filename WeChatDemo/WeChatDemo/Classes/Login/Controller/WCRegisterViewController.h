//
//  WCRegisterViewController.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCRegisterViewControllerDelegate <NSObject>

@optional
/** 完成注册 */
- (void)registerViewControllerDidFinishRegister;

@end

@interface WCRegisterViewController : UIViewController

/** 代理属性 */
@property(nonatomic,weak) id<WCRegisterViewControllerDelegate> delegate;

@end
