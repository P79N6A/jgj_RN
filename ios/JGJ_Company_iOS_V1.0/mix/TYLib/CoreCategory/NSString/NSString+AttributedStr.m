//
//  NSString+AttributedStr.m
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "NSString+AttributedStr.h"

@implementation NSString (AttributedStr)

- (NSMutableAttributedString *)addUnderline{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange strRange = {0,[attributedStr length]};
    
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    return attributedStr;
}

- (NSMutableAttributedString *)addColor:(UIColor *)color{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange strRange = {0,self.length};
    
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    
    return attributedStr;
}

- (NSMutableAttributedString *)addColor:(UIColor *)color withRange:(NSRange )strRange{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    
    return attributedStr;
}
@end
