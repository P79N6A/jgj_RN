//
//  JGJDrawingLineView.m
//  mix
//
//  Created by Tony on 2018/6/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJDrawingLineView.h"
#import "LMJBezierPathCP.h"
@interface JGJDrawingLineView ()
@property (nonatomic, strong) NSMutableArray *array;
@end
@implementation JGJDrawingLineView

- (void)setUp
{
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGR];
    self.lineWidth = 1;
    self.lineColor = [UIColor blackColor];
}

- (void)pan:(UIPanGestureRecognizer *)panGR
{
    CGPoint curP = [panGR locationInView:self];
    if(panGR.state == UIGestureRecognizerStateBegan)
    {
        LMJBezierPathCP *bezier = [LMJBezierPathCP bezierPath];
        bezier.lineWidth = self.lineWidth;
        bezier.lineColor = self.lineColor;
        [self.array addObject:bezier];
        [bezier moveToPoint:curP];
    }
    
    LMJBezierPathCP *bezier = self.array.lastObject;
    if ([bezier isMemberOfClass:[LMJBezierPathCP class]]) {
        [self.array.lastObject addLineToPoint:curP];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(self.array.count == 0)  return;
    [self.array enumerateObjectsUsingBlock:^(LMJBezierPathCP *beizer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([beizer isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)beizer;
            [image drawInRect:rect];
        } else if([beizer isMemberOfClass:[LMJBezierPathCP class]]) {
            [beizer.lineColor set];
            [beizer stroke];
        }
        
    }];
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.array addObject:image];
    [self setNeedsDisplay];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (NSMutableArray *)array
{
    if(_array == nil)
    {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
