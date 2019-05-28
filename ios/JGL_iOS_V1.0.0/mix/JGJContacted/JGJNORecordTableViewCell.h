//
//  JGJNORecordTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJNORecordTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workTime;
@property (strong, nonatomic) IBOutlet UILabel *overTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *workTimeLable;
@property (nonatomic ,strong) JgjRecordMorePeoplelistModel *modelList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *distance;
@property (nonatomic ,strong) JGJMoneyListModel *moneyModel;
@property (nonatomic ,strong) NSString *is_salary;
@property (nonatomic ,strong) NSArray *dataArr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deparLable;
@property (strong, nonatomic) IBOutlet UIView *newdepartlable;

@end
