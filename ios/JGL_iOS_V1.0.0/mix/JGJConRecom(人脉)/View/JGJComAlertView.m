//
//  JGJComAlertView.m
//  mix
//
//  Created by yj on 2018/12/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComAlertView.h"

#import "UILabel+GNUtil.h"

@implementation JGJComAlertViewModel

@end

static JGJComAlertView *alertView;

@interface JGJComAlertView()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *secDes;

@property (weak, nonatomic) IBOutlet UILabel *thirDes;

@property (weak, nonatomic) IBOutlet UILabel *fourDes;

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *firDot;

@property (weak, nonatomic) IBOutlet UILabel *secDot;

@property (weak, nonatomic) IBOutlet UILabel *thirDot;

@property (weak, nonatomic) IBOutlet UILabel *firDotDes;

@property (weak, nonatomic) IBOutlet UILabel *secDotDes;

@property (weak, nonatomic) IBOutlet UILabel *thirDotDes;

@property (strong, nonatomic) NSMutableArray *alertSubViews;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnW;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secDesBottom;


@end

@implementation JGJComAlertView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self.containView.layer setLayerCornerRadius:JGJCornerRadius];
    
}

+ (JGJComAlertView *)showWithMessage:(JGJComAlertViewModel *)alertModel {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    
    if (!alertView) {
        
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJComAlertView" owner:self options:nil] lastObject];
    }
    
    alertView.titleLable.text = @"该用户已通过班组长认证";
    
    alertView.secDes.text = @"系统已验证其身份证与真人的对比照片\n系统已验证其名片资料\n系统已验证其在本系统未被曝光\n并严格保密身份证信息\n";
    
    [alertView.secDes setAttributedText:alertView.secDes.text lineSapcing:6];
    
    alertView.titleLable.textColor = AppFont83C76EColor;
    
    alertView.secDes.textColor = AppFont666666Color;
    
    alertView.titleLable.text = alertModel.title;
    
    alertView.thirDes.text = alertModel.thirDes;
    
    alertView.thirDes.textColor = AppFont000000Color;
    
    alertView.thirDes.font = [UIFont boldSystemFontOfSize:AppFont28Size];
    
    if (alertModel.secDesBottom != 0) {
        
        alertView.secDesBottom.constant = alertModel.secDesBottom;
    }
    
    [alertView setDotLayer];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];
    
    return alertView;
}

+ (JGJComAlertView *)showAlertViewWithMessage:(JGJComAlertViewModel *)alertModel {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    
    if (!alertView) {
        
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJComAlertView" owner:self options:nil] lastObject];
    }
    
    [alertView setDotLayer];
    
    if (!alertModel.is_show_subView) {
        
        [alertView hiddenSubViews];
        
        alertView.rightBtn.hidden = YES;
        
        alertView.rightBtnW.constant = 0;
    }
    
    alertView.titleLable.textColor = AppFont83C76EColor;
    
    alertView.secDes.textColor = AppFont666666Color;
    
    alertView.titleLable.text = alertModel.title;
    
    alertView.secDes.text = alertModel.secDes;
    
    if (alertModel.leftBtntitleColor) {
        
        [alertView.leftBtn setTitleColor:alertModel.leftBtntitleColor forState:UIControlStateNormal];
        
    }
    
    if (alertModel.containViewH > 0) {
        
        alertView.containViewH.constant = alertModel.containViewH;
        
    }else {
        
        alertView.containViewH.constant = 150;
    }
    
    if (alertModel.secDesBottom > 0) {
        
        alertView.secDesBottom.constant = alertModel.secDesBottom;
    }
    
    if (![NSString isEmpty:alertModel.firDot]) {
        
        alertView.firDotDes.text = alertModel.firDot;
    }
    
    if (![NSString isEmpty:alertModel.secDot]) {
        
        alertView.secDotDes.text = alertModel.secDot;
    }
    
    if (![NSString isEmpty:alertModel.thirDot]) {
        
        alertView.thirDotDes.text = alertModel.thirDot;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];
    
    return alertView;
}

- (void)setDotLayer {
    
    [alertView.firDot.layer setLayerCornerRadius:2.5];
    
    [alertView.secDot.layer setLayerCornerRadius:2.5];
    
    [alertView.thirDot.layer setLayerCornerRadius:2.5];
}

- (void)hiddenSubViews {
    
    for (UIView *subView in alertView.containView.subviews) {
        
        if (subView.tag >= 100 && subView.tag <= 108) {
            
            subView.hidden = YES;
        }
    }
    
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    
    [alertView dismissWithBlcok:alertView.leftButtonBlock];
}

- (IBAction)handleOkButtonAction:(UIButton *)sender {
    
    [self dismissWithBlcok:alertView.onOkBlock];
}

- (void)dismissWithBlcok:(void (^)(void))block {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        alertView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [alertView removeFromSuperview];
        
        alertView = nil;
        
        if (block) {
            
            block();
            
        }
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self) {
        
        [alertView dismissWithBlcok:nil];
        
    }
}

@end
