//
//  JGJTotalTimeView.h
//  mix
//
//  Created by Tony on 2017/4/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTotalTimeView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *totalWorkLable;
@property (strong, nonatomic) IBOutlet UILabel *totalOverable;
/*
 *
 *设置总的加班时长
 *
 */

-(void)setTotallableTextworkTime:(NSString *)workTime totalOvertime:(NSString *)overTime;
@end
