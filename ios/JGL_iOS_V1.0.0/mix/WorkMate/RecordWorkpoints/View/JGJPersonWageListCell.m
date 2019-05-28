//
//  JGJPersonWageListCell.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListCell.h"
#import "UILabel+JGJCopyLable.h"
#import "UILabel+GNUtil.h"
/**
 *  和屏幕宽度的最大比例
 */
static const CGFloat kPersonWageListHourMaxWidthRation = 0.367;

//能够显示的最大宽度
#define kPersonWageListHourMaxWidth  (kPersonWageListHourMaxWidthRation * TYGetUIScreenWidth)

@interface JGJPersonWageListCell ()

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UILabel *poorLabel;

@property (weak, nonatomic) IBOutlet UILabel *poorDesLabel;

@property (weak, nonatomic) IBOutlet UIView *poorView;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *expendLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *manHourLabel;

@property (weak, nonatomic) IBOutlet UILabel *overHourLabel;

@property (weak, nonatomic) IBOutlet UILabel *incomeTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *expendTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manHourLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overHourLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poorViewLayoutL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poorViewLayoutR;
//@property (nonatomic ,strong)UILabel *bIllTotalLable;//工资结算
//@property (nonatomic ,strong)UILabel *bIllTotalNumLable;//工资结算金额
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *bIllTotalNumLable;

@end

@implementation JGJPersonWageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.baseView addSubview:self.bIllTotalLable];
//    [self.baseView addSubview:self.bIllTotalNumLable];
    [self.poorView.layer setLayerCornerRadius:10];
    self.totalTextLabel.text = @"工资结算:";
//    _bIllTotalLable.text = JLGisMateBool?@"未结工资:":@"实际应付:";

    self.incomeTextLabel.text = JLGisMateBool?@"工       资:":@"应       付:";
