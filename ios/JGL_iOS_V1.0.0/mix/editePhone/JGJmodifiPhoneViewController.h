//
//  JGJmodifiPhoneViewController.h
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJModifyTelSuccessBlock)(NSString *tel);

@interface JGJmodifiPhoneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTextfiled;
@property (strong, nonatomic) IBOutlet UIButton *getNumButton;
@property (strong, nonatomic) IBOutlet UILabel *firstlable;
@property (strong, nonatomic) IBOutlet UILabel *secondlable;
@property (strong, nonatomic) IBOutlet UILabel *thirdlable;
@property (strong, nonatomic) IBOutlet UILabel *fourthlable;
@property (strong, nonatomic) IBOutlet UIButton *nextstpbutton;
@property (strong, nonatomic) IBOutlet UIButton *notUsebutton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftdistance;
@property (strong, nonatomic) IBOutlet UIView *heightdistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lableleftdistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lablerightdistance;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) UIButton *closeButton;

@property (nonatomic, copy) JGJModifyTelSuccessBlock successBlock;

- (void)setIsFindAccoutInWithToken:(BOOL)isFindAccountIn token:(NSString *)token;
@end
