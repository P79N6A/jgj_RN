//
//  JGJSalaryTextFiledsTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSalaryTextFiledsTableViewCell.h"

@implementation JGJSalaryTextFiledsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _salaryTextfiled.delegate = self;
    _salaryTextfiled.keyboardType = UIKeyboardTypeDecimalPad;
    [_salaryTextfiled addTarget:self action:@selector(textfiledEdite:) forControlEvents:UIControlEventEditingChanged];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        return NO;
    }
    if (![NSString isEmpty:string] && [textField.text containsString:@"."]) {
        NSRange ranges = [textField.text rangeOfString:@"."];
        if (ranges.location != NSNotFound) {
            if (range.location - ranges.location >= 3 || range.location <= 0) {
                return NO;
            }
        }

    }
    return YES;
}
-(void)textfiledEdite:(UITextField *)textfiled
{
    if ([textfiled.text floatValue] > [_model.amount floatValue]) {
        
        _salaryTextfiled.text = [NSString stringWithFormat:@"%.2f",[_model.amount?:@"0" floatValue] ];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(salaryEditeText:)]) {
        [self.delegate salaryEditeText:textfiled.text];
    }

}
-(void)setModel:(JGJAccountListModel *)model
{

    _model = [JGJAccountListModel new];
    _model = model;
    _salaryTextfiled.placeholder =[NSString stringWithFormat:@"最多可提 %.2f 元",[model.amount?:@"0" floatValue]];

}
@end
