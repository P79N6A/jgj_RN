//
//  UIButton+JGJUIButton.m
//  mix
//
//  Created by yj on 16/7/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
#import "UIButton+WebCache.h"
#import "NSString+Extend.h"
@implementation UIButton (JGJUIButton)
#pragma mark -设置不同状态的颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

- (void)setImageColor:(UIColor *)imageColor forState:(UIControlState)state {
    
    [self setImage:[UIButton imageWithColor:imageColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 扩大点击区域
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (void)setMemberPicButtonWithHeadPicStr:(NSString *)headPicStr memberName:(NSString  *)memberName memberPicBackColor:(UIColor *)memberPicBackColor {
    self.titleLabel.font = [UIFont systemFontOfSize:AppFont38Size];
    BOOL isShowLastName = [headPicStr containsString:@"headpic_m"] || [headPicStr containsString:@"headpic_f"] || [headPicStr containsString:@"nopic"] || [NSString isEmpty:headPicStr] || [headPicStr containsString:@"default"];
    
//    NSString *name = [NSString filterSpecialCharacters:memberName];
    
//3.2.0去掉过滤的特殊字符
    NSString *name = memberName;
    
    [self setTitle:nil forState:UIControlStateNormal];
    if (isShowLastName) {
        if (![NSString isEmpty:name]) {
            NSString *lastName = @"";
            if (name.length == 1) {
                lastName = [name substringFromIndex:name.length - 1];
            }else {
                lastName = [name substringFromIndex:name.length - 2];
            }
            [self setTitle:lastName forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateNormal];
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            self.backgroundColor = memberPicBackColor;
        }
    }else {
        //        NSString *headPic = [headPicStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self setTitle:nil forState:UIControlStateNormal];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JLGHttpRequest_UpLoadPicUrl,headPicStr]];
        //        [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];

        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
                NSString *lastname = @"";
                
                if (name.length == 1) {
                    
                    lastname = [name substringFromIndex:name.length - 1];
                    
                }else if(name.length >= 2) {
                    
                    lastname = [name substringFromIndex:name.length - 2];
                    
                }else {
                
                    lastname = @"";
                }
                
                [self setBackgroundImage:nil forState:UIControlStateNormal];
                
                UIColor *nameBackColor = [NSString modelBackGroundColor:lastname];
                
                self.backgroundColor = nameBackColor;
                
                [self setTitle:lastname forState:UIControlStateNormal];
                
            }
        }];
        
        
    }
}

- (void)setMemberPicButtonWithHeadPicStr:(NSString *)headPicStr memberName:(NSString  *)memberName memberPicBackColor:(UIColor *)memberPicBackColor membertelephone:(NSString *)telephone {
    self.titleLabel.font = [UIFont systemFontOfSize:AppFont38Size];
    BOOL isShowLastName = [headPicStr containsString:@"headpic_m"] || [headPicStr containsString:@"headpic_f"] || [headPicStr containsString:@"nopic"] || [NSString isEmpty:headPicStr];
    
//3.2.0去掉过滤的特殊字符
//    NSString *name = [NSString filterSpecialCharacters:memberName];
    
    NSString *name = memberName;
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (isShowLastName) {
        if (![NSString isEmpty:name]) {
            NSString *lastName = @"";
            if (name.length == 1) {
                lastName = [name substringFromIndex:name.length - 1];
            }else {
                lastName = [name substringFromIndex:name.length - 2];
            }
            [self setTitle:lastName forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateNormal];
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            self.backgroundColor = memberPicBackColor;
        }else if (telephone.length > 4) {
            
            NSString *tel= [telephone substringWithRange:NSMakeRange(telephone.length - 4, 4)];
            UIColor *backColor = [NSString modelBackGroundColor:tel];
            [self setTitle:tel forState:UIControlStateNormal];
            self.backgroundColor = backColor;
        }
    }else {

        [self setTitle:nil forState:UIControlStateNormal];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center,headPicStr]];
        
        [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
                if (![NSString isEmpty:name]) {
                    
                    NSString *lastName = @"";
                    
                    if (name.length == 1) {
                        
                        lastName = [name substringFromIndex:name.length - 1];
                        
                    }else {
                        
                        lastName = [name substringFromIndex:name.length - 2];
                        
                    }
                    [self setTitle:lastName forState:UIControlStateNormal];
                    
                    self.backgroundColor = memberPicBackColor;
                    
                }else if (telephone.length > 4) {
                    
                    NSString *tel= [telephone substringWithRange:NSMakeRange(telephone.length - 4, 4)];
                    
                    UIColor *backColor = [NSString modelBackGroundColor:tel];
                    
                    [self setTitle:tel forState:UIControlStateNormal];
                    
                    self.backgroundColor = backColor;
                }
                
            }

        }];
    }
    
}

+ (UIButton *)getLeftBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    
    [button setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"barButtonItem_back_L"] forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, JGJLeftButtonHeight);
    
    button.adjustsImageWhenHighlighted = NO;
    
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [button setTitleColor:JGJMainColor forState:UIControlStateNormal];
    
    [button setTitleColor:JGJBackHightColor forState:UIControlStateHighlighted];
    
    return button;
}

@end
