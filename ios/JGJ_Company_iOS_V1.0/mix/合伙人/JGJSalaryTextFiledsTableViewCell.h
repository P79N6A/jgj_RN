//
//  JGJSalaryTextFiledsTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol salaryEditeDelegate <NSObject>
-(void)salaryEditeText:(NSString *)text;
@end
@interface JGJSalaryTextFiledsTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *salaryTextfiled;
@property (strong, nonatomic) id <salaryEditeDelegate>delegate;
@property (strong, nonatomic) JGJAccountListModel *model;

@end
