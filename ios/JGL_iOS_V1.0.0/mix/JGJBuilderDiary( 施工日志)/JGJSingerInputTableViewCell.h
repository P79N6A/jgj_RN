//
//  JGJSingerInputTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTextField.h"

@protocol editeTextfiledBuilderDailytextinputDelegate <NSObject>
-(void)BuilderDailyTextfiledTextInputEndEidting:(NSString *)text andTag:(NSInteger)tag;

@end
@interface JGJSingerInputTableViewCell : UITableViewCell<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;

@property (strong, nonatomic) IBOutlet UILabel *topLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet LengthLimitTextField *textfiled;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;
@property (strong, nonatomic) id <editeTextfiledBuilderDailytextinputDelegate>delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentcenterConstance;

@end
