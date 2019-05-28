//
//  JGJChatCheckButton.m
//  mix
//
//  Created by yj on 2018/8/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatCheckButton.h"

@implementation JGJChatCheckButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self setTitle:@"查看详情" forState:UIControlStateNormal];
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 33);
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -60);
        
        [self setImage:[UIImage imageNamed:@"check_right_icon"] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    }
    
    return self;
}

@end
