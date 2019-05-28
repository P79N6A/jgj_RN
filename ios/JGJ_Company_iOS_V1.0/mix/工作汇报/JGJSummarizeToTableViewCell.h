//
//  JGJSummarizeToTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol thisWeekWorkSummarydelegate <NSObject>
-(void)endeditingthisWeekWorkSummary:(NSString *)text;
@end
@interface JGJSummarizeToTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) id <thisWeekWorkSummarydelegate>delegate;
@end
