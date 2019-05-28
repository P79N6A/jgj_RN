//
//  JGJCusTopTitleView.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusTopTitleView.h"

@interface JGJCusTopTitleView ()

@end

@implementation JGJCusTopTitleView

-(void)awakeFromNib {

    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTapAction)];
    
    tap.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:tap];
    
    self.titleLable.textColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
}

+ (JGJCusTopTitleView *)cusTopTitleView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JGJCusTopTitleView" owner:self options:nil] lastObject]; ;
    
}

- (void)handleButtonTapAction{
    
    if (self.cusTopTitleViewBlock) {
        
        self.cusTopTitleViewBlock(self);
    }
    
}

@end
