//
//  JGJQustionShowView.m
//  mix
//
//  Created by Tony on 2018/1/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQustionShowView.h"

@implementation JGJQustionShowView
-(instancetype)initWithFrame:(CGRect)frame FromShowType:(JGJQuestionShowtype)type{
    if (self = [super initWithFrame:frame]) {
        self.showType = type;
        [self loadView];
    }
    return self;
}
- (void)loadView{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    [contentView setFrame:self.bounds];
//    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = 5;
    [self addSubview:contentView];
    [self.KownBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    if (self.showType == JGJBalanceAmountType) {
        self.contentLable.text = @"未结工资 = 点工工资 + 包工工资 - 借支金额 - 已结金额";
    }else if (self.showType == JGJNowPayAmountType){
        if (JLGisLeaderBool) {
            
            self.contentLable.text = @"本次结算金额 = 本次实付金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额";
            
        }else{
            
            self.contentLable.text = @"本次结算金额 = 本次实收金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额";
            
        }
    }else{
        if (JLGisLeaderBool) {
            
            self.contentLable.text = @"剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实付金额 - 抹零金额";

        }else{
            
            self.contentLable.text = @"剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额";

        }
        
    }
  
}

+(void)showQustionFromPoint:(CGPoint)point FromShowType:(JGJQuestionShowtype)type
{
    for (UIView *view in [[[UIApplication sharedApplication]keyWindow] subviews]) {
        if ([view isKindOfClass:[JGJQustionShowView class]]) {
            [view removeFromSuperview];
        }
    }
    JGJQustionShowView *showView = [[JGJQustionShowView alloc] initWithFrame:CGRectMake(point.x - 84, point.y - 92, 229, 79) FromShowType:type];
    [[[UIApplication sharedApplication]keyWindow]addSubview:showView];
    
}
- (IBAction)clickKwonBtn:(id)sender {
    if (self) {
        [self removeFromSuperview];
    }
}
+ (void)removeQustionView
{
    
    for (UIView *view in [[[UIApplication sharedApplication]keyWindow] subviews]) {
        if ([view isKindOfClass:[JGJQustionShowView class]]) {
            [view removeFromSuperview];
        }
    }
   
}
@end
