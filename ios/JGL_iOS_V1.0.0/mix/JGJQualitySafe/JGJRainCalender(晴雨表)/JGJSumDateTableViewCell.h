//
//  JGJSumDateTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeRainCalenderdelegate <NSObject>

-(void)clickEditeRainCalenderButton;
@end

@interface JGJSumDateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *editeButton;
@property (strong, nonatomic)id <editeRainCalenderdelegate>delegate;
@property (nonatomic ,strong)JGJRainCalenderDetailModel *model;
@property (strong, nonatomic) IBOutlet UIButton *bigEditeButton;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (nonatomic ,strong)JGJMyWorkCircleProListModel *Workmodel;

-(void)setTime:(NSString *)time;
@end
