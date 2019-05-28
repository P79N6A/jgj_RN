//
//  YZGGetIndexRecordFirstTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetIndexRecordFirstTableViewCell.h"

@interface YZGGetIndexRecordFirstTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expendLabel;
//@property (nonatomic ,strong)UILabel *billTotalLable;
//@property (nonatomic ,strong)UILabel *billTotalNumLable;
@property (strong, nonatomic) IBOutlet UILabel *amountLable;

@property (weak, nonatomic) IBOutlet UILabel *incomeTextLabel;
@end

@implementation YZGGetIndexRecordFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _amountLabel.transform = CGAffineTransformMakeTranslation(0, 12);
    _amountLable.transform = CGAffineTransformMakeTranslation(0, 12);

    self.amountLabel.textColor = JGJMainColor;
    self.incomeLabel.textColor = JGJMainColor;
    self.incomeTextLabel.text  = JLGisMateBool?@"应收总和:":@"应付总和:";
//    [self.contentView addSubview:self.billTotalLable];
//    [self.contentView addSubview:self.billTotalNumLable];
    
//    CGRect rect = _amountLabel.frame;
//    rect.origin.y = rect.origin.y +30;
//    [_amountLabel setFrame:rect];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAmount:(CGFloat)amount income:(CGFloat )income expend:(CGFloat )expend{
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",amount];
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",income];
    self.expendLabel.text = expend > 0?[NSString stringWithFormat:@"-%.2f",expend]:[NSString stringWithFormat:@"%.2f",expend];
}
-(void)setAmount:(CGFloat)amount income:(CGFloat)income expend:(CGFloat)expend andcloseAnAccount:(CGFloat)Account
{
    if (amount<0) {
        self.amountLabel.textColor = AppFonte83c76eColor;
    }
    self.amountLabel.text =  [NSString stringWithFormat:@"%.2f",amount];
//    NSString *amoutStr = [NSString stringWithFormat:@"%.2f",amount];
//    self.amountLabel.text = [@"" stringByAppendingString:JGJMoneyNumStr(amoutStr)];
    if (amount < 0) {
        self.amountLabel.textColor = AppFont83C76EColor;
    }
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",income];
//    NSString *amoutStrs = [NSString stringWithFormat:@"%.2f",income];
//    self.incomeLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrs)];
    if (income < 0) {
        self.incomeLabel.textColor = AppFont83C76EColor;
    }

    
    self.expendLabel.text = expend > 0?[NSString stringWithFormat:@"-%.2f",expend]:[NSString stringWithFormat:@"%.2f",expend];
    
//    NSString *amoutStrss = [NSString stringWithFormat:@"%.2f",expend];
//    self.expendLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrss)];
    if (expend < 0) {
        self.expendLabel.textColor = AppFont83C76EColor;
    }

    
    self.billTotalNumLable.text =Account > 0?[NSString stringWithFormat:@"-%.2f",Account]:[NSString stringWithFormat:@"%.2f",Account];
    
//    NSString *amoutStrsss = [NSString stringWithFormat:@"%.2f",Account];
//    self.billTotalNumLable.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrsss)];
    if (Account < 0) {
    self.billTotalNumLable.textColor = AppFont83C76EColor;
    }


}
//- (UILabel *)billTotalLable
//{
//    if (!_billTotalLable) {
//        _billTotalLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.incomeTextLabel.frame) - 60, CGRectGetMaxY(_expendLabel.frame)+8.5, CGRectGetWidth(self.incomeTextLabel.frame), 15)];
//        _billTotalLable.text = @"结算总和:";
//        _billTotalLable.font = [UIFont systemFontOfSize:13];
//        _billTotalLable.textColor = AppFont999999Color;
//    }
//    return _billTotalLable;
//}
//- (UILabel *)billTotalNumLable
//{
//    if (!_billTotalNumLable) {
//        _billTotalNumLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_billTotalLable.frame), CGRectGetMaxY(_expendLabel.frame)+8.5, TYGetUIScreenWidth-CGRectGetMaxX(_billTotalLable.frame)-10, 15)];
//        _billTotalNumLable.font = _expendLabel.font;
//        _billTotalNumLable.textColor = AppFonte83c76eColor;
//        _billTotalNumLable.textAlignment = NSTextAlignmentRight;
//        _billTotalNumLable.text = @"  0";
//    }
//    return _billTotalNumLable;
//
//}
@end
