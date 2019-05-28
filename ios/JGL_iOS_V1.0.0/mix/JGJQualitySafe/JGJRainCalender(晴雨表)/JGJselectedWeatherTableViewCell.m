//
//  JGJselectedWeatherTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJselectedWeatherTableViewCell.h"
#import "JGJWeatherPickerview.h"
#import "JGJWeatherImageTableViewCell.h"
#import "JGJHaveTwoTableViewCell.h"
#import "JGJHaveThreeTableViewCell.h"
#import "JGJHaveFourTableViewCell.h"
@interface JGJselectedWeatherTableViewCell ()
<
didselectweaterindexpath
>
{
    NSInteger index;
    NSInteger editeIndex;
    BOOL hadDlete;
    CAShapeLayer *upleftlayer;
    CAShapeLayer *uprightlayer;
    CAShapeLayer *downleftlayer;
    CAShapeLayer *downrightlayer;
    JGJWeatherPickerview *picker;
}
@property(nonatomic ,strong)NSMutableArray *imageArr;//装全部天气图标的数组
@property(nonatomic ,strong)NSMutableArray *SelectedimageArr;//装选择天气图标的数组
@property(nonatomic ,assign)BOOL editeweather;//是否处于编辑

@end
@implementation JGJselectedWeatherTableViewCell
-(void)clickTopbutton:(NSString *)buttonTitle
{
    if ([buttonTitle isEqualToString:@"确定"] || [buttonTitle isEqualToString:@"关闭"]) {
        
        _upleftimageView.hidden = YES;
        _uprightimageView.hidden =YES;
        _downleftimageView.hidden =YES;
        _downrightimageView.hidden = YES;
    }else{
        _WeatherArr = [NSMutableArray array];
        _SelectedimageArr = [NSMutableArray array];
        _firstnumLable.text = @"1";
        _secondnumLable.text = @"2";
        _thrednumLable.text = @"3";
        _fournumLable.text = @"4";
        _firsttitlelable.text = _secondtitlelable.text = _thirdtitlelable.text = _fourtitlelable.text = @"天气";
        index = 1;
        editeIndex = 1;
        
        _fournumLable.textColor =_thrednumLable.textColor=_secondnumLable.textColor = _firstnumLable.textColor = AppFontEB4E4EColor;
        _fourtitlelable.textColor=_thirdtitlelable.textColor = _secondtitlelable.textColor = _firsttitlelable.textColor = AppFont999999Color;
        [_tableview reloadData];
        _upleftView.layer.borderColor =_uprightView.layer.borderColor =_downleftView.layer.borderColor =_downrightView.layer.borderColor = AppFontfdf0f0Color.CGColor;
        
        upleftlayer.strokeColor =  uprightlayer.strokeColor = downleftlayer.strokeColor = downrightlayer.strokeColor =AppFontfdf0f0Color.CGColor;
        
        _upleftimageView.hidden = NO;
        _uprightimageView.hidden =YES;
        _downleftimageView.hidden =YES;
        _downrightimageView.hidden = YES;
        [self eidteTapViewLableText];
    }
}


-(void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content
{
    
}
-(void)didMoreselectweaterevent:(NSIndexPath *)indexpath andstr:(NSMutableArray *)selectArr
{
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadView];
}
-(void)loadView{
    
    [self.contentView addSubview:self.centerPlaceView];
    [self.contentView addSubview:self.centerView];
    [self.contentView addSubview:self.upleftView];
    [self.contentView addSubview:self.uprightView];
    [self.contentView addSubview:self.downleftView];
    [self.contentView addSubview:self.downrightView];
    [self.contentView addSubview:self.upleftimageView];
    [self.contentView addSubview:self.uprightimageView];
    [self.contentView addSubview:self.downleftimageView];
    [self.contentView addSubview:self.downrightimageView];
    _upleftimageView.hidden = YES;
    _uprightimageView.hidden = YES;
    _downleftimageView.hidden = YES;
    _downrightimageView.hidden = YES;
}

