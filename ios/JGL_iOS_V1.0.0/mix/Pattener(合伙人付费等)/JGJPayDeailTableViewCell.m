//
//  JGJPayDeailTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPayDeailTableViewCell.h"
#import "WXApi.h"
@implementation JGJPayDeailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _AlipayButton.layer.masksToBounds = YES;
    _AlipayButton.layer.cornerRadius = 5;
    _WXPayButton.layer.masksToBounds = YES;
    _WXPayButton.layer.cornerRadius = 5;
    [self drwLineWithButton:_departLable];
    _mainView.layer.masksToBounds = YES;
    _mainView.layer.cornerRadius = JGJCornerRadius;
//默认选中微信
    _WXinPaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
    _AlipaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
    [self cheackInstallWechat];
}
#pragma mark - 此时是不是要根据是否安装微信来隐藏微信支付
-(void)cheackInstallWechat
{
    if (![WXApi isWXAppInstalled]) {
        _WXPayButton.hidden = YES;
        _wexinNameLable.hidden = YES;
        _wxinHeadimageview.hidden = YES;
        _WXinPaySelectImage.hidden = YES;
        _AlipaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
        _WXinPaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
        _departLable.hidden = YES;
//        CGRect wrect = _WXPayButton.frame;
//        wrect.size.height = 0;
//        [_WXPayButton setFrame:wrect];
//        CGRect rect = _AlipayButton.frame;
//        rect.size.height = 59;
//        [_AlipayButton setFrame:rect];
    }
}

- (IBAction)clickPayButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        _AlipaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
        _WXinPaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(choicePaytypeAndtype:)]) {
            [self.delegate choicePaytypeAndtype:@"2"];
        }
    }else{
        _WXinPaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
        _AlipaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(choicePaytypeAndtype:)]) {
            [self.delegate choicePaytypeAndtype:@"1"];
        }
    }

    
}

-(void)drwLineWithButton:(UIView *)button
{
    CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
    shaplayer.strokeColor = AppFontdbdbdbColor.CGColor;
    shaplayer.fillColor = nil;
//    shaplayer.path = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:CGPointMake(0, 0)];
    [triangle addLineToPoint:CGPointMake(TYGetUIScreenWidth - 54, 0)];
    shaplayer.path = triangle.CGPath;
    shaplayer.frame = button.bounds;
    shaplayer.lineWidth = 0.5f;

    shaplayer.lineCap = @"square";
//    shaplayer.masksToBounds = YES;
//    shaplayer.cornerRadius = 5;
    
    shaplayer.lineDashPattern = @[@4, @2];
    
    [button.layer addSublayer:shaplayer];
//    [WXApi isWXAppInstalled];
}
-(void)removeLineButton:(UIButton *)button
{
    CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
    shaplayer.strokeColor = [UIColor clearColor].CGColor;
    shaplayer.fillColor = nil;
    shaplayer.path = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
    shaplayer.frame = button.bounds;
    shaplayer.lineWidth = 1.f;
    
    shaplayer.lineCap = @"square";
    //    shaplayer.masksToBounds = YES;
    //    shaplayer.cornerRadius = 5;
    shaplayer.lineDashPattern = @[@4, @2];
    [button.layer addSublayer:shaplayer];
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    if ([orderListModel.pay_type isEqualToString:@"2"]) {
        _AlipaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
        _WXinPaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
    }else{
        _WXinPaySelectImage.image = [UIImage imageNamed:@"moreSelect"];
        _AlipaySelectImage.image = [UIImage imageNamed:@"椭圆-1"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
