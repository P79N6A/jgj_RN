//
//  JGJCreatPlansView.m
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCreatPlansView.h"

@implementation JGJCreatPlansView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    return self;
   
}

+ (JGJCreatPlansView *)showView:(UIView *)view andModel:(JGJNodataDefultModel *)model andBlock:(clickCreatBlock)response
    {
        
        float barHeight = 0;
        if (isiPhoneX) {
            barHeight = -34;
        }
        JGJCreatPlansView *creteView  = [[JGJCreatPlansView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 - 62.5, view.frame.size.height - 174 - 63 + barHeight, 125 , 171)];
        
        if (TYGetUIScreenWidth <= 320) {
            creteView.widthConstance.constant = 92;
            creteView.heightConstance.constant = 90;
        }

        creteView.creatBlock = response;
        
        creteView.contentLable.text = model.contentStr;
        
        [view addSubview:creteView];
        
        return creteView;
}
- (void)initView{
    

    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"JGJCreatPlansView" owner:self options:nil] firstObject];
    
    [contentView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    self.contentLable.userInteractionEnabled = NO;
    
    [self.planButton addTarget:self action:@selector(animationPlanButton:) forControlEvents:UIControlEventTouchDown];
    [self.planButton addTarget:self action:@selector(animationOutSideButton:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.planButton setImage:[UIImage imageNamed:@"addPlanDown"] forState:UIControlStateHighlighted];

    [self.planButton setAdjustsImageWhenHighlighted:NO];

    [self addSubview:contentView];

}

- (void)animationOutSideButton:(UIButton *)button {
    
    [UIView animateWithDuration:.1 animations:^{
        
        self.planButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animationPlanButton:(UIButton *)button
{
    
    [UIView animateWithDuration:.1 animations:^{
        
        self.planButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
   
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.1 animations:^{

            self.planButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
        } completion:^(BOOL finished) {
        
            
            [UIView animateWithDuration:.1 animations:^{

                self.planButton.transform = CGAffineTransformMakeScale(0.85, 0.85);
   
            } completion:^(BOOL finished) {
            
            }];
    
        }];
    
    }];

}
- (IBAction)clickCrateView:(id)sender {
    
    self.planButton = (UIButton *)sender;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.planButton.transform = CGAffineTransformMakeScale(1, 1);
 
    });

    self.creatBlock(self.contentLable.text?:@"");

}

- (void)setDefultModel:(JGJNodataDefultModel *)defultModel
{
    self.contentLable.text = defultModel.contentStr?:@"";

}

@end
