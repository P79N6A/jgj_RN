//
//  JGJBuyCallPhone.m
//  JGJCompany
//
//  Created by Tony on 2017/9/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBuyCallPhone.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJBuyCallPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self initView];
        [TYNotificationCenter addObserver:self selector:@selector(removeSelfViewAction) name:JLGLoginFail object:nil];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}
-(void)awakeFromNib
{
    [self initView];
    [super awakeFromNib];
}
- (void)initView
{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJBuyCallPhone" owner:self options:nil] firstObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfViewAction)];
    [self.contentView addGestureRecognizer:tap];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    [self.contentView setFrame:self.frame];
    [self addSubview:self.contentView];
}
-(void)removeSelfViewAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeView];
}
- (void)removeView{
    [UIView animateWithDuration:.15 animations:^{
        [self removeFromSuperview];
    }];
    
}
+(void)showApplyViewAndClickApply:(applyBlock)applyBlock andClickIkwonButton:(IkownBlock)cancelBlock
{
    JGJBuyCallPhone *timeView = [[JGJBuyCallPhone alloc]initWithFrame:[UIScreen mainScreen].bounds];
    timeView.IknowBlock = cancelBlock;
    timeView.applyBlock = applyBlock;
    [timeView.contentLable SetLinDepart:6];
    [[[UIApplication sharedApplication ]keyWindow ]addSubview:timeView];
}
- (IBAction)applyButton:(id)sender {
    self.applyBlock(@"apply");
    [self removeView];

}
- (IBAction)cancelButton:(id)sender {
    self.IknowBlock(@"cancel");
    [self removeView];

}

@end