-(void)setEditeRainCalender:(BOOL)editeRainCalender
{
    if (!editeRainCalender) {
        [self tapselectedWeather:self.upleftView.gestureRecognizers.firstObject];
        
    }
    
}
-(UIImageView *)centerPlaceView
{
    
    if (!_centerPlaceView) {
        _centerPlaceView = [UIImageView new];
        [_centerPlaceView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth *0.3 + 9,  TYGetUIScreenWidth *0.3 + 9)];
        _centerPlaceView.image = [UIImage imageNamed:@"shadow_round"];

        _centerPlaceView.center = CGPointMake(TYGetUIScreenWidth/2  , 117);
        _centerPlaceView.backgroundColor = [UIColor whiteColor];
        _centerPlaceView.layer.masksToBounds = YES;
        _centerPlaceView.layer.cornerRadius = CGRectGetWidth(_centerPlaceView.frame)/2;
//        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.15 + 6  ,TYGetUIScreenWidth *0.15 + 6 )
//                                                            radius:TYGetUIScreenWidth *0.15 + 6
//                                                        startAngle:0
//                                                          endAngle:M_PI * 2
//                                                         clockwise:YES];
//        /* path = [UIBezierPath bezierPath];
//         [path moveToPoint:(CGPoint){100,100}];
//         [path addLineToPoint:(CGPoint){200,100}];
//         [path addLineToPoint:(CGPoint){250,150}];
//         [path addLineToPoint:(CGPoint){200,200}];
//         [path addLineToPoint:(CGPoint){100,200}];
//         [path addLineToPoint:(CGPoint){50,150}];
//         [path closePath];
//         [path stroke];*/
//        // 创建一个shapeLayer
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.frame         = _centerPlaceView.bounds;                // 与showView的frame一致
//        layer.strokeColor   = [UIColor blackColor].CGColor;   // 边缘线的颜色
//        
//        layer.fillColor     = AppFontf1f1f1Color.CGColor;   // 闭环填充的颜色
//        //layer.lineCap       = kCALineCapButt;               // 边缘线的类型
//        layer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
//        layer.lineWidth     = 12.0f;                           // 线条宽度
//        layer.strokeStart   = 0.0f;
//        layer.strokeEnd     = 1;
//        layer.opacity = .15;
//
//        [_centerPlaceView.layer addSublayer:layer];
    }
    return _centerPlaceView;
}
- (UIView *)centerView
{
    
    if (!_centerView) {
        
        _centerView = [UIView new];
        [_centerView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth *0.3,  TYGetUIScreenWidth *0.3)];
        _centerView.center = CGPointMake(TYGetUIScreenWidth/2, 117);
        _centerView.backgroundColor = AppFontf1f1f1Color;
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = CGRectGetWidth(_centerView.frame)/2;
        
        //        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.15 ,TYGetUIScreenWidth *0.15)
        //                                                            radius:TYGetUIScreenWidth *0.15
        //                                                        startAngle:0
        //                                                          endAngle:M_PI * 2
        //                                                         clockwise:YES];
        //        /* path = [UIBezierPath bezierPath];
        //
        //         [path moveToPoint:(CGPoint){100,100}];
        //         [path addLineToPoint:(CGPoint){200,100}];
        //         [path addLineToPoint:(CGPoint){250,150}];
        //         [path addLineToPoint:(CGPoint){200,200}];
        //         [path addLineToPoint:(CGPoint){100,200}];
        //         [path addLineToPoint:(CGPoint){50,150}];
        //         [path closePath];
        //         [path stroke];*/
        //        // 创建一个shapeLayer
        //        CAShapeLayer *layer = [CAShapeLayer layer];
        //        layer.frame         = _centerView.bounds;                // 与showView的frame一致
        //        layer.strokeColor   = AppFontf1f1f1Color.CGColor;   // 边缘线的颜色
        //        layer.fillColor     = AppFontf1f1f1Color.CGColor;   // 闭环填充的颜色
        //        //layer.lineCap       = kCALineCapButt;               // 边缘线的类型
        //        layer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        //        layer.lineWidth     = 6.0f;                           // 线条宽度
        //        layer.strokeStart   = 0.0f;
        //        layer.strokeEnd     = 1;
        //        [_centerView.layer addSublayer:layer];
        [_centerView addSubview:self.tableview];
        
        
    }
    return _centerView;
}
- (UIView *)upleftView
{
    if (!_upleftView) {
        
        
        
        _upleftView = [UIView new];
        [_upleftView setFrame:CGRectMake(TYGetUIScreenWidth/2 - TYGetUIScreenWidth *0.3/2  - TYGetUIScreenWidth *0.165 - 30, 35, TYGetUIScreenWidth *0.165,  TYGetUIScreenWidth *0.165)];
        //        [_upleftView setFrame:CGRectMake(self.contentView.center.x - TYGetUIScreenWidth *0.3/2  - TYGetUIScreenWidth *0.165 - 40, 35, TYGetUIScreenWidth *0.165,  TYGetUIScreenWidth *0.165)];
        
        _upleftView.backgroundColor = AppFontfafafaColor;
        _upleftView.tag = 1;
        _upleftView.layer.borderWidth = 1;
        //        _upleftView.layer.cornerRadius =TYGetUIScreenWidth *0.165/2;
        _upleftView.layer.borderColor = AppFontfdf0f0Color.CGColor;
        //        _upleftView.layer.borderColor = [UIColor redColor].CGColor;
        
        //切尖尖
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_upleftView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake( TYGetUIScreenWidth *0.165/2 +3 ,  TYGetUIScreenWidth *0.165/2 +3)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _upleftView.bounds;
        maskLayers.path = maskPaths.CGPath;
        _upleftView.layer.mask = maskLayers;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.165/2, TYGetUIScreenWidth *0.165/2)
                                                            radius:TYGetUIScreenWidth *0.165/2 - 0.28
                                                        startAngle:0.031 *M_PI
                                                          endAngle:M_PI / 2
                                                         clockwise:NO];
        
        
        // 创建一个shapeLayer
        upleftlayer = [CAShapeLayer layer];
        upleftlayer.frame         = _upleftView.bounds;                // 与showView的frame一致
        
        upleftlayer.strokeColor   = AppFontfdf0f0Color.CGColor;   // 边缘线的颜色
        
        upleftlayer.fillColor     = AppFontfafafaColor.CGColor;   // 闭环填充的颜色
        //       upleftlayer.lineCap       = kCALineCapButt;               // 边缘线的类型
        upleftlayer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        upleftlayer.lineWidth     = 1.0f;                           // 线条宽度
        upleftlayer.strokeStart   = 0.0f;
        upleftlayer.strokeEnd     = 1;
        [_upleftView.layer addSublayer:upleftlayer];
        
        [_upleftView addSubview:self.firsttitlelable];
        
        //        self.firstnumLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 22, TYGetUIScreenWidth *0.165 - 10, 22)];
        //        self.firstnumLable.textColor = AppFontEB4E4EColor;
        //        self.firstnumLable.textAlignment = NSTextAlignmentCenter;
        ////      _firstnumLable.font = [UIFont fontWithName:@"Impact" size:21];
        //        self.firstnumLable.text = @"1";
        //        self.firstnumLable.font = [UIFont fontWithName:@"Impact" size:21];
        [_upleftView addSubview: self.firstnumLable];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselectedWeather:)];
        [_upleftView addGestureRecognizer:tap];
    }
    return _upleftView;
}
-(UILabel *)firstnumLable
{
    if (!_firstnumLable) {
        _firstnumLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 22, TYGetUIScreenWidth *0.165 - 10, 22)];
        _firstnumLable.textColor = AppFontEB4E4EColor;
        _firstnumLable.textAlignment = NSTextAlignmentCenter;
        _firstnumLable.text = @"1";
        _firstnumLable.font = [UIFont fontWithName:@"Impact" size:21];
    }
    return _firstnumLable;
}
- (UIView *)uprightView
{
    if (!_uprightView) {
        _uprightView = [UIView new];
        [_uprightView setFrame:CGRectMake(TYGetUIScreenWidth/2 +TYGetUIScreenWidth *0.3/2 +30 , 35, TYGetUIScreenWidth *0.165,  TYGetUIScreenWidth *0.165)];
        _uprightView.tag = 2;
        
        _uprightView.backgroundColor = AppFontfafafaColor;;
        _uprightView.layer.borderWidth = 1;
        _uprightView.layer.borderColor = AppFontfdf0f0Color.CGColor;
        //        _uprightView.layer.masksToBounds = YES;
        //        _uprightView.layer.cornerRadius = CGRectGetWidth(_uprightView.frame)/2;
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_uprightView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake( TYGetUIScreenWidth *0.165/2 + 6,  TYGetUIScreenWidth *0.165/2 + 6)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _uprightView.bounds;
        maskLayers.path = maskPaths.CGPath;
        _uprightView.layer.mask = maskLayers;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.165/2, TYGetUIScreenWidth *0.165/2)
                                                            radius:TYGetUIScreenWidth *0.165/2 - 0.28
                                                        startAngle:0.5*M_PI
                                                          endAngle:M_PI
                                                         clockwise:NO];
        
        uprightlayer = [CAShapeLayer layer];
        uprightlayer.frame         = _uprightView.bounds;                // 与showView的frame一致
        uprightlayer.strokeColor   = AppFontfdf0f0Color.CGColor;   // 边缘线的颜色
        
        uprightlayer.fillColor     = AppFontfafafaColor.CGColor;   // 闭环填充的颜色
        //layer.lineCap       = kCALineCapButt;               // 边缘线的类型
        uprightlayer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        uprightlayer.lineWidth     = 1.0f;                           // 线条宽度
        uprightlayer.strokeStart   = 0.0f;
        uprightlayer.strokeEnd     = 1;
        [_uprightView.layer addSublayer:uprightlayer];
        [_uprightView addSubview:self.secondtitlelable];
        _secondnumLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 22, TYGetUIScreenWidth *0.165 - 10, 22)];
        _secondnumLable.font = [UIFont fontWithName:@"Impact" size:21];
        
        _secondnumLable.textColor = AppFontEB4E4EColor;
        _secondnumLable.textAlignment = NSTextAlignmentCenter;
        _secondnumLable.text = @"2";
        [_uprightView addSubview:_secondnumLable];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselectedWeather:)];
        [_uprightView addGestureRecognizer:tap];
    }
    return _uprightView;
}



