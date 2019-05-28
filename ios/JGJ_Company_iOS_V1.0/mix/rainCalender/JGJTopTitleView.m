//
//  JGJTopTitleView.m
//  mix
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTopTitleView.h"

@implementation JGJTopTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setView];
    }
    return self;
}

- (void)setView{

    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"TopTitleView" owner:self options:nil] firstObject];
    [view setFrame:self.bounds];
    view.backgroundColor = AppFontf1f1f1Color;
    [self addSubview:view];

}
-(void)setSelectNumPeople:(NSString *)num
{

}
@end
