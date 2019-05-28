//
//  JGJCheckStaFooterView.h
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJCheckStaFooterView;

@protocol JGJCheckStaFooterViewDelegate <NSObject>

@optional

- (void)checkStaFooterView:(JGJCheckStaFooterView *)footerView;

@end

@interface JGJCheckStaFooterView : UIView

@property (weak, nonatomic) id <JGJCheckStaFooterViewDelegate> delegate;

//是否隐藏查看按钮
@property (assign, nonatomic) BOOL is_hidden_checkBtn;

@end
