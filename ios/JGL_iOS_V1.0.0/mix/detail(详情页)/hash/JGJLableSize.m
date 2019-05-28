//
//  JGJLableSize.m
//  JGJCompany
//
//  Created by Tony on 2017/12/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLableSize.h"

@implementation JGJLableSize

+ (float)RowWidth:(NSString *)Str andFont:(UIFont *)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width + 1;
    
    
}
+ (float)RowHeight:(NSString *)Str andFont:(UIFont *)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1;
    
    
}
+ (float)RowWidth:(NSString *)Str departLeftAndRight:(float)depart andFont:(UIFont *)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width -depart * 2, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width + 1;

}

+(float)RowHeight:(NSString *)Str departLeftAndRight:(float)depart andFont:(UIFont *)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-depart *2, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height + 1;

}

+(float)RowMoreHeight:(NSString *)Str departLeftAndRight:(float)TotalDepart andFont:(UIFont *)font andOtherStr:(NSString *)otherStr andOtherFont:(UIFont *)otherFont
{
    if ([NSString isEmpty:Str]) {
        Str = @"";
    }
    if ([NSString isEmpty: otherStr ]) {
        otherStr = @"";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-TotalDepart - [JGJLableSize RowWidth:otherStr andFont:otherFont] - 2, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height + 1;


}

+ (float)RowHeight:(NSString *)Str andFont:(UIFont *)font totalDepart:(float)depart{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-depart , 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height + 1;

    
    
}
@end
