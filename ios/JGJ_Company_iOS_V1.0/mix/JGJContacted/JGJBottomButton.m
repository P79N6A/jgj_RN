//
//  JGJBottomButton.m
//  mix
//
//  Created by Tony on 2016/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBottomButton.h"

@implementation JGJBottomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        [self initUI];
    }
    return self;
}
-(void)initUI{

    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"ReplyButton" owner:nil options:nil]firstObject];
    view.backgroundColor = [UIColor orangeColor];
    [self addSubview:view];
}
@end
