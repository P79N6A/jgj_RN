//
//  YZGWageBestDetailTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWageBestDetailModel.h"
#import "JGJPersonDetailWageListModel.h"

@interface YZGWageBestDetailTableViewCell : UITableViewCell
@property (nonatomic,assign) BOOL isLastCell;
@property (nonatomic,strong) WageBestDetailWorkday *wageBestDetailWorkday;
@property (nonatomic ,strong)JGJeRecordBillDetailArrModel *recordBillDetailArrmodel;
//@property (nonatomic,strong) PersonDetailWageListWorkday *personDetailWageListWorkday;
@property (nonatomic,strong) JGJeRecordFourBillDetailArrModel *personDetailWageListWorkday;

@property (nonatomic,assign) CGFloat dateLabelLeft;
@property (strong, nonatomic) IBOutlet UILabel *lineDepart;
@property (nonatomic,strong) UIImageView *roleLable;
@property (strong, nonatomic) IBOutlet UILabel *pronameLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet UILabel *turnDateLable;
@property (strong, nonatomic) IBOutlet UIView *upBaseView;
@property (strong, nonatomic) IBOutlet UILabel *updepartLable;
@property (strong, nonatomic) IBOutlet UIView *downBaseLable;
@property (strong, nonatomic) IBOutlet UILabel *downDepartLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextImageHeightConstance;

@end
