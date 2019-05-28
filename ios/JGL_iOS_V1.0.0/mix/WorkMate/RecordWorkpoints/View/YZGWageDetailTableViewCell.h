//
//  YZGWageDetailTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWageDetailModel.h"
#import "YZGWageBestDetailModel.h"

@class WageMoreDetailList;
@interface YZGWageDetailTableViewCell : UITableViewCell
@property (nonatomic,assign) BOOL isLastCell;

@property  (nonatomic,assign) WageDetailFilterType wageDetailFilterType;//记录是人还是项目

@property (nonatomic,strong) WageDetailList *wageDetailList;//这个model是在"工资清单"界面可以用的
@property (nonatomic,strong) WageMoreDetailList *wageMoreDetailList;//这个model是在"项目相关","具体收入",界面可以用的


- (void)setLeftText:(NSString *)leftText;

- (void)setMiddleText:(NSString *)middleText;

- (void)setRightText:(NSString *)rightText;

- (void)setLeftText:(NSString *)leftText middleText:(NSString *)middleText rightText:(NSString *)rightText;

-(void)setLeftLabelLayoutLConstraint:(CGFloat )constraint;

-(void)setRighttLabelLayoutRConstraint:(CGFloat )constraint;

-(void)setMiddleLabelLayoutCenterXConstraint:(CGFloat )constraint;

- (void)setLeftConstraint:(CGFloat )leftConstraint middleConstraint:(CGFloat )middleConstraint rightConstraint:(CGFloat )rightConstraint;
@end
