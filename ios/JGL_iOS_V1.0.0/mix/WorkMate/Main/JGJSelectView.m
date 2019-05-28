//
//  JGJSelectView.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSelectView.h"

@implementation JGJSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self InitView];
    }
    return self;
}

-(void)InitView{
    UIView *titleview = [[[NSBundle mainBundle] loadNibNamed:@"SelectetitleView" owner:nil options:nil]firstObject];
    [titleview setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:titleview];

}
- (IBAction)backButton:(id)sender {
    if ([self.calenderDelegate respondsToSelector:@selector(ClickLeftButtonTocalender)]) {
        [self.calenderDelegate ClickLeftButtonTocalender];
    }
}
- (IBAction)nextButton:(id)sender {
//    if ([self.calenderDelegate respondsToSelector:@selector(ClickRightButtonTocalender)]) {
//        [self.calenderDelegate ClickRightButtonTocalender];
//    }

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
