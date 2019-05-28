//
//  JGJWorkCircleDefaultProGroupCell.m
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleDefaultProGroupCell.h"
#import "UILabel+GNUtil.h"
#import "UIView+GNUtil.h"
@interface JGJWorkCircleDefaultProGroupCell ()

@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createGroupButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanQRCodeButtonW;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonH;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet UILabel *creatProDesLable;

@property (weak, nonatomic) IBOutlet UILabel *scanQRDesLable;
@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (weak, nonatomic) IBOutlet UIView *contentSubView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatProDesH;


@end

@implementation JGJWorkCircleDefaultProGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSet];
}

- (void)commonSet {
//    [self checkLoginStatus];
    self.creatProDesLable.textColor = AppFont999999Color;
    self.scanQRDesLable.textColor = AppFont999999Color;
    self.desLable.textColor = AppFont999999Color;
    
    self.contentSubView.backgroundColor = [UIColor clearColor];
    [self.contentDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    
    [self.creatProDesLable markText:@"新建项目" withColor:AppFontd7252cColor];
    [self.scanQRDesLable markText:@"扫描二维码" withColor:AppFontd7252cColor];
}

- (IBAction)createGroupBtnClick:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultGroupBtnClick:clickType:)]) {
        [self.delegate defaultGroupBtnClick:self clickType:WorkCircleHeaderViewCreatGroupButtonType];
    }
}

- (IBAction)scanQRCodeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultGroupBtnClick:clickType:)]) {
        [self.delegate defaultGroupBtnClick:self clickType:WorkCircleHeaderViewCreatSweepQrCodeButtonType];
    }
}

- (IBAction)handleLoginButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultGroupBtnClick:clickType:)]) {
        [self.delegate defaultGroupBtnClick:self clickType:WorkCircleDefaultCellLoginButtonType];
    }
}

- (void)checkLoginStatus {
//    self.desLable.hidden = !JLGLoginBool;
    [self.loginButton.layer setLayerCornerRadius:JGJCornerRadius];
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = AppFontd7252cColor;
    self.loginButtonH.constant = JLGLoginBool ? 0 : 35.0;
    self.loginButton.hidden = JLGLoginBool;
    self.scanQRCodeButtonW.constant = JLGLoginBool ? 70 : 0;
    self.createGroupButtonW.constant = self.scanQRCodeButtonW.constant;
}

+ (CGFloat)defaultProGroupCellHeight {
    
    return (TYGetUIScreenWidth - 20) * 0.56;
}

@end
