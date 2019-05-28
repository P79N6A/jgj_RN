//
//  JGJFSCalendarTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
@interface JGJFSCalendarTableViewCell : UITableViewCell
<
FSCalendarDataSource,
FSCalendarDelegate,
FSCalendarHeaderDelegate

>
@property (strong, nonatomic) IBOutlet FSCalendar *DayCalendar;

@end
