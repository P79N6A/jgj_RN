//
//  JGJCusHeaderView.m
//  mix
//
//  Created by yj on 2018/6/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusHeaderView.h"

@interface JGJCusHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *title;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation JGJCusHeaderView

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
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    [self.checkButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
}

- (IBAction)checkButtonPressed:(UIButton *)sender {
    
    if (self.headerViewBlock) {
        
        self.headerViewBlock();
        
    }
    
}

+(CGFloat)cusHeaderViewHeight {
    
    return 45;
}

@end
