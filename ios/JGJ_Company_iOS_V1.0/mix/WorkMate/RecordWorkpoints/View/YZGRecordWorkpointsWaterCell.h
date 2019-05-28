//
//  YZGRecordWorkpointsWaterCell.h
//  mix
//
//  Created by celion on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZGRecordWorkpointsWaterModel.h"
#import "TYVerticalLabel.h"

@interface YZGRecordWorkpointsWaterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *todayFlagView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *date_turnLabel;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pro_nameLabel;
@property (weak, nonatomic) IBOutlet TYVerticalLabel *amounts_diffLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountsLabel;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *accounts_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overtimeLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectImageView_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *date_turnLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *date_turnLabel_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pro_nameLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amounts_diffLabel_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountsLabel_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accounts_typeLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overtimeLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator_leading;

@property (assign,nonatomic) BOOL isEditing;
//@property (assign,nonatomic) BOOL isSelected;
@property (strong,nonatomic) NSNumber *selectState;

@property (strong,nonatomic) WorkdayModel *model;

- (void)setCellData:(id)data atIndexPath:(NSIndexPath *)indexPath count:(NSUInteger)count isEditing:(BOOL)isEditing selectState:(NSNumber *)selectState;

@end
