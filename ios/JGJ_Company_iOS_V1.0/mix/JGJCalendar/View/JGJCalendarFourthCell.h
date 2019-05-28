//
//  JGJCalendarFourthCell.h
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TodayRecomBlcok)(JGJTodayRecomModel *todatRecomModel);
@interface JGJCalendarFourthCell : UITableViewCell
@property (strong, nonatomic) NSArray *todayRecoms;//今日推荐模型数组
@property (copy, nonatomic) TodayRecomBlcok todayRecomBlcok;
@end
