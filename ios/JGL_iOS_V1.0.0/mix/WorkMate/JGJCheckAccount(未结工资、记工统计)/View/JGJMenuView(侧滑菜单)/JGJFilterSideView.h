//
//  JGJFilterSideView.h
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJFilterSideView : UIView

@property (nonatomic, strong) NSMutableArray *containViews;

- (void)pushView;

- (void)addQueueWithSubView:(UIView *)subView;

// 单个视图
- (void)popView:(UIView *)view animation:(BOOL)animation;

// 移除所有视图
- (void)removeAllView;

@end
