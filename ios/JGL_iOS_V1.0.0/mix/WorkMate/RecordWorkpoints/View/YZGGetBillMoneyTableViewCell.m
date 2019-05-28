//
//  YZGGetBillMoneyTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetBillMoneyTableViewCell.h"
#import "NSDate+Extend.h"

@interface YZGGetBillMoneyTableViewCell ()
<
    UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *billTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedDateButton;
@property (weak, nonatomic) IBOutlet UIImageView *RecordWorkPointsDateImage;
@property (nonatomic ,strong)UIImageView *imageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointDataImageLayoutR;
@property (strong, nonatomic) IBOutlet UILabel *imageType;
@end

@implementation YZGGetBillMoneyTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.billMoneyTF.delegate = self;
    self.billMoneyTF.font = [UIFont boldSystemFontOfSize:self.billMoneyTF.font.pointSize];
    //328版本 限制金额小数点后面只有两位,添加了控件LengthLimitTextField
    LengthLimitTextField *tf = self.billMoneyTF;
    tf.maxLength = 6;
    self.billMoneyTF.valueDidChange = ^(NSString *v){
        if ([v rangeOfString:@"."].location != NSNotFound) {
            NSString *point = [v componentsSeparatedByString:@"."][1];
            if (point.length > 2) {
                tf.text = [v substringToIndex:v.length - 1];
            }
        }
    };
    
    UITapGestureRecognizer *tapGuetr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBillMoneyTF)];
    self.billMoneyTF.userInteractionEnabled = YES;
    [self.billMoneyTF addGestureRecognizer:tapGuetr];
    
    self.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_account_edit_down1"]];
}
- (void)tapBillMoneyTF
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapBillMoneyLable)]) {
        [self.delegate tapBillMoneyLable];
    }
}
- (void)setMoneyTFEnabel:(BOOL )enabel{
    self.billMoneyTF.enabled = YES;
}
- (void)setTitle:(NSString *)title setTime:(NSString *)time setRedMoney:(NSString *)money{
    self.billMoneyTF.textColor = [UIColor whiteColor];
    [self setTitle:title setTime:time setMoney:money];
}

- (void)setTitle:(NSString *)title setTime:(NSString *)time setBlueMoney:(NSString *)money{
    self.billMoneyTF.textColor = [UIColor whiteColor];
    [self setTitle:title setTime:time setMoney:money];
}

- (void)setTitle:(NSString *)title setTime:(NSString *)time setMoney:(NSString *)money{
    self.billTitleLabel.text = title;
    self.billTimeLabel.text = time;
    self.billMoneyTF.text= money;
}

- (void)setNotGetBillDidLoad:(BOOL)notGetBillDidLoad{
    _notGetBillDidLoad = notGetBillDidLoad;

    self.pointDataImageLayoutR.constant = notGetBillDidLoad?20:8;
    self.RecordWorkPointsDateImage.hidden = !notGetBillDidLoad;
}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel{
    if (!yzgGetBillModel.date) {
        yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }
    if (yzgGetBillModel.accounts_type.code >2) {
        self.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_account_edit_borrow_down"]];
        self.selectedDateButton.backgroundColor = [UIColor clearColor];
    }
    _yzgGetBillModel = yzgGetBillModel;
    NSArray *titleTypeArray = @[@"点工工钱",@"包工工钱",@"借支工钱",@"工资结算"];
    
    NSInteger accountsTypecode = yzgGetBillModel.accounts_type.code;
    
    self.RecordWorkPointsDateImage.hidden = !self.notGetBillDidLoad;
//    self.RecordWorkPointsDateImage.backgroundColor = [UIColor whiteColor];
//    self.billTimeLabel.textColor = self.notGetBillDidLoad?JLGBlueColor:TYColorHex(0xc4c4c4);
    self.pushImageView.backgroundColor = [UIColor clearColor];
    if ([yzgGetBillModel.modify_marking isEqualToString:@"2"]) {
        self.pushImageView.hidden = NO;

        self.pushImageView.image = [UIImage imageNamed:@"yellowS"];

    }else if ([yzgGetBillModel.modify_marking isEqualToString:@"3"])
    {
        self.pushImageView.hidden = NO;

        self.pushImageView.image = [UIImage imageNamed:@"blueS"];
    }else{
        self.pushImageView.hidden = YES;
    }
//    NSString *dateString = !self.notGetBillDidLoad?yzgGetBillModel.date:[NSString stringWithFormat:@"(%@)",yzgGetBillModel.date];
    NSString *dateString = yzgGetBillModel.date;
    if (accountsTypecode == 3||accountsTypecode == 4) {
        [self setTitle:titleTypeArray[accountsTypecode - 1] setTime:dateString setBlueMoney:[NSString stringWithFormat:@"%.2f",(CGFloat )yzgGetBillModel.salary]];
    }else{
        [self setTitle:titleTypeArray[accountsTypecode - 1] setTime:dateString setRedMoney:[NSString stringWithFormat:@"%.2f",(CGFloat )yzgGetBillModel.salary]];
    }
}

- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy年MM月dd日"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    return dateString;
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetBillMoneyChangeCharacters:detailStr:)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self.delegate GetBillMoneyChangeCharacters:self detailStr:textField.text];
        });
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetBillMoneyEndEditing:detailStr:)]) {
        [self.delegate GetBillMoneyEndEditing:self detailStr:self.billMoneyTF.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetBillMoneyBeginEditing:)]) {
        [self.delegate GetBillMoneyBeginEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GetBillMoneyReturn:)]) {
        [textField resignFirstResponder];
        [self.delegate GetBillMoneyReturn:self];
    }
    return YES;
}

- (IBAction)selectedDateBtnClick:(id)sender {
    if (!self.notGetBillDidLoad) {
        return;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(GetBillSelectedDate:)]) {
        [self.delegate GetBillSelectedDate:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectedDateButton.layer setLayerCornerRadiusWithRatio:0.02];
}

@end
