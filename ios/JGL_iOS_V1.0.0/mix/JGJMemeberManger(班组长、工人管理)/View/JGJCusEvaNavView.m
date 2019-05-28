//
//  JGJCusEvaNavView.m
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusEvaNavView.h"

@interface JGJCusEvaNavView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation JGJCusEvaNavView

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
    
    self.containView.backgroundColor = AppFontfafafaColor;
    
    self.titleLable.font = [UIFont systemFontOfSize:JGJNavBarFont];
    
    self.titleLable.textColor = AppFont333333Color;
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    
    if (self.closedButtonPressedBlock) {
        
        self.closedButtonPressedBlock();
    }
}

@end
