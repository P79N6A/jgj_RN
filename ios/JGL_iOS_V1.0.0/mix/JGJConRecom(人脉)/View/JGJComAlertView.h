//
//  JGJComAlertView.h
//  mix
//
//  Created by yj on 2018/12/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComAlertViewModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *secDes;

@property (weak, nonatomic) NSString *thirDes;

@property (weak, nonatomic) NSString *fourDes;

@property (nonatomic, copy) NSString *leftBtntitle;

@property (nonatomic, strong) UIColor *leftBtntitleColor;

@property (nonatomic, copy) NSString *rightBtntitle;

@property (nonatomic, assign) CGFloat containViewH;

@property (strong, nonatomic) NSString *firDot;

@property (strong, nonatomic) NSString *secDot;

@property (strong, nonatomic) NSString *thirDot;

@property (assign, nonatomic) BOOL is_show_subView;

@property (nonatomic, assign) CGFloat secDesBottom;

@end

@interface JGJComAlertView : UIView

@property (nonatomic, copy)void (^leftButtonBlock) (void);

@property (nonatomic, copy)void (^onOkBlock) (void);

+ (JGJComAlertView *)showWithMessage:(JGJComAlertViewModel *)alertModel;

+ (JGJComAlertView *)showAlertViewWithMessage:(JGJComAlertViewModel *)alertModel;
@end
