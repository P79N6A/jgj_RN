//
//  JGJWebLoginViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJWebLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSDictionary *paramDic;
@property (strong, nonatomic) NSString *qrcode_token;

@end
