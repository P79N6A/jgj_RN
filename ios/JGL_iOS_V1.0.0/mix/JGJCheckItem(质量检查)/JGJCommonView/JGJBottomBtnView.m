//
//  JGJBottomBtnView.m
//  JGJCompany
//
//  Created by Tony on 2017/12/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBottomBtnView.h"

@implementation JGJBottomBtnView
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadView];

}
+(JGJBottomBtnView *)showBootmAndWithTitle:(NSString *)title andSuperView:(UIView *)view
{
    JGJBottomBtnView *bottmView = [[JGJBottomBtnView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    
    [bottmView.clickBtn setTitle:title?:@"" forState:UIControlStateNormal];
    
    return bottmView;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self loadView];
        
    }
    return self;
    
}
- (void)loadView{
    
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    [contentView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 65)];
    
    [self addSubview:contentView];
    
    self.clickBtn.layer.masksToBounds = YES;
    
    self.clickBtn.layer.cornerRadius = 5;
    
    self.clickBtn.backgroundColor = AppFontEB4E4EColor;
    
    
}
- (IBAction)clickBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickJGJBottomBtnViewBtn)]) {
        [self.delegate clickJGJBottomBtnViewBtn];
    }
}

-(void)setDefultModel:(JGJNodataDefultModel *)defultModel
{
    [self.clickBtn setTitle:defultModel.contentStr?:@"" forState:UIControlStateNormal];

    
}
- (void)setClickBtnTitle:(NSString *)title
{
    [self.clickBtn setTitle:title?:@"" forState:UIControlStateNormal];
    
}
@end
