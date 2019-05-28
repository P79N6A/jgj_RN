//
//  JGJSingerInputTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSingerInputTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJSingerInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textfiled.delegate = self;
    [_textfiled addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventAllEditingEvents];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJSelfLogTempRatrueModel *)model
{
    _model = model;
    _titleLable.text = model.element_name;
    _textfiled.placeholder = [@"请输入" stringByAppendingString:model.element_name];
    NSArray *array = [_model.length_range componentsSeparatedByString:@","];
    if (array.count != 0) {
        
        if ([array[1] length] != 0) {
            
            _textfiled.maxLength = [array[1] integerValue];
        }
    }

}
- (void)textchange:(UITextField *)textfiled {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BuilderDailyTextfiledTextInputEndEidting:andTag:)]) {
        [self.delegate BuilderDailyTextfiledTextInputEndEidting:textfiled.text andTag:textfiled.tag];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        
        return NO;
        
    }
    

    return YES;

}
@end
