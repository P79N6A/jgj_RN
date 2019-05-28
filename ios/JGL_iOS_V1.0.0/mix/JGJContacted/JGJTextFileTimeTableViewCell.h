//
//  JGJTextFileTimeTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol textFileEditedelegate <NSObject>
- (void)didendtextfiledfortext:(NSString *)text withTexttag:(NSInteger )tag;
@end
@interface JGJTextFileTimeTableViewCell : UITableViewCell
<
UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UIView *holdView;
@property (strong, nonatomic) IBOutlet UITextField *subTextFiled;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIImageView *leftLogo;
@property (assign, nonatomic) id <textFileEditedelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *downLable;
@property (nonatomic ,assign)  BOOL BigBool;
@property (strong, nonatomic) IBOutlet UIView *uplable;
@property (nonatomic ,assign)  NSString *textStr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstance;
@property (strong, nonatomic) IBOutlet UILabel *uniteLable;

@end
