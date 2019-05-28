//
//  JGJRecordTipView.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordTipView.h"
#import "UILabel+GNUtil.h"
@implementation JGJRecordTipView

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
    [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordTipView" owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    
    [self addSubview:self.contentView];
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.centerLable.frame)- 16, 8.5, 9, 13)];
    self.imageview.image = [UIImage imageNamed:@"mainRecodrrow"];
    [self.centerLable addSubview:self.imageview];
    self.centerLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taptipLable)];
    [self.centerLable addGestureRecognizer:tap];
    
    self.centerLable.layer.cornerRadius = 15;
    self.centerLable.layer.masksToBounds = YES;

    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(aniaml) userInfo:nil repeats:YES];
    
//    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taptipLable)];
    
//    self.animalView.userInteractionEnabled = YES;
    
//    [self.animalView addGestureRecognizer:taps];
    
    UIButton *button = [[UIButton alloc]initWithFrame:self.centerLable.frame];
    
    [button addTarget:self action:@selector(taptipLable) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
}
-(void)taptipLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJRecordTipViewTapRecordNosureTiplable)]) {
        [self.delegate JGJRecordTipViewTapRecordNosureTiplable];
    }

}

-(void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)aniaml{

    [UIView animateWithDuration:0.6 animations:^{
   
        self.imageview.transform = CGAffineTransformMakeTranslation(-10, 0);
        self.imageview.alpha = .3;

    }completion:^(BOOL finished) {

        [UIView animateWithDuration:.6 animations:^{
   
            self.imageview.transform = CGAffineTransformMakeTranslation(0, 0);
            self.imageview.alpha = 1;
        }];

}];

}
-(void)setWaitConfirmAndText:(NSString *)text
{
    self.centerLable.text = [NSString stringWithFormat:@"   有 %@笔 记工需要你确认",text];
    
//    [self.centerLable markText:[NSString stringWithFormat:@"%@笔",text] withColor:AppFontf18215Color];
}
@end
