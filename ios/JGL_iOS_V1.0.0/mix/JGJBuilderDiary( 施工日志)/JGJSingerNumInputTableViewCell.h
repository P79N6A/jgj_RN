//
//  JGJSingerNumInputTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeTextfiledBuilderDailyNuminputDelegate <NSObject>
-(void)BuilderDailyTextfiledNumInputEndEidting:(NSString *)text andTag:(NSInteger)tag;

@end
@interface JGJSingerNumInputTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;
@property (strong, nonatomic) IBOutlet UILabel *topLable;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UITextField *textfiled;
@property (strong, nonatomic) IBOutlet UILabel *uniteLable;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;
@property (strong, nonatomic) id <editeTextfiledBuilderDailyNuminputDelegate>delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *certerconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentCenterconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagcenterconstance;

@end
