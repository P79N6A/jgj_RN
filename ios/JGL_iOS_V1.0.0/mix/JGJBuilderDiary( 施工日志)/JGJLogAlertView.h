//
//  JGJLogAlertView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickCancel)(NSString *content);
@interface JGJLogAlertView : UIView
@property (copy, nonatomic) clickCancel LogCancelBlock;
@property (strong, nonatomic) NSString *contentStr;
@property (strong, nonatomic) IBOutlet UIView *contentViews;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstance;
@property (strong, nonatomic) IBOutlet UIButton *iKownButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstance;
+(void)showBottemRedAndIkownWithContent:(NSString *)content andClickCancelButton:(clickCancel)cancel;
@end