- (UIView *)downleftView
{
    if (!_downleftView) {
        _downleftView = [UIView new];
        [_downleftView setFrame:CGRectMake(TYGetUIScreenWidth/2 - TYGetUIScreenWidth *0.3/2  - TYGetUIScreenWidth *0.165 - 30, CGRectGetMaxY(_upleftView.frame) + 40, TYGetUIScreenWidth *0.165,  TYGetUIScreenWidth *0.165)];
        _downleftView.backgroundColor = AppFontfafafaColor;;
        //        _downleftView.layer.masksToBounds = YES;
        //        _downleftView.layer.cornerRadius = CGRectGetWidth(_downleftView.frame)/2;
        _downleftView.layer.borderWidth = 1;
        _downleftView.layer.borderColor = AppFontfdf0f0Color.CGColor;
        
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_downleftView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake( TYGetUIScreenWidth *0.0825,  TYGetUIScreenWidth *0.0825)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _downleftView.bounds;
        maskLayers.path = maskPaths.CGPath;
        _downleftView.layer.mask = maskLayers;
        
        
        
        //        UIBezierPath *maskPathss = [UIBezierPath bezierPathWithRoundedRect:_downleftView.bounds byRoundingCorners: UIRectCornerto cornerRadii:CGSizeMake( 5,  5)];
        //        CAShapeLayer *maskLayersd = [[CAShapeLayer alloc] init];
        //        maskLayersd.frame = _downleftView.bounds;
        //        maskLayersd.path = maskPathss.CGPath;
        //        _downleftView.layer.mask = maskLayersd;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.165/2, TYGetUIScreenWidth *0.165/2)
                                                            radius:TYGetUIScreenWidth *0.165/2  - 0.28
                                                        startAngle:1.5*M_PI
                                                          endAngle:0.03 * M_PI
                                                         clockwise:NO];
        _downleftView.tag = 3;
        
        /* path = [UIBezierPath bezierPath];
         
         [path moveToPoint:(CGPoint){100,100}];
         [path addLineToPoint:(CGPoint){200,100}];
         [path addLineToPoint:(CGPoint){250,150}];
         [path addLineToPoint:(CGPoint){200,200}];
         [path addLineToPoint:(CGPoint){100,200}];
         [path addLineToPoint:(CGPoint){50,150}];
         [path closePath];
         [path stroke];*/
        // 创建一个shapeLayer
        downleftlayer = [CAShapeLayer layer];
        downleftlayer.frame         = _downleftView.bounds;                // 与showView的frame一致
        downleftlayer.strokeColor   = AppFontfdf0f0Color.CGColor;   // 边缘线的颜色
        
        downleftlayer.fillColor     = AppFontfafafaColor.CGColor;   // 闭环填充的颜色
        //layer.lineCap       = kCALineCapButt;               // 边缘线的类型
        downleftlayer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        downleftlayer.lineWidth     = 1.2f;                           // 线条宽度
        downleftlayer.strokeStart   = 0.0f;
        downleftlayer.strokeEnd     = 1;
        [_downleftView.layer addSublayer:downleftlayer];
        [_downleftView addSubview:self.thirdtitlelable];
        _thrednumLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 22, TYGetUIScreenWidth *0.165 - 10, 22)];
        _thrednumLable.font = [UIFont fontWithName:@"Impact" size:21];
        
        _thrednumLable.textColor = AppFontEB4E4EColor;
        _thrednumLable.textAlignment = NSTextAlignmentCenter;
        _thrednumLable.text = @"3";
        [_downleftView addSubview:_thrednumLable];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselectedWeather:)];
        [_downleftView addGestureRecognizer:tap];
    }
    return _downleftView;
}
-(UIView *)downrightView
{
    if (!_downrightView) {
        _downrightView = [UIView new];
        [_downrightView setFrame:CGRectMake(TYGetUIScreenWidth/2 +TYGetUIScreenWidth *0.3/2 +30  , CGRectGetMaxY(_upleftView.frame) + 40, TYGetUIScreenWidth *0.165,  TYGetUIScreenWidth *0.165)];
        _downrightView.tag = 4;
        _downrightView.backgroundColor = AppFontfafafaColor;;
        //        _downrightView.layer.masksToBounds = YES;
        //        _downrightView.layer.cornerRadius = CGRectGetWidth(_downrightView.frame)/2;
        _downrightView.layer.borderWidth = 1;
        _downrightView.layer.borderColor = AppFontfdf0f0Color.CGColor;
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_downrightView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake( TYGetUIScreenWidth *0.165/2 - 6,  TYGetUIScreenWidth *0.165/2 - 6)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _downrightView.bounds;
        maskLayers.path = maskPaths.CGPath;
        _downrightView.layer.mask = maskLayers;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TYGetUIScreenWidth *0.165/2, TYGetUIScreenWidth *0.165/2)
                                                            radius:TYGetUIScreenWidth *0.165/2 - 0.28
                                                        startAngle:M_PI
                                                          endAngle:M_PI * 1.5
                                                         clockwise:NO];
        
        /* path = [UIBezierPath bezierPath];
         
         [path moveToPoint:(CGPoint){100,100}];
         [path addLineToPoint:(CGPoint){200,100}];
         [path addLineToPoint:(CGPoint){250,150}];
         [path addLineToPoint:(CGPoint){200,200}];
         [path addLineToPoint:(CGPoint){100,200}];
         [path addLineToPoint:(CGPoint){50,150}];
         [path closePath];
         [path stroke];*/
        // 创建一个shapeLayer
        downrightlayer = [CAShapeLayer layer];
        downrightlayer.frame         = _downrightView.bounds;                // 与showView的frame一致
        downrightlayer.strokeColor   = AppFontfdf0f0Color.CGColor;   // 边缘线的颜色
        
        downrightlayer.fillColor     = AppFontfafafaColor.CGColor;   // 闭环填充的颜色
        //layer.lineCap       = kCALineCapButt;               // 边缘线的类型
        downrightlayer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        downrightlayer.lineWidth     = 1.0f;                           // 线条宽度
        downrightlayer.strokeStart   = 0.0f;
        downrightlayer.strokeEnd     = 1;
        [_downrightView.layer addSublayer:downrightlayer];
        [_downrightView addSubview:self.fourtitlelable];
        _fournumLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 22, TYGetUIScreenWidth *0.165 - 10, 22)];
        _fournumLable.font = [UIFont fontWithName:@"Impact" size:21];
        
        _fournumLable.textColor = AppFontEB4E4EColor;
        _fournumLable.textAlignment = NSTextAlignmentCenter;
        _fournumLable.text = @"4";
        
        [_downrightView addSubview:_fournumLable];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselectedWeather:)];
        [_downrightView addGestureRecognizer:tap];
        
    }
    return _downrightView;
}
- (UIImageView *)upleftimageView
{
    if (!_upleftimageView) {
        _upleftimageView = [UIImageView new];
        [_upleftimageView setFrame:CGRectMake(0, 0, CGRectGetWidth(_upleftView.frame) +13.65, CGRectGetHeight(_upleftView.frame) + 13.65)];
        _upleftimageView.center = _upleftView.center;
        [_upleftimageView setImage:[UIImage imageNamed:@"shinni1"]];
        
    }
    return _upleftimageView;
    
}
- (UIImageView *)uprightimageView
{
    if (!_uprightimageView) {
        _uprightimageView = [UIImageView new];
        [_uprightimageView setFrame:CGRectMake(0, 0, CGRectGetWidth(_uprightView.frame) +13.65, CGRectGetHeight(_uprightView.frame) + 13.65)];
        _uprightimageView.center = _uprightView.center;
        [_uprightimageView setImage:[UIImage imageNamed:@"shinni2"]];
        
    }
    return _uprightimageView;
    
    
}
- (UIImageView *)downleftimageView
{
    if (!_downleftimageView) {
        _downleftimageView = [UIImageView new];
        [_downleftimageView setFrame:CGRectMake(0, 0, CGRectGetWidth(_downleftView.frame) +13.65, CGRectGetHeight(_downleftView.frame) + 13.65)];
        _downleftimageView.center = _downleftView.center;
        [_downleftimageView setImage:[UIImage imageNamed:@"shinni3"]];    }
    return _downleftimageView;
    
}
- (UIImageView *)downrightimageView
{
    if (!_downrightimageView) {
        _downrightimageView = [UIImageView new];
        [_downrightimageView setFrame:CGRectMake(0, 0, CGRectGetWidth(_downrightView.frame) +13.65, CGRectGetHeight(_downrightView.frame) + 13.65)];
        _downrightimageView.center = _downrightView.center;
        [_downrightimageView setImage:[UIImage imageNamed:@"shinni4"]];
    }
    return _downrightimageView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.centerView];
        [self.contentView addSubview:self.upleftView];
        [self.contentView addSubview:self.uprightView];
        [self.contentView addSubview:self.downleftView];
        [self.contentView addSubview:self.downrightView];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(UILabel *)firsttitlelable
{
    if (!_firsttitlelable) {
        _firsttitlelable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, TYGetUIScreenWidth *0.165 - 10, 10)];
        _firsttitlelable.text = @"天气";
        _firsttitlelable.font = [UIFont systemFontOfSize:10];
        _firsttitlelable.textColor = AppFont999999Color;
        _firsttitlelable.textAlignment = NSTextAlignmentCenter;
    }
    return _firsttitlelable;
    
}
-(UILabel *)secondtitlelable
{
    if (!_secondtitlelable) {
        _secondtitlelable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, TYGetUIScreenWidth *0.165 - 10, 10)];
        _secondtitlelable.text = @"天气";
        _secondtitlelable.font = [UIFont systemFontOfSize:10];
        _secondtitlelable.textColor = AppFont999999Color;
        _secondtitlelable.textAlignment = NSTextAlignmentCenter;
    }
    return _secondtitlelable;
    
    
}
-(UILabel *)thirdtitlelable
{
    if (!_thirdtitlelable) {
        _thirdtitlelable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, TYGetUIScreenWidth *0.165 - 10, 10)];
        _thirdtitlelable.text = @"天气";
        _thirdtitlelable.font = [UIFont systemFontOfSize:10];
        _thirdtitlelable.textColor = AppFont999999Color;
        _thirdtitlelable.textAlignment = NSTextAlignmentCenter;
    }
    return _thirdtitlelable;
}
-(UILabel *)fourtitlelable
{
    if (!_fourtitlelable) {
        _fourtitlelable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, TYGetUIScreenWidth *0.165 - 10, 10)];
        _fourtitlelable.text = @"天气";
        _fourtitlelable.font = [UIFont systemFontOfSize:10];
        _fourtitlelable.textColor = AppFont999999Color;
        _fourtitlelable.textAlignment = NSTextAlignmentCenter;
    }
    return _fourtitlelable;
}
-(void)tapselectedWeather:(UITapGestureRecognizer *)guestrue
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapCalender)]) {
        [self.delegate tapCalender];
    }
    if (![self tapIndexView:guestrue.view.tag]){
        return;
    }
    index = guestrue.view.tag;
    editeIndex = guestrue.view.tag;
    if (index <= _WeatherArr.count) {
        _editeweather = YES;
    }else{
        
        _editeweather = NO;
    }
    [self tapIndexView:guestrue.view.tag];
    
    if (_WeatherArr.count >0) {
        switch (index) {
            case 1:
                _upleftimageView.hidden = NO;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                break;
            case 2:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = NO;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                
                break;
            case 3:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = NO;
                _downrightimageView.hidden = YES;
                
                break;
            case 4:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = NO;
                
                break;
            default:
                break;
        }
    }else{
        _upleftimageView.hidden = NO;
    }
    
    if (![self tapIndexView:guestrue.view.tag]) {
        
    }else{
        if (picker) {
            [picker removeFromSuperview];
            picker = nil;
        }
        picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 260, TYGetUIScreenWidth, 260)];
        picker.delegate = self;
        picker.allowsMultipleSelections = YES;
        
        //    picker.allowsMultipleSelections = NO;
        picker.Nshadow = YES;
        [picker showWeatherPickerView];
        picker.topname = @"选择天气";
        picker.titlearray = [NSMutableArray arrayWithObjects:@"晴",@"阴",@"多云",@"雨",@"雪",@"雾",@"霾",@"冰冻",@"风",@"停电",@"不选", nil];
        picker.imagarray = [NSMutableArray arrayWithObjects:@"record_popup_claer",@"record_popup_overcast",@"record_popup_cloudy",@"record_popup_rain",@"record_popup_snow",@"record_popup_fog",@"record_popup_haze",@"record_popup_frost",@"record_popup_wind",@"record_popup_power-outage",@"record_popup_nothing", nil];
        _imageArr = [NSMutableArray arrayWithArray:picker.imagarray];
    }
}

