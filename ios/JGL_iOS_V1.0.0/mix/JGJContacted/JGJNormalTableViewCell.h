//
//  JGJNormalTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWTableViewCell.h"
@interface JGJNormalTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *Namelable;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workTimeWidth;
@property (strong, nonatomic) IBOutlet UILabel *workTimelable;
@property (strong, nonatomic) IBOutlet UILabel *overTimeLable;
@property (nonatomic ,strong)JGJMoneyListModel *moneyModel;
@property (nonatomic ,strong)JgjRecordMorePeoplelistModel *listModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstance;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeCenterY;


@end
