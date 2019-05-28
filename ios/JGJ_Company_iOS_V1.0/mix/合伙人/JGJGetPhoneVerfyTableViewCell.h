//
//  JGJGetPhoneVerfyTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol getPhoneCodeDelegate <NSObject>
-(void)clickGetPhoneCodeButton;
-(void)textfiledEdite:(NSString *)text;
@end
@interface JGJGetPhoneVerfyTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *phoneTextfiled;
@property (strong, nonatomic) IBOutlet UIButton *getCodeButton;
@property (strong, nonatomic) id  <getPhoneCodeDelegate>delegate;
@property (assign, nonatomic) NSInteger currentTime;
@property (assign, nonatomic) NSTimer *timer;
@property (strong, nonatomic) JGJAccountListModel *model;

@end
