//
//  JLGBuildAreaTableViewCell.m
//  mix
//
//  Created by jizhi on 15/12/2.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBuildAreaTableViewCell.h"

@interface JLGBuildAreaTableViewCell ()
<
    UITextFieldDelegate
>
//定义一个block变量 用copy修饰
@property (nonatomic, copy) BuildAreaEndEditingBlock endEditBlock;
@property (nonatomic, copy) BuildAreaBeginEditingBlock beginEditBlock;
@property (nonatomic, copy) BuildAreaReturnBlock returnBlock;
@end

@implementation JLGBuildAreaTableViewCell
- (void )endEditWithBlock:(BuildAreaEndEditingBlock)block{
    self.endEditBlock = block;
}

- (void )beginEditWithBlock:(BuildAreaBeginEditingBlock)block{
    self.beginEditBlock = block;
}

- (void )returnWithBlock:(BuildAreaReturnBlock)block{
    self.returnBlock = block;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailTF.delegate = self;
    [self.detailTF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //删完
    if ([string isEqualToString:@""] && textField.text.length == 1) {
        self.squareLabel.textColor = TYColorHex(0x9a9a9a);
        
        return YES;
    }
    
    //存在内容
    NSString *shoudChangeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (shoudChangeStr.length > 0) {
        self.squareLabel.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.beginEditBlock) {
        self.beginEditBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.returnBlock) {
        self.returnBlock(self.indexPath);
        [textField resignFirstResponder];
    }
    return YES;
}
@end
