//
//  JGJMemberAppraiseInputCell.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberAppraiseInputCell.h"

#import "TYTextField.h"

@interface JGJMemberAppraiseInputCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *inputTextField;

@end

@implementation JGJMemberAppraiseInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:3];
    
    [self.addButton.layer setLayerCornerRadius:3];
    
    self.inputTextField.maxLength = 6;
    
//    self.inputTextField.valueDidChange = ^(NSString *value) {
//
//
//    };
    
    self.inputTextField.userInteractionEnabled = NO;
    
}

- (IBAction)addButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(inputWithCell:inputCellResType:)]) {
        
        [self.delegate inputWithCell:self inputCellResType:JGJMemberAppraiseInputCellButtonResType];
        
    }
}

////暂时没使用
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    if ([self.delegate respondsToSelector:@selector(inputWithCell:inputCellResType:)]) {
//
//        [self.delegate inputWithCell:self inputCellResType:JGJMemberAppraiseInputCellTextfieldResType];
//
//    }
//
//    return YES;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
