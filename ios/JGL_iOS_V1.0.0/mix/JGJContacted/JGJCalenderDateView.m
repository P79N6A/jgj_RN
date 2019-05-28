//
//  JGJCalenderDateView.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCalenderDateView.h"

@implementation JGJCalenderDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    
    return self;
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    
}
- (void)initView
{
    
    [[[NSBundle mainBundle]loadNibNamed:@"JGJCalenderDateView" owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDateLable)];
    self.dateTitle.userInteractionEnabled = YES;
    [self.dateTitle addGestureRecognizer:tap];
    
    if (JGJ_IphoneX_Or_Later) {
        
        self.leftBtnCenterY.constant = 0;
        self.titleCenterY.constant = 0;
        self.rightBtnCenterY.constant = 0;
        
    }else {
        
        self.leftBtnCenterY.constant = 7;
        self.titleCenterY.constant = 7;
        self.rightBtnCenterY.constant = 7;
    }

}
- (IBAction)clickRightButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCalenderDateViewClickrightButton)]) {
        [self.delegate JGJCalenderDateViewClickrightButton];
    }
}

- (IBAction)clickLeftButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCalenderDateViewClickLeftButton)]) {
        [self.delegate JGJCalenderDateViewClickLeftButton];
    }
}
- (void)tapDateLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCalenderDateViewtapdateLable)]) {
        [self.delegate JGJCalenderDateViewtapdateLable];
    }

}
@end