- (void)initarr{
    if (!_WeatherArr) {
        _WeatherArr = [NSMutableArray array];
    }
    if (!_SelectedimageArr) {
        _SelectedimageArr = [NSMutableArray array];
    }
}
#pragma mark -替换yi经选中了的图片
-(void)insertOrAddimageToArr:(NSIndexPath *)indexpath andindexView:(NSInteger)Aindex andContent:(NSString *)content
{
    //indexpath为选择的图标为第几个 aindex 为点了第几个图
    if ([content isEqualToString:@"不选"] &&_SelectedimageArr.count >= Aindex) {
        [_SelectedimageArr removeObjectAtIndex:Aindex - 1];
        [self repeatloadViewand:index];
    }else{
        if (![content isEqualToString:@"不选"]) {
            if (_SelectedimageArr.count >= Aindex ) {
                [_SelectedimageArr replaceObjectAtIndex:Aindex - 1 withObject:_imageArr[indexpath.row]];
            }else{
                [_SelectedimageArr insertObject:_imageArr[indexpath.row] atIndex:_SelectedimageArr.count];
            }
        }
    }
}
//单选
- (void)didselectweaterevent:(NSIndexPath *)indexpath andArr:(NSString *)content
{
    [self initarr];
    //        if ((_WeatherArr.count == 4 && ![content isEqualToString:@"不选"])) {
    //            return;
    //        }
    if ([content isEqualToString:@"不选"]) {
        [self removePreWeather];
        
    }
    if ([content isEqualToString:@"不选"] && _WeatherArr.count >= index) {
        [_WeatherArr removeObjectAtIndex:index - 1];
        [self repeatloadViewand:index];
    }else{
        if (![content isEqualToString:@"不选"]) {
            [_WeatherArr insertObject:content atIndex:_WeatherArr.count];
        }
    }
    if (![content isEqualToString:@"不选"]) {
        switch (index) {
            case 1:
                _firstnumLable.text = content;
                _firsttitlelable.text = @"";
                break;
            case 2:
                _secondnumLable.text = content;
                _secondtitlelable.text = @"";
                break;
            case 3:
                _thrednumLable.text = content;
                _thirdtitlelable.text = @"";
                break;
            case 4:
                _fournumLable.text = content;
                _fourtitlelable.text = @"";
                break;
            default:
                break;
        }
    }
    [self insertOrAddimageToArr:indexpath andindexView:index andContent:content];
    
    
    [self acordingWeatherStrretrunColor:content];
    //已经
    //删除选择的天气
    [_tableview reloadData];
}
#pragma mark -天气多选返回数组
-(void)didMoreselectweaterevent:(NSIndexPath *)indexpath andArr:(NSMutableArray *)selectArr andDelete:(BOOL)del
{
    
    if (del && _WeatherArr.count <=0 ) {
        return;
    }
    if (del) {
        if (editeIndex > _WeatherArr.count ) {
            //        editeIndex --;
        }
    }else{
        editeIndex ++;
    }
    //    if (selectArr.count) {//点击相同的返回一个空的
    if (!del) {
        if (selectArr.count) {
            if (!_WeatherArr || (_WeatherArr.count <= 0 && selectArr.count == 1)) {
                //此处是重新编辑
                _WeatherArr = [[NSMutableArray alloc]initWithArray:selectArr];
            }else{
                if (index>=0 ) {
                    if (_editeweather && editeIndex-1 != index) {
                        [_WeatherArr insertObject:selectArr.lastObject atIndex:editeIndex - 2];
                    }else{
                        if (_WeatherArr.count < index ) {
                            if (index - _WeatherArr.count == 1) {
                                [_WeatherArr addObject:selectArr.lastObject];
                                
                            }else{
                                [_WeatherArr insertObject:selectArr.lastObject atIndex:_WeatherArr.count - 1];
                            }
                        }else{
                            
                            if (_editeweather && hadDlete) {
                                [_WeatherArr insertObject:selectArr.lastObject atIndex:editeIndex - 2];
                            }else{
                                [_WeatherArr replaceObjectAtIndex:index - 1 withObject:selectArr.lastObject];
                            }
                        }
                    }
                }else{
                    if (selectArr.count) {
                        if (_editeweather) {
                            [_WeatherArr insertObject:selectArr.lastObject atIndex:editeIndex - 2];
                            
                        }else{
                            [_WeatherArr addObject:selectArr.lastObject];
                        }
                    }
                }
            }
        }
    }else {
        if (_WeatherArr.count ) {
            if (_WeatherArr.count<index) {
                return;
            }//后续点击 不连续删除
            if (index >0 && index<=_WeatherArr.count) {
                [_WeatherArr removeObjectAtIndex:index - 1];
            }else{
                [_WeatherArr removeLastObject];
            }
        }
    }
    [self eidteTapViewLableText];//输入框
    [self selelectIndexpath:indexpath andHadselectArr:selectArr anddel:del];
    [_tableview reloadData];
    if (!del) {
        index = -1;
        hadDlete = NO;
    }else{
        hadDlete = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWeatherWithWeatherArr:)]) {
        [self.delegate selectWeatherWithWeatherArr:_WeatherArr];
    }
    
}
//}


