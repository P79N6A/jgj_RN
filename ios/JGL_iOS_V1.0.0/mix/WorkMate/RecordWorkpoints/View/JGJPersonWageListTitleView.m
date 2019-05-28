//
//  JGJPersonWageListTitleView.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListTitleView.h"
#import "JGJLabel.h"

@interface JGJPersonWageListTitleView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *workHourView;

@property (weak, nonatomic) IBOutlet UILabel *workHourBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *workHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *overHourLabel;

@property (weak, nonatomic) IBOutlet UILabel *expendLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *incomeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTextLabel;

@property (weak, nonatomic) IBOutlet UIView *manHourColumnarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overHourColumnarLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manHourColumnarLayoutH;
@property (nonatomic ,strong)UILabel *BillMoneyLable;
@property (nonatomic ,strong)UILabel *BillMoneyNumLable;

@end

@implementation JGJPersonWageListTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [_moneyView addSubview:self.BillMoneyLable];
    [_moneyView addSubview:self.BillMoneyNumLable];

    self.incomeTextLabel.text  = @"工资总和:";
}
- (UILabel *)BillMoneyLable//余额
{
    if (!_BillMoneyLable) {
        
        _BillMoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalTextLabel.frame) + 8, 55, 15)];
        _BillMoneyLable.font = _totalTextLabel.font;
        _BillMoneyLable.textColor = AppFont333333Color;
        _BillMoneyLable.text = @"未结工资:";
        
    }
    
    return _BillMoneyLable;
}
- (UILabel *)BillMoneyNumLable//余额数额
{
    if (!_BillMoneyNumLable) {
        _BillMoneyNumLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_BillMoneyLable.frame) + 9, CGRectGetMaxY(_totalTextLabel.frame) + 8, TYGetUIScreenWidth *0.46  - CGRectGetMaxX(_BillMoneyLable.frame) - 20 , 15)];
        _BillMoneyNumLable.font = _totalTextLabel.font;
        _BillMoneyNumLable.textColor = AppFontd7252cColor;
        _BillMoneyNumLable.textAlignment = NSTextAlignmentRight;
        _BillMoneyNumLable.text = @"0";
    }
    return _BillMoneyNumLable;
}
- (void)setJgjPersonWageListModel:(JGJPersonWageListModel *)jgjPersonWageListModel{
    
    _jgjPersonWageListModel = jgjPersonWageListModel;
    if ((int)jgjPersonWageListModel.total_manhour == jgjPersonWageListModel.total_manhour) {
    self.workHourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.0f",jgjPersonWageListModel.total_manhour]  hourColor:TYColorHex(0xd7252c) fontSize:15.f];
 
    }else{
    self.workHourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.1f",jgjPersonWageListModel.total_manhour]  hourColor:TYColorHex(0xd7252c) fontSize:15.f];
    }
    
    
    if ((int)jgjPersonWageListModel.total_overtime == jgjPersonWageListModel.total_overtime) {
        
    self.overHourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.0f",jgjPersonWageListModel.total_overtime]  hourColor:TYColorHex(0x36a971) fontSize:15.f];
  
    }else{
    self.overHourLabel.attributedText = [JGJLabel getWorkHour:[NSString stringWithFormat:@"%.1f",jgjPersonWageListModel.total_overtime]  hourColor:TYColorHex(0x36a971) fontSize:15.f];
    }
//    if (jgjPersonWageListModel.total_income >= 10000 || jgjPersonWageListModel.total_income <= -10000) {
//    self.incomeLabel.text = [NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_income/10000];
//
//    }else{
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_income];
//    }
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_income];
    
//    self.incomeLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStr)];
    if (jgjPersonWageListModel.total_income < 0) {
        self.incomeLabel.textColor = AppFont83C76EColor;
    }
//    if (jgjPersonWageListModel.total_expend >= 10000 || jgjPersonWageListModel.total_expend <= -10000) {
//    self.expendLabel.text = [NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_expend/10000];
//
//    }else{
    self.expendLabel.text = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_expend];
//    }
    
    
//    NSString *totalStrs = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_expend];
//    self.expendLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStrs)];
    
//    if (jgjPersonWageListModel.total_balance >= 10000 || jgjPersonWageListModel.total_balance <= -10000) {
//        self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total_balance/10000];
//
//    }else{
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_balance];
//    }
//    
//    NSString *totalStrss = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total_balance];
//    self.totalLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStrss)];

    
    if (jgjPersonWageListModel.total < 0) {
        self.BillMoneyNumLable.textColor = AppFonte83c76eColor;
    }else{
        self.BillMoneyNumLable.textColor = AppFontd7252cColor;
    }
    
//    if (jgjPersonWageListModel.total >= 10000 || jgjPersonWageListModel.total <= -10000) {
//    self.BillMoneyNumLable.text =[NSString stringWithFormat:@"￥%.2f万",jgjPersonWageListModel.total/10000];
//    }else{
    self.BillMoneyNumLable.text =[NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total];
//    }
//    NSString *totalStrsss = [NSString stringWithFormat:@"%.2f",jgjPersonWageListModel.total];
//    self.BillMoneyNumLable.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStrsss)];
    if (jgjPersonWageListModel.total < 0) {
        self.BillMoneyNumLable.textColor = AppFont83C76EColor;
    }

    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.jgjPersonWageListModel.total_manhour || self.jgjPersonWageListModel.total_overtime) {
        //设置成最大值
        CGFloat workHourViewH = TYGetViewH(self.workHourView);
        CGFloat workHourLabelH = TYGetViewH(self.workHourLabel);
        CGFloat workHourBottomLabelH = TYGetViewH(self.workHourBottomLabel);
        CGFloat manHourColumnarMaxH = (workHourViewH - workHourLabelH - workHourBottomLabelH - 17);
        
        if (self.jgjPersonWageListModel.total_manhour > self.jgjPersonWageListModel.total_overtime) {
            if (self.manHourColumnarLayoutH.constant != manHourColumnarMaxH) {
                self.manHourColumnarLayoutH.constant = manHourColumnarMaxH;
            }
            self.overHourColumnarLayoutH.constant = manHourColumnarMaxH*self.jgjPersonWageListModel.total_overtime/self.jgjPersonWageListModel.total_manhour;
        }else{
            if (self.overHourColumnarLayoutH.constant != manHourColumnarMaxH) {
                self.overHourColumnarLayoutH.constant = manHourColumnarMaxH;
            }
            
            self.manHourColumnarLayoutH.constant = manHourColumnarMaxH*self.jgjPersonWageListModel.total_manhour/self.jgjPersonWageListModel.total_overtime;
        }

    }else{
        self.manHourColumnarLayoutH.constant = 0;
        self.overHourColumnarLayoutH.constant = 0;
    }
}
@end
