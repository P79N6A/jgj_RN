//
//  JGJCusTextField.m
//  mix
//
//  Created by yj on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCusTextField.h"

@interface JGJCusTextField () <UITextFieldDelegate>
@property (nonatomic, copy) NSString *previousText;
@end
@implementation JGJCusTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self customInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    
    if ([NSString isFloatZero:self.digit]) {
        
        self.digit = 6;
    }
    
    [self addTarget:self action:@selector(checkInput) forControlEvents:UIControlEventEditingChanged];
    
    self.keyboardType = UIKeyboardTypeDecimalPad;

}




- (void)checkInput {
    
    if (![NSString isEmpty:self.text]) {
        NSString *reg1 = [NSString stringWithFormat:@"^[0-9]{1,%zd}$",self.digit];
        NSString *reg2 = [NSString stringWithFormat:@"^[0-9]{0,%zd}\\.[0-9]{0,2}$",self.digit];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg1];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg2];
        BOOL isMatch1 = [predicate1 evaluateWithObject:self.text];
        BOOL isMatch2 = [predicate2 evaluateWithObject:self.text];

        if (!(isMatch1 || isMatch2)) {
            if (![NSString isEmpty:self.previousText]) {
                self.text = self.previousText;
            }
        } else {
            self.previousText = self.text;
        }
    }
    
}


@end
