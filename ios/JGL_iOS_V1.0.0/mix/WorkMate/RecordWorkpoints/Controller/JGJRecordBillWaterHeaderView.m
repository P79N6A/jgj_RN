//
//  JGJRecordBillWaterHeaderView.m
//  mix
//
//  Created by Tony on 2017/10/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordBillWaterHeaderView.h"

@implementation JGJRecordBillWaterHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadView];

}
//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self= [super initWithCoder:aDecoder]) {
//        [self loadView];
//    }
//    return self;
//}
- (void)loadView{
    self.backgroundColor = AppFontfafafaColor;
    
  self.contentView =   [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordBillWaterHeaderView" owner:nil options:nil] firstObject];
    
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.amountLable = (UILabel *)[self.contentView viewWithTag:1];
    self.incomLable = (UILabel *)[self.contentView viewWithTag:2];
    self.expendLable = (UILabel *)[self.contentView viewWithTag:3];
    self.billTotalNumLable = (UILabel *)[self.contentView viewWithTag:4];

}
-(void)setAmount:(CGFloat)amount income:(CGFloat)income expend:(CGFloat)expend andcloseAnAccount:(CGFloat)Account
{

    if (amount<0) {
        self.amountLable.textColor = AppFonte83c76eColor;
    }
    self.amountLable.text =  [NSString stringWithFormat:@"%.2f",amount];
    //    NSString *amoutStr = [NSString stringWithFormat:@"%.2f",amount];
    //    self.amountLabel.text = [@"" stringByAppendingString:JGJMoneyNumStr(amoutStr)];
    if (amount < 0) {
        self.amountLable.textColor = AppFont83C76EColor;
    }
    self.incomLable.text = [NSString stringWithFormat:@"%.2f",income];
    //    NSString *amoutStrs = [NSString stringWithFormat:@"%.2f",income];
    //    self.incomeLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrs)];
    if (income < 0) {
        self.incomLable.textColor = AppFont83C76EColor;
    }
    
    
    self.expendLable.text = expend > 0?[NSString stringWithFormat:@"-%.2f",expend]:[NSString stringWithFormat:@"%.2f",expend];
    
    //    NSString *amoutStrss = [NSString stringWithFormat:@"%.2f",expend];
    //    self.expendLabel.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrss)];
    if (expend < 0) {
        self.expendLable.textColor = AppFont83C76EColor;
    }
    
    
    self.billTotalNumLable.text =Account > 0?[NSString stringWithFormat:@"-%.2f",Account]:[NSString stringWithFormat:@"%.2f",Account];
    
    //    NSString *amoutStrsss = [NSString stringWithFormat:@"%.2f",Account];
    //    self.billTotalNumLable.text = [@"￥" stringByAppendingString:JGJMoneyNumStr(amoutStrsss)];
    if (Account < 0) {
        self.billTotalNumLable.textColor = AppFont83C76EColor;
    }


}
@end
