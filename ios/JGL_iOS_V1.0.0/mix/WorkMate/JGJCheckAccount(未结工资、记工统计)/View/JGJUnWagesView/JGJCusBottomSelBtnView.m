//
//  JGJCusBottomSelBtnView.m
//  mix
//
//  Created by yj on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCusBottomSelBtnView.h"

@interface JGJCusBottomSelBtnView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation JGJCusBottomSelBtnView

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
    
    [self.rightBtn.layer setLayerBorderWithColor:AppFontEB4E4EColor width:1 radius:5];
    
    self.contentView.backgroundColor = AppFontffffffColor;
    
    [self.rightBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}

- (void)setLeftTitle:(NSString *)leftTitle {
    
    _leftTitle = leftTitle;
    
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    
}

- (void)setRightTitle:(NSString *)rightTitle {
    
    _rightTitle = rightTitle;
    
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    
}

- (IBAction)leftButtonPressed:(UIButton *)sender {
    
    if (self.leftBlock) {
        
        self.leftBlock(sender);
    }
    
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    
    if (self.rightBlock) {
        
        self.rightBlock(sender);
    }
    
}

+(CGFloat)bottomSelBtnViewHeight {
    
    return 64;
}

@end
