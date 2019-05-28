//
//  JGJWorkReprotTextFiledTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol todayReportDelegate <NSObject>
-(void)endEditingTodaycompleteWork:(NSString *)text;
@end
@interface JGJWorkReprotTextFiledTableViewCell : UITableViewCell
<
UITextViewDelegate
>

@property (strong, nonatomic) IBOutlet UILabel *titleLbale;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UITextView *placeLable;
@property (strong, nonatomic) id<todayReportDelegate>delegate;
@end
