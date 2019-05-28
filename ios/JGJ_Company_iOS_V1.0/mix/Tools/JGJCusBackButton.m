//
//  JGJCusBackButton.m
//  mix
//
//  Created by yj on 2019/1/24.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCusBackButton.h"

@implementation JGJCusBackButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setSubViewFrame];
        
    }
    
    return self;
}

- (void)setSubViewFrame {
    
    self.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    
    [self setTitle:@"返回" forState:UIControlStateNormal];
    
    [self setTitle:@"返回" forState:UIControlStateHighlighted];
    
    [self setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"barButtonItem_back_white_L"] forState:UIControlStateHighlighted];
    
    self.frame = CGRectMake(0, 0, 60, JGJLeftButtonHeight);
    
    self.adjustsImageWhenHighlighted = NO;
    
    // 让按钮内部的所有内容左对齐
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    self.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    
}
@end
