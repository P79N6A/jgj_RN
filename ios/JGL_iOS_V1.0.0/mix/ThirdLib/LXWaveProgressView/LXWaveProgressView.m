//
//  LXWaveProgressView.m
//  LXWaveProgressDemo
//
//  Created by liuxin on 16/8/1.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#define LXDefaultFirstWaveColor [UIColor colorWithRed:235/255.0 green:78/255.0 blue:78/255.0 alpha:0.5]
#define LXDefaultSecondWaveColor [UIColor colorWithRed:235/255.0 green:78/255.0 blue:78/255.0 alpha:0.8]
#define LXDefaultThirdWaveColor [UIColor colorWithRed:235/255.0 green:78/255.0 blue:78/255.0 alpha:0.35]

#import "LXWaveProgressView.h"
#import "YYWeakProxy.h"

@interface LXWaveProgressView ()
@property (nonatomic,assign)CGFloat yHeight;
@property (nonatomic,assign)CGFloat offset;
@property (nonatomic,strong)CADisplayLink * timer;
@property (nonatomic,strong)CAShapeLayer * firstWaveLayer;
@property (nonatomic,strong)CAShapeLayer * secondWaveLayer;
@property (nonatomic,strong)CAShapeLayer * thirdWaveLayer;
@end

@implementation LXWaveProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height));
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
       [self commonSet];
    }
    return self;
}

- (void)commonSet {
    self.layer.cornerRadius = TYGetViewW(self) * 0.5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 8.0f;
    
    self.waveHeight = 5.0;
    self.firstWaveColor = LXDefaultFirstWaveColor;
    self.secondWaveColor = LXDefaultSecondWaveColor;
    self.thirdWaveColor = LXDefaultThirdWaveColor;
    self.yHeight = self.bounds.size.height;
    self.speed=1.0;
    
    [self.layer addSublayer:self.firstWaveLayer];
    if (!self.isShowSingleWave) {
        [self.layer insertSublayer:self.secondWaveLayer below:self.firstWaveLayer];
        [self.layer insertSublayer:self.thirdWaveLayer below:self.secondWaveLayer];
    }
    
//    [self addSubview:self.progressLabel];
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%ld%%",[[NSNumber numberWithFloat:progress * 100] integerValue]];
    _progressLabel.textColor=[UIColor colorWithWhite:progress*1.8 alpha:1];
    self.yHeight = self.bounds.size.height * (1 - progress);

    [self stopWaveAnimation];
    [self startWaveAnimation];
}

#pragma mark -- 开始波动动画
- (void)startWaveAnimation
{
    self.timer = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(waveAnimation)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
   
}


#pragma mark -- 停止波动动画
- (void)stopWaveAnimation
{
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -- 波动动画实现
- (void)waveAnimation
{
    CGFloat waveHeight = self.waveHeight;
    if (self.progress == 0.0f || self.progress == 1.0f) {
        waveHeight = 0.f;
    }

    self.offset += self.speed;
    //第一个波纹
//    NSInteger randomY = arc4random_uniform(waveHeight);
//    TYLog(@"randomY = %@",@(randomY));

    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = waveHeight * sinf( self.offset * M_PI * 2 / self.bounds.size.width);
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width) + self.yHeight;
        CGPathAddLineToPoint(pathRef, NULL, i, orignOffY);
    }
    
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, orignOffY);
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, startOffY);
    CGPathCloseSubpath(pathRef);
    self.firstWaveLayer.path = pathRef;
    self.firstWaveLayer.fillColor = self.firstWaveColor.CGColor;
    CGPathRelease(pathRef);
    
    //第二个波纹
    if (!self.isShowSingleWave) {
        CGMutablePathRef pathRef1 = CGPathCreateMutable();
        CGFloat startOffY1 = waveHeight * sinf(self.offset * M_PI * 2 / self.bounds.size.width);
        CGFloat orignOffY1 = 0.0;
        CGPathMoveToPoint(pathRef1, NULL, 0, startOffY1);
        for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
            orignOffY1 = waveHeight * cosf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width) + self.yHeight;
            CGPathAddLineToPoint(pathRef1, NULL, i, orignOffY1);
        }
        
        CGPathAddLineToPoint(pathRef1, NULL, self.bounds.size.width, orignOffY1);
        CGPathAddLineToPoint(pathRef1, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef1, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef1, NULL, 0, startOffY1);
        CGPathCloseSubpath(pathRef1);
        self.secondWaveLayer.path = pathRef1;
        self.secondWaveLayer.fillColor = self.secondWaveColor.CGColor;
        
        CGPathRelease(pathRef1);
    }

    //第三个波纹
    if (!self.isShowSingleWave) {
        CGMutablePathRef pathRef2 = CGPathCreateMutable();
        CGFloat startOffY2 = waveHeight * sinf(self.offset * M_PI * 2 / self.bounds.size.width);
        CGFloat orignOffY2 = 0.0;
        CGPathMoveToPoint(pathRef2, NULL, 0, startOffY2);
        for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
            orignOffY2 = waveHeight * cosf(2 * M_PI_2 / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width) + self.yHeight;
            CGPathAddLineToPoint(pathRef2, NULL, i, orignOffY2);
        }
        
        CGPathAddLineToPoint(pathRef2, NULL, self.bounds.size.width, orignOffY2);
        CGPathAddLineToPoint(pathRef2, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef2, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef2, NULL, 0, startOffY2);
        CGPathCloseSubpath(pathRef2);
        self.thirdWaveLayer.path = pathRef2;
        self.thirdWaveLayer.fillColor = self.thirdWaveColor.CGColor;
        
        CGPathRelease(pathRef2);
    }
}

#pragma mark ----- INITUI ----
-(CAShapeLayer *)firstWaveLayer{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.frame = self.bounds;
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [_firstWaveLayer setLayerCornerRadius:TYGetViewW(self) / 2.0];
    }
    return _firstWaveLayer;
}

-(CAShapeLayer *)secondWaveLayer{
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.frame = self.bounds;
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [_secondWaveLayer setLayerCornerRadius:TYGetViewW(self) / 2.0];
    }
    return _secondWaveLayer;
}

-(CAShapeLayer *)thirdWaveLayer{
    if (!_thirdWaveLayer) {
        _thirdWaveLayer = [CAShapeLayer layer];
        _thirdWaveLayer.frame = self.bounds;
        _thirdWaveLayer.fillColor = _thirdWaveColor.CGColor;
        [_thirdWaveLayer setLayerCornerRadius:TYGetViewW(self) / 2.0];
    }
    return _thirdWaveLayer;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel=[[UILabel alloc] init];
        _progressLabel.text=@"0%";
        _progressLabel.frame=CGRectMake(0, 0, self.bounds.size.width, 30);
        _progressLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _progressLabel.font=[UIFont systemFontOfSize:20];
        _progressLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        _progressLabel.textAlignment=1;
    }
    return _progressLabel;
}



-(void)dealloc{
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (_firstWaveLayer) {
        [_firstWaveLayer removeFromSuperlayer];
        _firstWaveLayer = nil;
    }
    
    if (_secondWaveLayer) {
        [_secondWaveLayer removeFromSuperlayer];
        _secondWaveLayer = nil;
    }
    
    if (_thirdWaveLayer) {
        [_thirdWaveLayer removeFromSuperlayer];
        _thirdWaveLayer = nil;
    }
}


@end
