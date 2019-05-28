//
//  JLGItemDescTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGItemDescTableViewCell.h"

@interface JLGItemDescTableViewCell ()
<
    UITextFieldDelegate
>
//定义一个block变量 用copy修饰
@property (nonatomic, copy) ItemDescEndEditingBlock endEditBlock;
@property (nonatomic, copy) ItemDescBeginEditingBlock beginEditBlock;


@end

@implementation JLGItemDescTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailTF.delegate = self;
}

- (void )endEditWithBlock:(ItemDescEndEditingBlock)block{
    self.endEditBlock = block;
}

- (void )beginEditWithBlock:(ItemDescBeginEditingBlock)block{
    self.beginEditBlock = block;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.beginEditBlock) {
        self.beginEditBlock();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}
@end
