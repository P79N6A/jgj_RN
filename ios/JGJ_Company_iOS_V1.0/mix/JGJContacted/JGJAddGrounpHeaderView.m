//
//  JGJAddGrounpHeaderView.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAddGrounpHeaderView.h"

@implementation JGJAddGrounpHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkTextColor];
        [self addSubview:self.DetailLable];
    }
    return self;

}
-(UILabel *)DetailLable
{
    if (!_DetailLable) {
        _DetailLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 25)];
        _DetailLable.text = @"这些朋友也将进入群聊";
        _DetailLable.textAlignment = NSTextAlignmentCenter;
        _DetailLable.font = [UIFont systemFontOfSize:18];
        _DetailLable.textColor = [UIColor darkGrayColor];
        
    }

    return _DetailLable;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
