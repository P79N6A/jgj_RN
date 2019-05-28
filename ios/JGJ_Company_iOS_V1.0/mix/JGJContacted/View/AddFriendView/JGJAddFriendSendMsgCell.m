//
//  JGJAddFriendSendMsgCell.m
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendSendMsgCell.h"
#import "TYTextField.h"

@interface JGJAddFriendSendMsgCell ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet LengthLimitTextField *inputMsgTextField;

@property (weak, nonatomic) IBOutlet UITextView *inputMsgTextView;

@property (assign, nonatomic) NSInteger maxNumberOfWords;
@end

@implementation JGJAddFriendSendMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputMsgTextView.delegate = self;
    self.inputMsgTextView.textColor = AppFont333333Color;
    self.maxNumberOfWords = 50;
    
//    self.inputMsgTextField.maxLength = 50;
//    self.inputMsgTextField.valueDidChange = ^(NSString *value){
//        self.inputMsgTextField.text = value;
//        [self.inputMsgTextField markText:@"，" withColor:AppFont333333Color];
//        if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
//            [self.delegate textViewCell:self didChangeText:self.inputMsgTextField];
//        }
//    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInputMsg:(NSString *)inputMsg {
    _inputMsg = inputMsg;
    self.inputMsgTextView.text = _inputMsg;
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:self.inputMsgTextView.text];
    }
    [self.inputMsgTextField markText:@"，" withColor:AppFont333333Color];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    
    if (textView.text.length > self.maxNumberOfWords)
    {
        textView.text = [textView.text substringToIndex:self.maxNumberOfWords];
        
        return;
    }
    
    if (textView.text.length > self.maxNumberOfWords) {
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        
        [self.delegate textViewCell:self didChangeText:textView.text];
    }
    
//    bounds.size = newSize;
//    textView.bounds = bounds;
    
    //刷新自动计算高度
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    [tableView endUpdates];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
//    //这个判断相当于是textfield中的点击return的代理方法
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    
    return YES;
}
//
//- (UITableView *)tableView
//{
//    UIView *tableView = self.superview;
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    return (UITableView *)tableView;
//}

//- (IBAction)handleClearInputMsgAction:(UIButton *)sender {
//    self.inputTextView.text = @"";
//    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
//        [self.delegate textViewCell:self didChangeText:self.inputTextView];
//    }
//}


@end
