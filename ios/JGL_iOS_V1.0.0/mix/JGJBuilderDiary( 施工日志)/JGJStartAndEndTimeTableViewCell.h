//
//  JGJStartAndEndTimeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickChoiceTimedelegate <NSObject>
-(void)clickChoiceStartTime;//选择开始时间过滤用
-(void)clickChoiceEndTime;//选择结束时间过滤用
-(void)clickChoiceStartTimeandTag:(NSInteger)tag isStartTime:(BOOL)StartTime;//发布日志用
-(void)clickChoiceEndTimeandTag:(NSInteger)tag isStartTime:(BOOL)StartTime;//发布日志用选择结束时间

-(void)clickChoiceStartTime:(NSString *)text;//选择开始时间完成
-(void)clickChoiceEndTime:(NSString *)text;//选择结束时间完成

@end
@interface JGJStartAndEndTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topTitleLable;
@property (strong, nonatomic) IBOutlet UILabel *startLable;

@property (strong, nonatomic) IBOutlet UILabel *endLable;
@property (strong, nonatomic) IBOutlet UILabel *startPlaceHolder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departLableHeight;
@property (strong, nonatomic) IBOutlet UILabel *endPlaceHolder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadendConstance;
@property (strong, nonatomic) IBOutlet UIView *startView;
@property (strong, nonatomic) IBOutlet UIView *endView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadStartConstance;
@property (strong, nonatomic) id <clickChoiceTimedelegate>delegate;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;
@property (nonatomic,strong) JGJFilterLogModel *filterModel;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;

@end
