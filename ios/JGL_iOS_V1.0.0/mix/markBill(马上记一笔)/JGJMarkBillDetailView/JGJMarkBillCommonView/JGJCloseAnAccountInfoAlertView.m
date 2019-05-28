//
//  JGJCloseAnAccountInfoAlertView.m
//  mix
//
//  Created by Tony on 2018/5/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCloseAnAccountInfoAlertView.h"
#import "UILabel+GNUtil.h"
@interface JGJCloseAnAccountInfoAlertView ()

@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *containInfoView;
@property (weak, nonatomic) IBOutlet UIView *infoView1;

@property (weak, nonatomic) IBOutlet UIView *infoView2;

- (IBAction)modifyBtnClick:(UIButton *)sender;

- (IBAction)sureBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentCloseAnAccount;
@property (weak, nonatomic) IBOutlet UILabel *leftMoney;

@property (weak, nonatomic) IBOutlet UILabel *currentCloseAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftAccountLabel;

@end
@implementation JGJCloseAnAccountInfoAlertView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (void)setSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.containInfoView.layer setLayerCornerRadius:5];
    
    self.infoView1.layer.borderWidth = 1;
    self.infoView1.layer.borderColor = AppFontE3E3E3Color.CGColor;
    
    self.infoView2.layer.borderWidth = 1;
    self.infoView2.layer.borderColor = AppFontE3E3E3Color.CGColor;
    

    if (JLGisLeaderBool) {// 工头

        self.currentCloseAccountLabel.text = @"本次结算金额 = 本次实付金额+抹零金额+罚款金额-补贴金额-奖励金额";

    }else {

        self.currentCloseAccountLabel.text = @"本次结算金额 = 本次实收金额+抹零金额+罚款金额-补贴金额-奖励金额";
    }
    [_currentCloseAccountLabel markLineTextWithLeftTextAlignment:@"本次结算金额" withLineFont:[UIFont boldSystemFontOfSize:13] withColor:AppFont666666Color lineSpace:3];
    [_leftAccountLabel markLineTextWithLeftTextAlignment:@"剩余未结金额" withLineFont:[UIFont boldSystemFontOfSize:13] withColor:AppFont666666Color lineSpace:3];
    
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
}

- (void)setCurrentCloseAnCountMoney:(NSString *)closeMoney leftMoney:(NSString *)leftMoney {
    
    self.currentCloseAnAccount.text = closeMoney;
    self.leftMoney.text = leftMoney;
}

// 修改
- (IBAction)modifyBtnClick:(UIButton *)sender {
    
    if (_modify) {
        
        _modify();
        [self removeFromSuperview];
    }
    
}

// 确定
- (IBAction)sureBtnClick:(UIButton *)sender {
    
    if (_submit) {
        
        _submit();
        [self removeFromSuperview];
    }
    
}
@end
