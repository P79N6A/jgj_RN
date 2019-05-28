//
//  JGJSurePayView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSurePayView.h"
#import "UILabel+GNUtil.h"
@implementation JGJSurePayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, .5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        [self addSubview:lable];
        [self initView];
    }
    return self;
}
- (void)initView{

    [self addSubview:self.surePayButton];
    [self addSubview:self.privilegeLable];
    [self addSubview:self.salaryLable];

}
-(UIButton *)surePayButton
{
    if (!_surePayButton) {
        _surePayButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 160, 10, 150, 50)];
        _surePayButton.backgroundColor = AppFontEB4E4EColor;
        _surePayButton.titleLabel.textColor = [UIColor whiteColor];
        _surePayButton.layer.masksToBounds = YES;
        _surePayButton.layer.cornerRadius = JGJCornerRadius;
        [_surePayButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_surePayButton addTarget:self action:@selector(ClickPayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePayButton;
}
-(UILabel *)salaryLable
{
    if (!_salaryLable) {
        _salaryLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 180, 20)];
        _salaryLable.text = @"订单金额：";
        _salaryLable.font = [UIFont systemFontOfSize:14];
        _salaryLable.textColor = AppFont333333Color;

    }
    return _salaryLable;
}
-(UILabel *)privilegeLable
{
    if (!_privilegeLable) {
        _privilegeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 180, 20)];
        _privilegeLable.text = @"已优惠金额：";
        _privilegeLable.font = [UIFont systemFontOfSize:12];
        _privilegeLable.textColor = AppFont999999Color;
    }
    return _privilegeLable;
}
-(void)ClickPayButton
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickSurePayButton)]) {
        [self.delegate clickSurePayButton];
    }

}
-(void)setPriVteNum:(NSString *)p_num andSalary:(NSString *)salary
{
    //因为有些情况再小屏幕上无法显示金额 古缩小按钮大小
    if (TYGetUIScreenWidth <= 320) {
        [_surePayButton setFrame:CGRectMake(TYGetUIScreenWidth - 145, 10, 135, 50)];
    }
    _privilegeLable.text = [@"已优惠金额：¥" stringByAppendingString: p_num?:@"0" ];
//    if (([p_num floatValue] <= 0 && [salary floatValue]<0) || ([p_num floatValue] >  0 && [salary floatValue] <= 0)) {
//        _privilegeLable.hidden = YES;
//    }
    if ([p_num floatValue] <= 0 && !_orderDetail) {
        _privilegeLable.hidden = YES;
    }else{
        _privilegeLable.hidden = NO;

    }
    
    _salaryLable.text = [@"订单金额：¥" stringByAppendingString:salary?:@"0"];
    [_salaryLable markText:@"¥" withFont:[UIFont systemFontOfSize:12] color:AppFontEB4E4EColor];
    [_salaryLable markText:[@"¥" stringByAppendingString: salary?:@"0"] withFont:[UIFont systemFontOfSize:17] color:AppFontEB4E4EColor];
}
- (void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    if ([orderListModel.order_status isEqualToString:@"2"]) {
        self.surePayButton.hidden = YES;
    }

}

- (void)closeSurePayButtonUserinterface
{
    _surePayButton.userInteractionEnabled = NO;
    [_surePayButton setTitleColor:AppFontffffffColor forState:UIControlStateNormal];
    [_surePayButton setBackgroundColor:AppFontccccccColor];
    [_surePayButton setTitle:@"确认订单" forState:UIControlStateNormal];
}

- (void)openSurePayButtonUserinterface
{
    _surePayButton.userInteractionEnabled = YES;
    [_surePayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surePayButton setBackgroundColor:AppFontEB4E4EColor];
    [_surePayButton setTitle:@"立即支付" forState:UIControlStateNormal];

}
-(void)sureorderList
{
    _surePayButton.userInteractionEnabled = YES;
    [_surePayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_surePayButton setBackgroundColor:AppFontEB4E4EColor];
    [_surePayButton setTitle:@"确认订单" forState:UIControlStateNormal];
    
    
}

@end
