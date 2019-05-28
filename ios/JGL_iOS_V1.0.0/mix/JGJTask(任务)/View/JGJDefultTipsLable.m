//
//  JGJDefultTipsLable.m
//  mix
//
//  Created by yj on 2018/7/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJDefultTipsLable.h"

@implementation JGJDefultTipsLable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithOffsetY:(CGFloat)offsetY tips:(NSString *)tips {
    
    if (self = [super init]) {
        
        self.textAlignment = NSTextAlignmentCenter;
        
        self.text = ![NSString isEmpty:tips] ? @"未找到对应成员" : @"未搜索到相关内容";
        
        self.textColor = AppFont999999Color;
        
        self.font = [UIFont systemFontOfSize:AppFont30Size];
        
        if ([NSString isFloatZero:offsetY]) {
            
            self.centerY = TYKey_Window.centerY - (TYGetUIScreenHeight - 216) / 2.0;
        }else {
            
            self.centerY = offsetY;
        }
        
        self.size = CGSizeMake(TYGetUIScreenWidth, 50);
        
        self.x = self.width / 2.0 - TYGetUIScreenWidth / 2.0;
    }
    
    return self;
}

@end
