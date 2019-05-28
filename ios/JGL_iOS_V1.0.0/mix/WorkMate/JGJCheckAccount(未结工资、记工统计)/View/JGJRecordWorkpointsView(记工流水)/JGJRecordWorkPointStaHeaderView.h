//
//  JGJRecordWorkPointStaHeaderView.h
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJRecordWorkPointStaHeaderView;

@protocol JGJRecordWorkPointStaHeaderViewDelegate <NSObject>

@optional

- (void)recordWorkPointStaHeaderView:(JGJRecordWorkPointStaHeaderView *)headerView;

@end

@interface JGJRecordWorkPointStaHeaderView : UIView

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

@property (weak, nonatomic) id <JGJRecordWorkPointStaHeaderViewDelegate> delegate;

//是否隐藏查看按钮
@property (assign, nonatomic) BOOL is_hidden_checkBtn;

@end