#pragma mark - 多选的数组处理
- (void)selelectIndexpath:(NSIndexPath *)indexpath andHadselectArr:(NSMutableArray *)selceArr anddel:(BOOL)del
{
    
    if (!_SelectedimageArr) {
        _SelectedimageArr = [[NSMutableArray alloc]init];
    }
    if (del && _SelectedimageArr.count) {
        if (index > 0 && _SelectedimageArr.count >=index) {
            [_SelectedimageArr removeObjectAtIndex:index - 1];
        }else{
            [_SelectedimageArr removeLastObject];
        }
        //移除替换数据
    }else if(!del ){
        
        if ( index > 0 && _SelectedimageArr.count > 0) {
            
            if (_editeweather  && editeIndex-1 != index) {
                [_SelectedimageArr insertObject:_imageArr[indexpath.row] atIndex:editeIndex - 2];
                
            }else{
                //此处点击已经有的数据
                if (_SelectedimageArr.count < index) {
                    //连续删除在添加天气
                    [_SelectedimageArr insertObject:_imageArr[indexpath.row] atIndex:_SelectedimageArr.count];
                    
                }else{
                    if (_editeweather && hadDlete) {
                        [_SelectedimageArr insertObject:_imageArr[indexpath.row] atIndex:editeIndex - 2];
                    }else{
                        [_SelectedimageArr replaceObjectAtIndex:index - 1 withObject:_imageArr[indexpath.row]];
                    }
                }
            }
        }else{
            
            if (_editeweather) {
                [_SelectedimageArr insertObject:_imageArr[indexpath.row] atIndex:editeIndex - 2];
                
            }else{
                
                [_SelectedimageArr addObject:_imageArr[indexpath.row]];
            }
        }
    }
    
    [self acordingWeatherStrretrunColor:picker.titlearray[indexpath.row]];
    if (_SelectedimageArr.count == 4) {
        if (picker) {
            [picker removeview];
            
        }
        _upleftimageView.hidden = YES;
        _uprightimageView.hidden = YES;
        _downleftimageView.hidden = YES;
        _downrightimageView.hidden = YES;
        
    }
}
-(NSMutableArray *)WeatherArr
{
    if (!_WeatherArr) {
        _WeatherArr = [NSMutableArray array];
    }
    return _WeatherArr;
}

