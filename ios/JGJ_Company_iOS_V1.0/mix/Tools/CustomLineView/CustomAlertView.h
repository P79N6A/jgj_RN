//
//  PayPasswordAlertView.h
//  MarketEleven
//
//  Created by Bergren Lam on 12/22/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "CustomView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
#import "UILabel+GNUtil.h"
@interface CustomAlertView : UIView

+ (CustomAlertView *)showWithMessage:(NSString *)msg   leftButtonTitle:(NSString *)lt midButtonTitle:(NSString *)title rightButtonTitle:(NSString *)rt ;

@property (nonatomic, copy)void (^onOkBlock) (void);
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeight;
//点击按钮的颜色,和按钮的说明
- (void)showSuccessImageView;
- (void)showProgressImageView;
- (void)showProgressImageView:(NSString *)text;
- (void)dismissWithBlcok:(void (^)(void))block ;
+ (instancetype)customAlertView;
@end
