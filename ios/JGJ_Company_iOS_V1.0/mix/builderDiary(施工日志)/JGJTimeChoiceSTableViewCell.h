//
//  JGJTimeChoiceSTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTimeChoiceSTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;
@property (strong, nonatomic) IBOutlet UILabel *topLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;
@property (strong, nonatomic) IBOutlet UIView *titleDepart;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleConstance;
@property (strong, nonatomic) IBOutlet UILabel *bottomLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleCenterconstance;

@end
