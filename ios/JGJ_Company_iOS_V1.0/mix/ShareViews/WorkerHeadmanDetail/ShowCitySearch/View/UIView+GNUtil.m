//
//  UIView+GNHelper.m
//  citytime
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import "UIView+GNUtil.h"

@implementation UIView (GNUtil)


+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"----"];
    [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
    for (UIView *view in [aView subviews])
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

// Start the tree recursion at level 0 with the root view
+ (NSString *) displayViews: (UIView *) aView
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView: aView atIndent:0 into:outstring];
    return outstring ;
}



-(void)setX:(CGFloat)x {
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}
-(void)setY:(CGFloat)y {
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}
-(void)setWidth:(CGFloat)width {
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
}
-(void)setHeight:(CGFloat)height {
    CGRect r = self.frame;
    r.size.height = height;
    self.frame = r;
}

- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
    
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    
    center.x = centerX;
    
    self.center = center;
    
}

- (CGFloat)centerX {
    
    return self.center.x;
    
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
    
}

- (CGFloat)centerY {
    
    return self.center.y;
    
}


-(CGFloat)right {
    return self.x + self.width;
}

-(CGFloat)bottom {
    return self.y + self.height;
}

-(CGFloat)x {
    return self.frame.origin.x;
}
-(CGFloat)y {
    return self.frame.origin.y;
}
-(CGFloat)width {
    return self.frame.size.width;
}
-(CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    
    return self.frame.size;
    
}

- (void)replaceConstraint:(NSLayoutAttribute)attribute1 onFirstItem:(id)view1 andConstraint:(NSLayoutAttribute)attribute2 onSecondItem:(id)view2 withConstant:(float)constant
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view1) && (constraint.firstAttribute == attribute1) &&
            (constraint.secondItem == view2) && (constraint.secondAttribute == attribute2)) {
            constraint.constant = constant;
            *stop = YES;
        }
    }];
}

-(void)resetConstraint:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    NSArray *constraints = [self constraints];
    for (NSLayoutConstraint *c in constraints) {
        if (c.firstAttribute == attribute && c.firstItem == self) {
            c.constant = constant;
        }
    }
}
-(void)resetHeightConstraint:(CGFloat)height {
    [self resetConstraint:NSLayoutAttributeHeight constant:height];
}
-(void)resetWdithConstraint:(CGFloat)width {
    [self resetConstraint:NSLayoutAttributeWidth constant:width];
}

+ (void)maskLayerTarget:(UIView *)target roundCorners:(UIRectCorner )roundCorners cornerRad:(CGSize)cornerSize {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:target.bounds byRoundingCorners:roundCorners cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = target.bounds;
    maskLayer.path = maskPath.CGPath;
    target.layer.mask = maskLayer;
}

/** 获取当前View的控制器对象 */
+(UIViewController *)getCurrentViewControllerWithCurView:(UIView *)curView{
    UIResponder *next = [curView nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
