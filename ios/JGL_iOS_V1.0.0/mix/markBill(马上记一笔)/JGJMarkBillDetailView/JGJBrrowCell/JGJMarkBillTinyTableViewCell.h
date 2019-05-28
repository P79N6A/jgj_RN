//
//  JGJMarkBillTinyTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMarkBillTinyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstance;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightArrowConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLineConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLineConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@end
