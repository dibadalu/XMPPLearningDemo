//
//  WCInputView.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView

+ (instancetype)inputView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}



@end