#pragma mark -切换年月
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_centerView.frame), CGRectGetHeight(_centerView.frame) )];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = AppFontf1f1f1Color;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableview;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_SelectedimageArr.count == 1) {
        JGJWeatherImageTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJWeatherImageTableViewCell" owner:nil options:nil]firstObject];
        proCell.imageArr = _SelectedimageArr;
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else if (_SelectedimageArr.count == 2){
        JGJHaveTwoTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHaveTwoTableViewCell" owner:nil options:nil]firstObject];
        proCell.imageArr = _SelectedimageArr;
        
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else if (_SelectedimageArr.count == 3){
        JGJHaveThreeTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHaveThreeTableViewCell" owner:nil options:nil]firstObject];
        proCell.imageArr = _SelectedimageArr;
        
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else if (_SelectedimageArr.count == 4){
        JGJHaveFourTableViewCell *proCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJHaveFourTableViewCell" owner:nil options:nil]firstObject];
        proCell.imageArr = _SelectedimageArr;
        
        proCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return proCell;
    }else{
        
        return 0;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_SelectedimageArr.count) {
        return 1;
        
    }else{
        
        return 0;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return TYGetUIScreenWidth *0.3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeWeatherShowAler)]) {
        
        [self.delegate removeWeatherShowAler];
        
    }
}
//删除天气后冲洗太年纪以前的视图
- (void)repeatloadViewand:(NSInteger )indexpath
{
}
#pragma mark -排除前面是不是已经选择了天气 挨着选择天气
- (bool)tapIndexView:(NSInteger)tapindex
{
    if (tapindex != 0) {
        if (tapindex - _SelectedimageArr.count > 1 && tapindex - _SelectedimageArr.count < 5 ) {
            [TYShowMessage showError:@"请依次选择天气"];
            return NO;
        }
    }
    if (tapindex == 0) {
    }else{
        
    }
    return YES;
}
- (void)acordingWeatherStrretrunColor:(NSString *)str
{
    
    NSString *selectStr = str;
    for (int numindex = 1; numindex <= _SelectedimageArr.count; numindex ++) {
        UIView *baseview;
        CAShapeLayer *shaplayer;
        UILabel *lable;
        //以前只是少秒一种天气  现在天气可以插入输入  所以最好是遍历服颜色
        switch (numindex) {
            case 1:
                baseview = _upleftView;
                shaplayer = upleftlayer;
                lable = _firstnumLable;
                break;
            case 2:
                baseview = _uprightView;
                shaplayer = uprightlayer;
                lable = _secondnumLable;
                
                break;
            case 3:
                baseview = _downleftView;
                shaplayer = downleftlayer;
                lable = _thrednumLable;
                
                break;
            case 4:
                baseview = _downrightView;
                shaplayer = downrightlayer;
                lable = _fournumLable;
                
                
                break;
            default:
                break;
        }
        
        
        str = _WeatherArr[numindex-1];
        
        if ([str isEqualToString:@"晴"]) {
            baseview.layer.borderColor = AppFontF57665Color.CGColor;
            
            shaplayer.strokeColor = AppFontF57665Color.CGColor;
            lable.textColor = AppFontF57665Color;
        }else if ([str isEqualToString:@"阴"])
        {
            baseview.layer.borderColor = AppFont9EAEC6Color.CGColor;
            shaplayer.strokeColor = AppFont9EAEC6Color.CGColor;
            lable.textColor = AppFont9EAEC6Color;
            
        }else if ([str isEqualToString:@"多云"]){
            baseview.layer.borderColor = AppFont5FBEF5Color.CGColor;
            shaplayer.strokeColor = AppFont5FBEF5Color.CGColor;
            lable.textColor = AppFont5FBEF5Color;
            
        }else if ([str isEqualToString:@"雨"]){
            baseview.layer.borderColor = AppFont6CA7F2Color.CGColor;
            shaplayer.strokeColor = AppFont6CA7F2Color.CGColor;
            lable.textColor = AppFont6CA7F2Color;
            
        }else if ([str isEqualToString:@"雪"]){
            baseview.layer.borderColor = AppFont6CA7F2Color.CGColor;
            
            shaplayer.strokeColor = AppFont6CA7F2Color.CGColor;
            lable.textColor = AppFont6CA7F2Color;
            
        }else if ([str isEqualToString:@"雾"]){
            baseview.layer.borderColor = AppFont5FBEF5Color.CGColor;
            shaplayer.strokeColor = AppFont5FBEF5Color.CGColor;
            lable.textColor = AppFont5FBEF5Color;
            
        }else if ([str isEqualToString:@"霾"]){
            baseview.layer.borderColor = AppFont9EAEC6Color.CGColor;
            shaplayer.strokeColor = AppFont9EAEC6Color.CGColor;
            lable.textColor = AppFont9EAEC6Color;
            
        }else if ([str isEqualToString:@"冰冻"]){
            baseview.layer.borderColor = AppFont6C8FF2Color.CGColor;
            shaplayer.strokeColor = AppFont6C8FF2Color.CGColor;
            lable.textColor = AppFont6C8FF2Color;
            
        }
        else if ([str isEqualToString:@"风"]){
            baseview.layer.borderColor = AppFont53D0E7Color.CGColor;
            shaplayer.strokeColor = AppFont53D0E7Color.CGColor;
            lable.textColor = AppFont53D0E7Color;
            
        }
        else if ([str isEqualToString:@"停电"]){
            baseview.layer.borderColor = AppFontFCB550Color.CGColor;
            shaplayer.strokeColor = AppFontFCB550Color.CGColor;
            lable.textColor = AppFontFCB550Color;
            
        }else{
            
            baseview.layer.borderColor = AppFontf1f1f1Color.CGColor;
            shaplayer.strokeColor = AppFontf1f1f1Color.CGColor;
            lable.textColor = AppFontEB4E4EColor;
            ;
            //        [self repeatloadViewand:index];
        }
    }
    
    if ([selectStr isEqualToString:@"不选"]) {
        if (_firsttitlelable.text&&[_firstnumLable.text isEqualToString:@"1"]) {
            
            _upleftView.layer.borderColor = AppFontf1f1f1Color.CGColor;
            upleftlayer.strokeColor = AppFontf1f1f1Color.CGColor;
            
            _firstnumLable.textColor = AppFontEB4E4EColor;
            
            
        }
        
        if (_secondtitlelable&& [_secondnumLable.text isEqualToString:@"2"]) {
            _uprightView.layer.borderColor = AppFontf1f1f1Color.CGColor;
            uprightlayer.strokeColor = AppFontf1f1f1Color.CGColor;
            _secondnumLable.textColor = AppFontEB4E4EColor;
            
        }
        
        if (_thirdtitlelable&&[_thrednumLable.text isEqualToString:@"3"]) {
            _downleftView.layer.borderColor = AppFontf1f1f1Color.CGColor;
            downleftlayer.strokeColor = AppFontf1f1f1Color.CGColor;
            _thrednumLable.textColor = AppFontEB4E4EColor;
            
        }
        
        if (_fourtitlelable&&[_fournumLable.text isEqualToString:@"4"]) {
            _downrightView.layer.borderColor = AppFontf1f1f1Color.CGColor;
            downrightlayer.strokeColor = AppFontf1f1f1Color.CGColor;
            _fournumLable.textColor = AppFontEB4E4EColor;
            
        }
        
    }
    
    
    
}
#pragma mark - 移除前面的天气
- (void)removePreWeather
{
    switch (_SelectedimageArr.count) {
        case 1:
            _firstnumLable.text = @"1";
            _firsttitlelable.text = @"天气";
            _firstnumLable.textColor = AppFontEB4E4EColor;
            _firsttitlelable.textColor = AppFont999999Color;
            break;
        case 2:
            _secondnumLable.text = @"2";
            _secondtitlelable.text = @"天气";
            _secondnumLable.textColor = AppFontEB4E4EColor;
            _secondtitlelable.textColor = AppFont999999Color;
            
            break;
        case 3:
            _thrednumLable.text = @"3";
            _thirdtitlelable.text = @"天气";
            _thrednumLable.textColor = AppFontEB4E4EColor;
            _thirdtitlelable.textColor = AppFont999999Color;
            
            break;
        case 4:
            _fournumLable.text = @"4";
            _fourtitlelable.text = @"天气";
            _fournumLable.textColor = AppFontEB4E4EColor;
            _fourtitlelable.textColor = AppFont999999Color;
            break;
            
        default:
            break;
    }
}
#pragma mark- 编辑天气
-(void)editeCalender
{
}
#pragma mark - 改点天气选择框的文字
- (void)eidteTapViewLableText
{
    if (_editeweather) {
        switch (editeIndex -1 ) {
            case 0:
                //此处为删除选择
                _upleftimageView.hidden = NO;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text =_WeatherArr.count >0?@"":@"天气";
                _secondtitlelable.text = _WeatherArr.count >1?@"":@"天气";
                _thirdtitlelable.text =_WeatherArr.count >2?@"": @"天气";
                _fourtitlelable.text = _WeatherArr.count >3?@"":@"天气";
                _firstnumLable.text  = _WeatherArr.count >0?_WeatherArr[0]:@"1";
                _secondnumLable.text = _WeatherArr.count>1?_WeatherArr[1]:@"2";
                _thrednumLable.text  =  _WeatherArr.count>2?_WeatherArr[2]:@"3";
                _fournumLable.text   =  _WeatherArr.count>3?_WeatherArr[3]:@"4";
                break;
            case 1:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = NO;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text =_WeatherArr.count >0?@"":@"天气";
                _secondtitlelable.text = _WeatherArr.count >1?@"":@"天气";
                _thirdtitlelable.text =_WeatherArr.count >2?@"": @"天气";
                _fourtitlelable.text = _WeatherArr.count >3?@"":@"天气";
                _firstnumLable.text  = _WeatherArr.count >0?_WeatherArr[0]:@"1";
                _secondnumLable.text = _WeatherArr.count>1?_WeatherArr[1]:@"2";
                _thrednumLable.text  =  _WeatherArr.count>2?_WeatherArr[2]:@"3";
                _fournumLable.text   =  _WeatherArr.count>3?_WeatherArr[3]:@"4";
                break;
            case 2:
                if (_WeatherArr.count== 1) {
                    
                }else if (_WeatherArr.count == 2){
                    
                    
                }else if (_WeatherArr.count == 3){
                    
                    
                }else{
                    
                }
                
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = NO;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text =_WeatherArr.count >0?@"":@"天气";
                _secondtitlelable.text = _WeatherArr.count >1?@"":@"天气";
                _thirdtitlelable.text =_WeatherArr.count >2?@"": @"天气";
                _fourtitlelable.text = _WeatherArr.count >3?@"":@"天气";
                _firstnumLable.text  = _WeatherArr.count >0?_WeatherArr[0]:@"1";
                _secondnumLable.text = _WeatherArr.count>1?_WeatherArr[1]:@"2";
                _thrednumLable.text  =  _WeatherArr.count>2?_WeatherArr[2]:@"3";
                _fournumLable.text   =  _WeatherArr.count>3?_WeatherArr[3]:@"4";
                break;
            case 3:
                if (_WeatherArr.count== 1) {
                    
                }else if (_WeatherArr.count == 2){
                    
                    
                }else if (_WeatherArr.count == 3){
                    
                    
                }else{
                    
                }
                
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = NO;
                _firsttitlelable.text =_WeatherArr.count >0?@"":@"天气";
                _secondtitlelable.text = _WeatherArr.count >1?@"":@"天气";
                _thirdtitlelable.text =_WeatherArr.count >2?@"": @"天气";
                _fourtitlelable.text = _WeatherArr.count >3?@"":@"天气";
                _firstnumLable.text  = _WeatherArr.count >0?_WeatherArr[0]:@"1";
                _secondnumLable.text = _WeatherArr.count>1?_WeatherArr[1]:@"2";
                _thrednumLable.text  =  _WeatherArr.count>2?_WeatherArr[2]:@"3";
                _fournumLable.text   =  _WeatherArr.count>3?_WeatherArr[3]:@"4";
                break;
            case 4:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = NO;
                _firsttitlelable.text =_WeatherArr.count >0?@"":@"天气";
                _secondtitlelable.text = _WeatherArr.count >1?@"":@"天气";
                _thirdtitlelable.text =_WeatherArr.count >2?@"": @"天气";
                _fourtitlelable.text = _WeatherArr.count >3?@"":@"天气";
                _firstnumLable.text  = _WeatherArr.count >0?_WeatherArr[0]:@"1";
                _secondnumLable.text = _WeatherArr.count>1?_WeatherArr[1]:@"2";
                _thrednumLable.text  =  _WeatherArr.count>2?_WeatherArr[2]:@"3";
                _fournumLable.text   =  _WeatherArr.count>3?_WeatherArr[3]:@"4";
                break;
            default:
                break;
        }
    }else{
        switch (_WeatherArr.count) {
            case 0:
                //此处为删除选择
                _upleftimageView.hidden = NO;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text = @"天气";
                _secondtitlelable.text = @"天气";
                _thirdtitlelable.text = @"天气";
                _fourtitlelable.text = @"天气";
                _firstnumLable.text  = @"1";
                _secondnumLable.text = @"2";
                _thrednumLable.text  =  @"3";
                _fournumLable.text   = @"4";
                break;
            case 1:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = NO;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text = @"";
                _secondtitlelable.text = @"天气";
                _thirdtitlelable.text = @"天气";
                _fourtitlelable.text = @"天气";
                _firstnumLable.text  = _WeatherArr[0];
                _secondnumLable.text = @"2";
                _thrednumLable.text  =  @"3";
                _fournumLable.text   = @"4";
                break;
            case 2:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = NO;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text = @"";
                _secondtitlelable.text = @"";
                _thirdtitlelable.text = @"天气";
                _fourtitlelable.text = @"天气";
                _firstnumLable.text  = _WeatherArr[0];
                _secondnumLable.text = _WeatherArr[1];
                _thrednumLable.text  =  @"3";
                _fournumLable.text   = @"4";
                break;
            case 3:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = NO;
                _firsttitlelable.text = @"";
                _secondtitlelable.text = @"";
                _thirdtitlelable.text = @"";
                _fourtitlelable.text = @"天气";
                _firstnumLable.text  = _WeatherArr[0];
                _secondnumLable.text = _WeatherArr[1];
                _thrednumLable.text  =  _WeatherArr[2];
                _fournumLable.text   = @"4";
                break;
            case 4:
                _upleftimageView.hidden = YES;
                _uprightimageView.hidden = YES;
                _downleftimageView.hidden = YES;
                _downrightimageView.hidden = YES;
                _firsttitlelable.text = @"";
                _secondtitlelable.text = @"";
                _thirdtitlelable.text = @"";
                _fourtitlelable.text = @"";
                _firstnumLable.text  = _WeatherArr[0];
                _secondnumLable.text = _WeatherArr[1];
                _thrednumLable.text  =  _WeatherArr[2];
                _fournumLable.text   = _WeatherArr[3];
                break;
            default:
                break;
        }
    }
    
}
#pragma mark - 编辑天气

