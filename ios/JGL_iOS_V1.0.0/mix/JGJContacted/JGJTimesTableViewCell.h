//
//  JGJTimesTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTimesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *placeHoldView;//底层背景
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLable;
@property (strong, nonatomic) IBOutlet UIImageView *leftLogo;
@property (nonatomic ,assign)  BOOL BigBool;
@property (nonatomic ,strong)  NSString *timeStr;
@property (strong, nonatomic) IBOutlet UILabel *upDepartlable;
@property (strong, nonatomic) IBOutlet UILabel *bottomLable;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;

@end
