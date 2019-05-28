//
//  JGJTopGroupView.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTopGroupView.h"

@implementation JGJTopGroupView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLable];
    }

    return self;
}
-(UILabel *)topLable
{
    if (!_topLable) {
        _topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
        _topLable.text = @"面对面建群";
        _topLable.textColor = [UIColor whiteColor];
        _topLable.textAlignment = NSTextAlignmentCenter;
        _topLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    }

    return _topLable;

}

@end
