//
//  JGJTotalTimeView.m
//  mix
//
//  Created by Tony on 2017/4/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTotalTimeView.h"
#import "UILabel+GNUtil.h"
@implementation JGJTotalTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initview];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initview];

    }
    return self;
}
- (void)initview{
    self.backgroundColor = AppFontfafafaColor;
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    CGRect rect = self.bounds;
    rect.size.width = TYGetUIScreenWidth;
    self.contentView.frame = rect;
    [self addSubview:self.contentView];
 
}
-(void)setTotallableTextworkTime:(NSString *)workTime totalOvertime:(NSString *)overTime
{
    _totalOverable.text = [NSString stringWithFormat:@"加班%@个工",overTime];
    [_totalOverable markText:overTime withColor:JGJMainColor];
    _totalWorkLable.text =[NSString stringWithFormat:@"合计:上班%@个工",workTime];
    [_totalWorkLable markText:workTime withColor:JGJMainColor];


}
@end
