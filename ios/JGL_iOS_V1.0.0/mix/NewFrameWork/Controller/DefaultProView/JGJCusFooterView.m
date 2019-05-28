//
//  JGJCusFooterView.m
//  mix
//
//  Created by yj on 2018/6/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusFooterView.h"

@interface JGJCusFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJCusFooterView

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

-(void)setupView{
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.containView.backgroundColor = AppFontf1f1f1Color;
    
}

- (IBAction)checkButtonPressed:(UIButton *)sender {
    
    if (self.footerViewBlock) {
        
        self.footerViewBlock();
    }
    
}

+(CGFloat)cusFooterViewHeight {
    
    return 20;
}


@end
