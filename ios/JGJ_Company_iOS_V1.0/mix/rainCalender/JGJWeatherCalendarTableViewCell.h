//
//  JGJWeatherCalendarTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickHeaderbutton <NSObject>

- (void)didselectedcalendarButtonandTag:(NSInteger)tag andText:(NSString *)timeStr;
- (void)didselectedtimelableandLabletext:(NSString *)str;

@end
@interface JGJWeatherCalendarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timelable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *leftCalendarButton;
@property (strong, nonatomic) id<clickHeaderbutton> delegate;

@end
