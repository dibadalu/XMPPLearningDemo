//
//  WCInputView.h
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView


@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)inputView;

@end
