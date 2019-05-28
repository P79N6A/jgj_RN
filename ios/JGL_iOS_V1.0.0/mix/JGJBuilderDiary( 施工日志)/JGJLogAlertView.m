//
//  JGJLogAlertView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogAlertView.h"
#import "UILabel+GNUtil.h"
@implementation JGJLogAlertView

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
    [[[NSBundle mainBundle]loadNibNamed:@"JGJLogAlertView" owner:self options:nil]firstObject];
    [self.contentViews setFrame:self.bounds];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = JGJCornerRadius;
    [self addSubview:self.contentViews];
    
    [self.contentLable markText:@"[工作日志]" withColor:AppFontEB4E4EColor];
}

+(void)showBottemRedAndIkownWithContent:(NSString *)content andClickCancelButton:(clickCancel)cancel
{
    JGJLogAlertView *alerView = [[JGJLogAlertView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    if (![NSString isEmpty:content]) {
        
        alerView.contentLable.text = content?:@"";
        
        alerView.heightConstance.constant = 170;
        
        alerView.widthConstance.constant = 270;
        
        alerView.iKownButton.backgroundColor = AppFontfafafaColor;
        
        [alerView.iKownButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alerView.iKownButton.frame), 0.5)];
        label.backgroundColor = AppFontf1f1f1Color;
        [alerView.iKownButton addSubview:label];
        
    }
    alerView.LogCancelBlock = cancel;
    [[[UIApplication sharedApplication]keyWindow] addSubview:alerView];

}
- (IBAction)clickSureButton:(id)sender {
    self.LogCancelBlock(@"clickCancel");
    [self removeFromSuperview];

}
@end