- (void)editeRainCalenderWithArr:(NSMutableArray *)weaterArr
{
    
    //文字
    _WeatherArr = [[NSMutableArray alloc]initWithArray:weaterArr];
    [self eidteTapViewLableText];
    
    if (!_SelectedimageArr) {
        _SelectedimageArr = [NSMutableArray new];
    }
    
    for (NSString *weaterStr in _WeatherArr) {
        if ([weaterStr isEqualToString:@"晴"]) {
            [_SelectedimageArr insertObject:@"record_popup_claer" atIndex:_SelectedimageArr.count];
        }else if ([weaterStr isEqualToString:@"阴"]){
            [_SelectedimageArr insertObject:@"record_popup_overcast" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"多云"]){
            [_SelectedimageArr insertObject:@"record_popup_cloudy" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"雨"]){
            [_SelectedimageArr insertObject:@"record_popup_rain" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"风"]){
            [_SelectedimageArr insertObject:@"record_popup_wind" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"雪"]){
            [_SelectedimageArr insertObject:@"record_popup_snow" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"雾"]){
            [_SelectedimageArr insertObject:@"record_popup_fog" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"霾"]){
            [_SelectedimageArr insertObject:@"record_popup_haze" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"冰冻"]){
            [_SelectedimageArr insertObject:@"record_popup_frost" atIndex:_SelectedimageArr.count];
            
        }else if ([weaterStr isEqualToString:@"停电"]){
            [_SelectedimageArr insertObject:@"record_popup_power-outage" atIndex:_SelectedimageArr.count];
            
        }
        [self acordingWeatherStrretrunColor:weaterStr];
        
    }
    [_tableview reloadData];
    
}
-(void)cleanrRainCalender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cleanRainCalenderVC)]) {
        [self.delegate cleanRainCalenderVC];
    }
    
}
@end
