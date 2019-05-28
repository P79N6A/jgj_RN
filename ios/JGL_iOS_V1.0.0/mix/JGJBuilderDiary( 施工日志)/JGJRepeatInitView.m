//
//  JGJRepeatInitView.m
//  JGJCompany
//
//  Created by Tony on 2017/8/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRepeatInitView.h"

@implementation JGJRepeatInitView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    [self initView];
    }
    return self;
}
-(void)initView{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJRepeatInitView" owner:self options:nil]lastObject];
    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];
    _clickButton.layer.borderWidth = 1;
    _clickButton.layer.borderColor = AppFont666666Color.CGColor;
    
}
- (IBAction)clickRepeatButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRepeatButton)]) {
        [self.delegate clickRepeatButton];
    }
}

@end
