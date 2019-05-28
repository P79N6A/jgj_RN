//
//  JGJCusBottomButtonView.m
//  JGJCompany
//
//  Created by yj on 2017/7/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusBottomButtonView.h"

@interface JGJCusBottomButtonView ()

@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJCusBottomButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJCusBottomButtonView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.actionButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.actionButton.backgroundColor = AppFontd7252cColor;
    
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (IBAction)handleActionButtonPressed:(UIButton *)sender {
    
    if (self.handleCusBottomButtonViewBlock) {
        
        self.handleCusBottomButtonViewBlock(self);
    }
    
}

+ (CGFloat)cusBottomButtonViewHeight {
    
    return 65;
}

@end
