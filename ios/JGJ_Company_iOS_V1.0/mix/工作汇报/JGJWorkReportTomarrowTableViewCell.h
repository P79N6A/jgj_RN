//
//  JGJWorkReportTomarrowTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tomorrowWorkPlandelegate <NSObject>
-(void)endeditingtomorrowWorkPlan:(NSString *)text;
@end
@interface JGJWorkReportTomarrowTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) id <tomorrowWorkPlandelegate>delegate;
@end
