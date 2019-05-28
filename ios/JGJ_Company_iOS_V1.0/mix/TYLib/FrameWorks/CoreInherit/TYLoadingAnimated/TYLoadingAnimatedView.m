
//
//  TYLoadingAnimatedView.m
//  uiimage-from-animated-gif
//
//  Created by Tony on 16/1/13.
//
//

#import "TYLoadingAnimatedView.h"

#define JLGLoadingAnimateDuration 1.2//动画的时间
@interface TYLoadingAnimatedView ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation TYLoadingAnimatedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setCircleLayer:self.redView];
    [self setCircleLayer:self.blueView];
    [self setCircleLayer:self.yellowView];
    [self startAnimation];
}

- (void)dealloc{
    [self endAnimation];
}

//设置圆角
- (void)setCircleLayer:(UIView *)circleView{
    CGFloat cornerRadius = CGRectGetWidth(circleView.frame)/2;
//    TYLog(@"frame %@ cornerRadius = %@",NSStringFromCGRect(circleView.frame),@(cornerRadius));
    circleView.layer.cornerRadius = cornerRadius;
    circleView.layer.masksToBounds = YES;
}

- (void)startAnimation{
    [self startAnimation:self.redView.layer startPoint:0 endPoint:(CGRectGetMinX(self.yellowView.frame)-CGRectGetMinX(self.redView.frame)) keyName:@"self.redView"];
    [self startAnimation:self.yellowView.layer startPoint:0 endPoint:-(CGRectGetMinX(self.yellowView.frame)-CGRectGetMinX(self.redView.frame)) keyName:@"self.yellowView"];
}

- (void)endAnimation{
    [self endAnimation:self.redView.layer keyName:@"self.redView"];
    [self endAnimation:self.yellowView.layer keyName:@"self.yellowView"];
}


-(void)startAnimation:(CALayer *)startLayer startPoint:(CGFloat )startPoint endPoint:(CGFloat )endPoint keyName:(NSString *)keyName{
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
    keyAnim.keyPath = @"transform.translation.x";
    keyAnim.values = @[@(startPoint),@(endPoint),@(startPoint)];
    
    keyAnim.repeatCount = MAXFLOAT;
    keyAnim.duration = JLGLoadingAnimateDuration;
    [startLayer addAnimation:keyAnim forKey:keyName];
}

-(void)endAnimation:(CALayer *)endLayer keyName:(NSString *)keyName{
    [endLayer removeAnimationForKey:keyName];
}

@end
