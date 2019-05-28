//
//  JGJCommonButton.m
//  mix
//
//  Created by yj on 2018/5/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCommonButton.h"

@implementation JGJCommonButton

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    self.alpha = highlighted ? 0.5 : 1;
    
    if (self.buttonBlock) {
        
        self.buttonBlock(self);
    }
    
    TYLog(@"highlighted =======%@", @(highlighted));
    
}

- (void)setType:(JGJCommonButtonType)type {
    
    _type = type;
    
    switch (type) {
            
        case JGJCommonDefaultType:
            
        case JGJCommonCreatProType:{
            
            [self creatProType];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)creatProType {
    
    self.frame = CGRectMake(0, 0, 100, 60);
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [self setTitle:self.buttonTitle forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"contacted_more"] forState:UIControlStateNormal];
    
}


@end
