//
//  JGJCusProgress.m
//  mix
//
//  Created by yj on 17/4/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusProgress.h"

@implementation JGJCusProgress

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonset];
        
    }
    
    return self;
}

- (void)commonset {
    
    self.backgroundColor = [UIColor whiteColor];
    self.leftView = [[UIImageView alloc]init];
    self.leftView.frame = CGRectMake(0, 0, 0, _progressHeight);
    self.leftView.backgroundColor = TYColorHex(0xFDF0F0);
    
    [self insertSubview:self.leftView atIndex:0];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonset];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    
    self.leftView.frame = CGRectMake(0, 0, TYGetUIScreenWidth * progress, _progressHeight);
    
}

- (CGFloat)progressHeight {
    
    if (_progressHeight <= 50) {
        
        _progressHeight = TYGetViewH(self);
    }
    
    return _progressHeight;
}

@end
