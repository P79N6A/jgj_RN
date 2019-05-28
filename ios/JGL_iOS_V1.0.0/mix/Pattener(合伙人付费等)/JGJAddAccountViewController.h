//
//  JGJAddAccountViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger  ,payLoginType) {
    wxintype,
    alipayType,

};
@interface JGJAddAccountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIButton *aliPayButton;
@property (strong, nonatomic) IBOutlet UIButton *wxinButton;
@property (strong, nonatomic) IBOutlet UITextField *textFiled;
@property (strong, nonatomic) IBOutlet UIButton *addAccount;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filledDepart;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filedHeight;
@property (assign, nonatomic)  payLoginType loginType;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *alipayCenter;
@property (strong, nonatomic) IBOutlet UILabel *wexinNameLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageviewcenter;
@property (strong, nonatomic) IBOutlet UILabel *alipaynameLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *alipayNamelableConstance;

@end
