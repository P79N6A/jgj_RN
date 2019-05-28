//
//  JGJSendMessageView.m
//  mix
//
//  Created by yj on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSendMessageView.h"

#import "YYTextView.h"

#import "UIView+Extend.h"

#import "UIView+GNUtil.h"

#import "NSString+Extend.h"


@interface JGJSendMessageView () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

//@property (strong, nonatomic)  YYTextView *inputTextView;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet YYTextView *inputTextView;

@end

@implementation JGJSendMessageView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

+ (instancetype)sendMessageView {

    return [[NSBundle mainBundle] loadNibNamed:@"JGJSendMessageView" owner:self options:nil].lastObject;
}

-(void)setupView {
    
    [self.replyButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.replyButton.layer setLayerBorderWithColor:AppFontccccccColor width:1 radius:2.5];
    
    [self.contentView.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:2.5];
    
    [[YYTextView appearance] setTintColor:AppFontd7252cColor];
    
    YYTextView *textView = self.inputTextView;
    
    textView.placeholderText = @"请输入回复内容";
    
    textView.font = [UIFont systemFontOfSize:AppFont32Size];

    textView.placeholderFont = [UIFont systemFontOfSize:AppFont32Size];
    
    textView.textContainerInset = UIEdgeInsetsMake(10, 12, 0, 0);
    
    textView.delegate = self;
    
    if (TYiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    textView.scrollIndicatorInsets = textView.contentInset;
    
    textView.returnKeyType = UIReturnKeySend;
    
    self.maxContentWords = 400;
}

- (void)textViewDidChange:(YYTextView *)textView {
 
    if (![NSString isEmpty:textView.text]) {
        
        if (textView.text.length > _maxContentWords) {
            
            self.inputTextView.selectedRange = NSMakeRange(textView.text.length, 0);
            
            NSString *inputContent = [textView.text substringToIndex:_maxContentWords];
            
            self.inputTextView.text = inputContent;
            
            
        }
        
    }
    
    if (self.sendMessageBlock) {
        
        self.sendMessageBlock(self, self.inputTextView.text);
        
    }
    
    if (![NSString isEmpty:self.inputTextView.text]) {
        
        [self.replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.replyButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
        
        self.replyButton.backgroundColor = AppFontd7252cColor;
    }else {
        
        [self.replyButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        
        [self.replyButton.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:2.5];
        
        self.replyButton.backgroundColor = [UIColor whiteColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    //这判断相当于是textfield中的点击return的代理方法
    if ([text isEqualToString:@"\n"]) {
        
        [self handleReplyMessageAction];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)handleAddImageButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(sendMessageView:sendMessageViewButtonType:)]) {
        
        [self.delegate sendMessageView:self sendMessageViewButtonType:JGJSendMessageViewAddImageType];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.sendSuccessMessageBlock = ^(JGJSendMessageView *sendMessageView, NSString *inputText) {
      
        weakSelf.inputTextView.text = nil;
        
    };
    
    
    
}

- (IBAction)handleReplyButtonAction:(UIButton *)sender {
 
    [self handleReplyMessageAction];
    
}

- (void)handleReplyMessageAction {
    
    if ([self.delegate respondsToSelector:@selector(sendMessageView:sendMessageViewButtonType:)]) {
        
        [self.delegate sendMessageView:self sendMessageViewButtonType:JGJSendMessageViewReplyButtonType];
    }
    
    self.inputTextView.text = nil;
}

- (void)setReplyMessage:(NSString *)replyMessage {

    _replyMessage = replyMessage;
    
    if (![NSString isEmpty:replyMessage]) {
        
        self.inputTextView.text = replyMessage;
    }

}

@end
