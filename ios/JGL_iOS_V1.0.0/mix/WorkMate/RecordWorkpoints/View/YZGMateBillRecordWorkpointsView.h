//
//  YZGMateBillRecordWorkpointsView.h
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGRecordWorkModel.h"

@class YZGMateBillRecordWorkpointsView;
@protocol YZGMateBillRecordWorkpointsViewDelegate <NSObject>
/**
 *  点击跳转的Delegate
 *
 *  @param yzgMateBillRecordView
 *  @param index                 0:表示点击了第一个,1表示点击了第二个,2标识点击了第三个
 */
- (void )YZGMateBillRecordWorkBtnClick:(YZGMateBillRecordWorkpointsView *)yzgMateBillRecordView index:(NSInteger )index;
@end

@interface YZGMateBillRecordWorkpointsView : UIView
@property (nonatomic , weak) id<YZGMateBillRecordWorkpointsViewDelegate> delegate;

@property (nonatomic,strong) YZGRecordWorkModel *firstRecordWorkModel;//第一个模型
@property (nonatomic,strong) YZGRecordWorkModel *secondRecordWorkModel;//第二个模型

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *departfirstlable;
@property (strong, nonatomic) IBOutlet UILabel *departsecondLable;

- (void)setupView;
- (void)setLabels;
- (void)handleSingleTap:(id)sender;

@end
