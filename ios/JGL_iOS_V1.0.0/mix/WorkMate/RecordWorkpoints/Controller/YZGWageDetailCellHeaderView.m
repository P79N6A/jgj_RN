//
//  YZGWageDetailCellHeaderView.m
//  mix
//
//  Created by Tony on 16/3/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageDetailCellHeaderView.h"

static const CGFloat putLabelMaxWithRation = 0.4;
static const CGFloat putLabelMinWithRation = 0.05;

@interface YZGWageDetailCellHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *greenMoneyView;
@property (weak, nonatomic) IBOutlet UIView *redMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;


//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redMoneyViewLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenMoneyViewLayoutW;

@end

@implementation YZGWageDetailCellHeaderView

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
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    [self.redMoneyView.layer setLayerBorderWithColor:TYColorHex(0xfb5e5e) width:0.5 ration:0.01];
    [self.greenMoneyView.layer setLayerBorderWithColor:TYColorHex(0x83c76e) width:0.5 ration:0.01];
}

- (void)setWageDetailValues:(WageDetailValues *)wageDetailValues{
    _wageDetailValues = wageDetailValues;
    
    NSString *monthString = [NSString stringWithFormat:@"%02ld",(long)wageDetailValues.month];
    NSString *yearString = [NSString stringWithFormat:@"%@",@(wageDetailValues.year)];
    //年月
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",monthString,yearString]];
    
    //月份比较大的字号，年份比较小的字号
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x666666) range:NSMakeRange(0, monthString.length)];
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, monthString.length)];
    
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xacacac) range:NSMakeRange(monthString.length + 1, yearString.length)];
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(monthString.length + 1, yearString.length)];
    
    self.leftTimeLabel.attributedText = contentStr;
    
    //实际收入
    if (wageDetailValues.m_total < 0) {
        self.moneyLabel.textColor = TYColorHex(0x92c977);
    }else{
        self.moneyLabel.textColor = JGJMainColor;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",wageDetailValues.m_total];
    

    //最大长度的比例，异常情况的时候会很大
    CGFloat maxWithRation = MAX(wageDetailValues.m_total_income, wageDetailValues.m_total_expend)/self.maxTotalValue?:1;
    
    //正常范围内的比例
    CGFloat normalWithRation =  MIN(maxWithRation, 1);
    
    //设置收入和支出的长度
    CGFloat labelMaxWith = putLabelMaxWithRation*TYGetUIScreenWidth*normalWithRation;
    CGFloat labelMinWith = putLabelMinWithRation*TYGetUIScreenWidth*normalWithRation;

    CGFloat greenMoneyRationW = labelMaxWith*wageDetailValues.m_total_expend/wageDetailValues.m_total_income;
    CGFloat redMoneyRationW = labelMaxWith*wageDetailValues.m_total_income/wageDetailValues.m_total_expend;
    if (wageDetailValues.m_total_income > wageDetailValues.m_total_expend) {//收入比支出多
        self.greenMoneyViewLayoutW.constant = wageDetailValues.m_total_expend?MIN(greenMoneyRationW, labelMinWith):0;
        self.redMoneyViewLayoutW.constant = wageDetailValues.m_total_income?MIN(redMoneyRationW, labelMaxWith):0;
    }else{//支出比收入多
        
        self.greenMoneyViewLayoutW.constant = wageDetailValues.m_total_expend?MIN(greenMoneyRationW, labelMaxWith):0;
        self.redMoneyViewLayoutW.constant = wageDetailValues.m_total_income?MIN(redMoneyRationW, labelMinWith):0;
    }
    
    NSString *disStr = JLGisLeaderBool?@"应付":@"收入";
    //收入
    self.inputLabel.text = [NSString stringWithFormat:@"%@:%.2f",disStr,wageDetailValues.m_total_income];
    self.inputLabel.textColor = wageDetailValues.m_total_income == 0 && self.redMoneyViewLayoutW.constant == 0?JGJMainColor:[UIColor blackColor];
    
    //借支
    self.outputLabel.text = [NSString stringWithFormat:@"借支:%.2f",wageDetailValues.m_total_expend];
    self.outputLabel.textColor = wageDetailValues.m_total_expend == 0 && self.greenMoneyViewLayoutW.constant == 0 ?TYColorHex(0x92c977):[UIColor blackColor];
    
    if (self.needFaceDown && wageDetailValues.list.count > 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self.rightImageView layoutIfNeeded];
        }];
    }else{
        self.rightImageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (CGFloat )maxTotalValue{
    _maxTotalValue = _maxTotalValue == 0?1:_maxTotalValue;
    return _maxTotalValue;
}
@end
