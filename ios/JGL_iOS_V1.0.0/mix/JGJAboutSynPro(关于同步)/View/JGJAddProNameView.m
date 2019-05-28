//
//  JGJAddProNameView.m
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddProNameView.h"

#import "TYTextField.h"

@interface JGJAddProNameView ()

@property (weak, nonatomic) IBOutlet LengthLimitTextField *name;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJAddProNameView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
        
    }
    
    return self;
    
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJAddProNameView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    if (self.type == JGJAddProNameViewDefaultType) {
        
        self.name.maxLength = 10;
        
        self.name.placeholder = @"请输入项目名";
        
    }
    
    [self.name becomeFirstResponder];
    
    [self.saveButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.saveButton.backgroundColor =AppFontEB4E4EColor;
    
}


- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if (self.type == JGJAddProNameViewDefaultType) {
        
        if ([NSString isEmpty:self.name.text]) {
            
            [TYShowMessage showPlaint:@"请输入项目名"];
            
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(addProNameView:name:)]) {
        
        [self.delegate addProNameView:self name:self.name.text];
    }
    
}


@end
