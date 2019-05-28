//
//  UILabel+MEExtention.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UILabel+GNUtil.h"

#define MAX_INT 99999

@implementation UILabel (GNUtil)

- (CGSize)contentSizeFixWithSize:(CGSize)size
{
    
    self.numberOfLines = 0;
    
    CGSize contentSize = CGSizeZero;
    
    if ([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = self.textAlignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        contentSize = [self.text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName: self.font,
                                                        NSParagraphStyleAttributeName: textParagraphStyle
                                                        }
                                              context:nil].size;
    }else {
        
        //#pragma clang diagnostic push
        //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        contentSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font,NSParagraphStyleAttributeName: textParagraphStyle} context:nil].size;
        
        //#pragma clang diagnostic pop
        
    }
    
    
    return contentSize;
}

- (CGSize)contentSizeFixWithWidth:(CGFloat)width
{
    return [self contentSizeFixWithSize:CGSizeMake(width, MAX_INT)];
}

- (CGSize)contentSizeFixWithHeight:(CGFloat)height
{
    return [self contentSizeFixWithSize:CGSizeMake(MAX_INT, height)];
}

-(void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing {
    if (!text) {
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSapcing;
    style.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
    
    self.attributedText = string;
}

- (void)markText:(NSString *)t withColor:(UIColor *)c;
{
    NSString *text = self.text;
    
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
        
        self.attributedText = str;
    }
    
}

- (void)markText:(NSString *)t withFont:(UIFont *)f color:(UIColor *)c{
    NSString *text = self.text;
    
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:rangeLeft];
        [str addAttribute:NSFontAttributeName value:f range:rangeMiddle];
        [str addAttribute:NSFontAttributeName value:self.font range:rangeRight];

        self.attributedText = str;
    }

}

@end
