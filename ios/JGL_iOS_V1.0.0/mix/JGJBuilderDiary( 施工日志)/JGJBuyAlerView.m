//
//  JGJBuyAlerView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBuyAlerView.h"

@implementation JGJBuyAlerView
-(instancetype)initWithFrame:(CGRect)frame

{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [TYNotificationCenter addObserver:self selector:@selector(removeSelfViewAction) name:JLGLoginFail object:nil];

    }
    return self;
}
-(void)removeSelfViewAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [self removeFromSuperview];

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
    [super awakeFromNib];
    [self initView];
}
-(void)initView{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJBuyAlerView" owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = JGJCornerRadius;
    [self addSubview:self.contentView];
}

+(void)showBottemMoreButtonWithContent:(NSString *)content andClickCancelButton:(BuyAlertBlock)buyBlock cancelBlock:(BcancelAlertBlock)cancelBlock
{
    JGJBuyAlerView *alerView = [[JGJBuyAlerView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    [[[UIApplication sharedApplication]keyWindow] addSubview:alerView];
    alerView.BuyBlock = buyBlock;
    alerView.CancelBlock = cancelBlock;
    
    
}


- (IBAction)clickCancelButton:(id)sender {
    [self removeFromSuperview];

    self.CancelBlock(@"cancel");
}
- (IBAction)clickBuyButton:(id)sender {
    [self removeFromSuperview];
    self.BuyBlock(@"buy");
}


@end
