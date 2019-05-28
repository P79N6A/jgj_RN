//
//  JLGRegisterInfoTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGRegisterInfoTableViewCell.h"

@interface JLGRegisterInfoTableViewCell ()
<
    UITextFieldDelegate
>
//定义一个block变量 用copy修饰
@property (nonatomic, copy) endEditingBlock endEditBlock;
@property (nonatomic, copy) beginEditingBlock beginEditBlock;
@property (nonatomic, copy) ReturnBlock returnBlock;
@end

@implementation JLGRegisterInfoTableViewCell
- (void )endEditWithBlock:(endEditingBlock)block{
    self.endEditBlock = block;
}

- (void )beginEditWithBlock:(beginEditingBlock)block{
    self.beginEditBlock = block;
}

- (void)returnWithBlock:(ReturnBlock)block{
    self.returnBlock = block;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailTF.delegate = self;
    self.detailTF.textColor = AppFont999999Color;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.beginEditBlock) {
        self.beginEditBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.onlyNum && ![self validateNumber:string]) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.endEditBlock) {
        self.endEditBlock(self.indexPath,textField.text);
    }
}

//只输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.returnBlock) {
        self.returnBlock(self.indexPath);
        [textField resignFirstResponder];
    }
    return YES;
}

@end
