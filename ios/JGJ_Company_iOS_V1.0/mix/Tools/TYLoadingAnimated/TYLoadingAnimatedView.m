
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
    if (!_defultBool) {
        self.redView.hidden = NO;
        self.blueView.hidden = NO;
        self.yellowView.hidden = NO;
        [self setCircleLayer:self.redView];
        [self setCircleLayer:self.blueView];
        [self setCircleLayer:self.yellowView];
        [self startAnimation];
    }else{
        self.redView.hidden = YES;
        self.blueView.hidden = YES;
        self.yellowView.hidden = YES;
        [self startNodataDefultView];
    }

}

- (void)dealloc{
    [self endAnimation];
}

//设置圆角
- (void)setCircleLayer:(UIView *)circleView{
    CGFloat cornerRadius = CGRectGetWidth(circleView.frame)/2;
    circleView.layer.cornerRadius = cornerRadius;
    circleView.layer.masksToBounds = YES;
}

- (void)startAnimation{
    [self startAnimation:self.redView.layer startPoint:0 endPoint:(CGRectGetMinX(self.yellowView.frame)-CGRectGetMinX(self.redView.frame)) keyName:@"self.redView"];
    [self startAnimation:self.yellowView.layer startPoint:0 endPoint:-(CGRectGetMinX(self.yellowView.frame)-CGRectGetMinX(self.redView.frame)) keyName:@"self.yellowView"];
    
}
//无数据加载动画
- (void)startNodataDefultView
{

    [self animationgifWithGifwithView:self];

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
-(void)animationgifWithGifwithView:(UIView *)view
{
    _gifImageView = [[FLAnimatedImageView alloc] init];
    
    _gifImageView.frame                = CGRectMake(0, 0, 82, 31);
    
    _gifImageView.center = CGPointMake(view.center.x + 10,view.center.y);
    
    [view addSubview:_gifImageView];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"company" ofType:@"gif"]];
    [self animatedImageView:_gifImageView data:data];
    
//    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_gifImageView.frame) + 12, view.frame.size.width, 20)];
//    _lable.text = @"加载中...";
//    _lable.textAlignment = NSTextAlignmentCenter;
//    _lable.textColor = AppFont666666Color;
//    _lable.font = [UIFont systemFontOfSize:12];
//    [view addSubview:_lable];
}

- (void)animatedImageView:(FLAnimatedImageView *)imageView data:(NSData *)data
{
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.animatedImage   = gifImage;

}
@end