//    self.expendTextLabel.text = JLGisMateBool?@"支       出:":@"借       支:";
    self.expendTextLabel.text = @"借       支:";

}
-(void)setJgjPersonWageListModel:(JGJPersonWageListModel *)jgjPersonWageListModel
{

    _jgjPersonWageListModel = [JGJPersonWageListModel new];
    _jgjPersonWageListModel = jgjPersonWageListModel;

}
- (void)setPersonWageListListList:(PersonWageListListList *)personWageListListList{
    _personWageListListList = personWageListListList;

    self.monthLabel.text = [personWageListListList.month stringByAppendingString:@"月"];
    
//    if (personWageListListList.total_income >= 10000 || personWageListListList.total_income <= -10000) {
//        self.incomeLabel.text = [NSString stringWithFormat:@"￥%.2f万",personWageListListList.total_income/10000];
//
//    }else{
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",personWageListListList.total_income];
//    }
    
    
//    NSString *totalStr = [NSString stringWithFormat:@"%.2f",personWageListListList.total_income];
//    self.incomeLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStr)];

    if (personWageListListList.total_income < 0) {
        self.incomeLabel.textColor = TYColorHex(0x83c76e);
    }
//    if (personWageListListList.total_expend >= 10000 || personWageListListList.total_expend <= -10000) {
//    self.expendLabel.text = [NSString stringWithFormat:@"￥%.2f万",personWageListListList.total_expend/10000];
//
//    }else{
    self.expendLabel.text = [NSString stringWithFormat:@"%.2f",personWageListListList.total_expend];
//    }
//    
//    NSString *totalStrs = [NSString stringWithFormat:@"%.2f",personWageListListList.total_expend];
//    self.expendLabel.text =[@"￥" stringByAppendingString: JGJMoneyNumStr(totalStrs)];
    

    
//    if (personWageListListList.total_balance >= 10000 || personWageListListList.total_balance <= -10000) {
//    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f万",personWageListListList.total_balance/10000];
//
//    }else{
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f",personWageListListList.total_balance];
//    }
//    NSString *totalStrss = [NSString stringWithFormat:@"%.2f",personWageListListList.total_balance];
//    self.totalLabel.text =[@"￥" stringByAppendingString: JGJMoneyNumStr(totalStrss)];

    
//    if (personWageListListList.total >= 10000 || personWageListListList.total <= -10000) {
//        self.bIllTotalNumLable.text = [NSString stringWithFormat:@"￥%.2f万",personWageListListList.total/10000];
//
//    }else{
    self.bIllTotalNumLable.text = [NSString stringWithFormat:@"%.2f",personWageListListList.total];
//    }
//    NSString *totalStrsss = [NSString stringWithFormat:@"%.2f",personWageListListList.total];
//    self.bIllTotalNumLable.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(totalStrsss)];
    if (personWageListListList.total < 0) {
        
    self.bIllTotalNumLable.textColor = TYColorHex(0x83c76e);
    }
    
    if (personWageListListList.total_manhour <=0) {
        self.manHourLabel.text = @"上班工时:\n-.-";
  
    }else{
    
    if ((int)personWageListListList.total_manhour == personWageListListList.total_manhour) {
        
    self.manHourLabel.text = [NSString stringWithFormat:@"上班工时:\n%.0f个工",personWageListListList.total_manhour];
   
    }else{

    self.manHourLabel.text = [NSString stringWithFormat:@"上班工时:\n%.1f个工",personWageListListList.total_manhour];
     }
    }
    
    
    [self.manHourLabel SetLinDepart:4];
    
    if (personWageListListList.total_overtime <= 0) {
        self.overHourLabel.text = @"加班工时:\n-.-";

    }else{
    
    if ((int)personWageListListList.total_overtime == personWageListListList.total_overtime) {
    self.overHourLabel.text = [NSString stringWithFormat:@"加班工时:\n%.0f个工",personWageListListList.total_overtime];
  
    }else{
        
    self.overHourLabel.text = [NSString stringWithFormat:@"加班工时:\n%.1f个工",personWageListListList.total_overtime];
        
    }
    }
    [self.overHourLabel SetLinDepart:4];

    //有查账就显示，没查账就不显示
    
    if (personWageListListList.t_poor == 0) {
        self.poorLabel.text = @"";
        self.poorDesLabel.text = @"";
        self.poorViewLayoutL.constant = 0;
        self.poorViewLayoutR.constant = 0;
    }else{
        self.poorLabel.text = [NSString stringWithFormat:@"%@",@(personWageListListList.t_poor)];
        self.poorDesLabel.text = @"笔待确认";
        self.poorViewLayoutL.constant = 22;
        self.poorViewLayoutR.constant = 10;
    }
    
    [self.manHourLabel markText:@"上班工时:" withColor:AppFont999999Color];
    [self.overHourLabel markText:@"加班工时:" withColor:AppFont999999Color];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置进度条
    /*if (self.personWageListListList.total_maxManhour > 0) {
        self.manHourLayoutW.constant = self.personWageListListList.total_manhour/self.personWageListListList.total_maxManhour*kPersonWageListHourMaxWidth;
        self.overHourLayoutW.constant =
        self.personWageListListList.total_overtime/self.personWageListListList.total_maxManhour*kPersonWageListHourMaxWidth;
    }*/
    
    if (self.jgjPersonWageListModel.total_manhour > 0) {
        self.manHourLayoutW.constant = self.personWageListListList.total_manhour/self.jgjPersonWageListModel.total_manhour*kPersonWageListHourMaxWidth;
        self.overHourLayoutW.constant =
        self.personWageListListList.total_overtime/self.jgjPersonWageListModel.total_manhour*kPersonWageListHourMaxWidth;
    }else{
        self.manHourLayoutW.constant = 0;
        self.overHourLayoutW.constant = 0;
    }
    
//    self.manHourLabel.textColor = self.manHourLayoutW.constant == 0?TYColorHex(0xd7252c):TYColorHex(0x333333);
//    [self.manHourLabel markText:@"上班工时" withColor:AppFont999999Color];
//    self.overHourLabel.textColor = self.overHourLayoutW.constant == 0?TYColorHex(0x36a971):TYColorHex(0x333333);
//    [self.overHourLabel markText:@"加班工时" withColor:AppFont999999Color];

}

//- (UILabel *)bIllTotalLable
//{
//    if (!_bIllTotalLable) {
//        _bIllTotalLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_incomeTextLabel.frame)-1, CGRectGetMaxY(_totalLabel.frame) + 3, 60, 15)];
//        _bIllTotalLable.text = @"";
//        _bIllTotalLable.font = _incomeTextLabel.font;
//        _bIllTotalLable.textColor = AppFont333333Color;
//    }
//    return _bIllTotalLable;
//}
//- (UILabel *)bIllTotalNumLable
//{
//    if (!_bIllTotalNumLable) {
//        _bIllTotalNumLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_totalLabel.frame)+1.5, CGRectGetMaxY(_totalLabel.frame) + 3, CGRectGetWidth(_baseView.frame) - CGRectGetMaxX(_bIllTotalLable.frame) - 36, 15)];
//        _bIllTotalNumLable.font = _totalLabel.font;
//        _bIllTotalNumLable.textAlignment = NSTextAlignmentRight;
//        _bIllTotalNumLable.textColor = AppFontd7252cColor;
//    }
//    return _bIllTotalNumLable;
//
//}
@end
