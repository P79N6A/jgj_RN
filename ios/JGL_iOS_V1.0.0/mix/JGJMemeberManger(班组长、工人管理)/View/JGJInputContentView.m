//
//  JGJInputContentView.m
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJInputContentView.h"

#import "TYTextField.h"

@interface JGJInputContentView ()

@property (weak, nonatomic) IBOutlet UIView *containNameView;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *inputTagTextField;

@end

@implementation JGJInputContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.containNameView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:2.5];
    
    [self.addButton.layer setLayerCornerRadius:2.5];
    
    self.inputTagTextField.maxLength = 6;
    
    TYWeakSelf(self);
    
    self.inputTagTextField.valueDidChange = ^(NSString *value) {
        
        if (weakself.inputContentViewBlock) {
            
            weakself.inputContentViewBlock(value);
        }
    };
    
    if (!self.inputTagTextField.becomeFirstResponder) {

        [self.inputTagTextField becomeFirstResponder];
    }

}

- (IBAction)addButtonPressed:(UIButton *)sender {
    
    if (self.addButtonPressedBlock) {
        
        self.addButtonPressedBlock(self.inputTagTextField.text);
    }
    
}

@end
