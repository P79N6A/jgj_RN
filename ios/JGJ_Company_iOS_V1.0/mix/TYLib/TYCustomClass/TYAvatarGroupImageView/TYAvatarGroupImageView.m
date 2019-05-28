//
//  TYAvatarGroupImageView.m
//  mix
//
//  Created by Tony on 2016/8/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYAvatarGroupImageView.h"
#import "CALayer+WebCache.h"
#import <objc/runtime.h>

static const CGFloat kMarginSpaceRatio = 0.025;//默认的百分比间距
static const CGFloat kCircelMoreMargin = 8.0;//圆形需要多余的间隔，因为切断以后间隔变少了

@interface TYAvatarGroupImageView()

@property (nonatomic, assign) CGFloat imgWH;//每个图片的长宽

@property (nonatomic, assign) CGFloat imgMargin;//每个图片的长宽

@property (nonatomic, strong) NSMutableArray <CALayer *>*imageViews;
@end


@implementation TYAvatarGroupImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    }
    return self;
    
}

#pragma mark - 获取圆形图片，imgMargin用默认的
- (UIImageView *)getCircleImgView:(NSArray *)images{
    self.imageType = TYAGIImageRect;
    return [self getImgView:images];
}

#pragma mark  获取圆形图片，imgMargin需要传入
- (UIImageView *)getCircleImgView:(NSArray *)images imgMargin:(CGFloat)imgMargin{
    self.imageType = TYAGIImageRect;
    return [self getImgView:images imgMargin:imgMargin];
}

#pragma mark - 获取方形图片，imgMargin用默认的
- (UIImageView *)getRectImgView:(NSArray *)images{
    self.imageType = TYAGIImageRect;
    return [self getImgView:images];
}

#pragma mark  获取方形图片，imgMargin需要传入
- (UIImageView *)getRectImgView:(NSArray *)images imgMargin:(CGFloat)imgMargin{
    self.imageType = TYAGIImageRect;
    return [self getImgView:images imgMargin:imgMargin];
}

#pragma mark - 获取图片，imgMargin用默认的
- (UIImageView *)getImgView:(NSArray *)images{
    self.imgMargin = self.bounds.size.width * kMarginSpaceRatio;
    return [self getImgView:images imgMargin:self.imgMargin];
}

#pragma mark  获取图片，imgMargin需要传入
- (UIImageView *)getImgView:(NSArray *)images imgMargin:(CGFloat)imgMargin{
        if (!images.count) {
            return nil;
        }
        
        self.imgMargin = imgMargin;
        
        //将数组转换成UIImageview
        [self imagesTransitionIntoUIImageView:images];
    
        //计算图片的长宽
        [self getImgWhByImgCount:self.imageViews.count];
        
        //默认的颜色
        self.layer.backgroundColor = TYColorHex(0xd8d9e6).CGColor;
        
        //计算不同情况下的frame
        [self getFrameByStatus];

        self.image = [self addImages:self.imageViews.copy];
    return self;
}

#pragma mark 将数组转换成UIImageview
- (void)imagesTransitionIntoUIImageView:(NSArray *)images{
    self.imageViews = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        CALayer *layer = [CALayer layer];
        
        if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *imageObj = (UIImage *)obj;
            layer.contents =  (__bridge id _Nullable)(imageObj.CGImage);
        }else{
            NSURL *imgURL = [NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:obj?:@""]];
            [layer sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
        }
        
        [strongSelf.imageViews addObject:layer];
    }];
}

- (void)getFrameByStatus{
    if (!self.imageViews.count) {
        return ;
    }
    
    CALayer* firstImageView = (CALayer *)self.imageViews[0];
    CGFloat row_1_origin_y = [self.imageViews count] == 2?(self.frame.size.height - self.imgWH)/2:(self.frame.size.height - self.imgWH * 2)/3;
    
    if ([self.imageViews count] == 1) {
        firstImageView.frame = CGRectMake(0, 0, self.imgWH, self.imgWH);
    }else if ([self.imageViews count] == 2) {
        self.imageViews = [self getFrame:self.imageViews beginOriginY:row_1_origin_y].mutableCopy;
    }else if ([self.imageViews count] == 3) {
        firstImageView.frame = CGRectMake((self.frame.size.width - self.imgWH)/2, row_1_origin_y, self.imgWH, self.imgWH);
        
        self.imageViews = [self getFrame:self.imageViews beginOriginY:row_1_origin_y + self.imgWH + self.imgMargin].mutableCopy;
    }else if ([self.imageViews count] == 4) {
        self.imageViews = [self getFrame:self.imageViews beginOriginY:row_1_origin_y].mutableCopy;
    }else{
        self.imageViews = [self getFrame:self.imageViews beginOriginY:row_1_origin_y].mutableCopy;
    }
    
    if (self.imageType == TYAGIImageCircle) {
        self.layer.cornerRadius = self.frame.size.width/2;
    }else{
        self.layer.cornerRadius = self.frame.size.width*0.05;
    }
    
    self.layer.masksToBounds = YES;
}

- (NSArray *)getFrame:(NSArray *)imageViews beginOriginY:(CGFloat)beginOriginY {
    NSInteger count = (NSInteger)imageViews.count;
    
    //最多4个
    NSInteger cellCount = 4;
    
    //最多2行
    NSInteger maxRow = 2;
    
    //最多2列
    NSInteger maxColumn = 2;
    
    NSInteger ignoreCountOfBegining = count%2;
    
    
    CGFloat imgMarginOffset = 1 + (self.imageType == TYAGIImageCircle?(kCircelMoreMargin/2.0):0);
    
    for (NSInteger i = 0; i < cellCount; i++) {
        if (i > imageViews.count - 1) break;
        if (i < ignoreCountOfBegining) continue;
        
        NSInteger row = floor((CGFloat)(i - ignoreCountOfBegining) / maxRow);
        NSInteger column = (i - ignoreCountOfBegining) % maxColumn;
        
        CGFloat origin_x = imgMarginOffset*self.imgMargin + self.imgWH * column + self.imgMargin * column;
        CGFloat origin_y = beginOriginY + self.imgWH * row + self.imgMargin * row;
        
//        NSLog(@"row = %@,column = %@,origin_x = %@,origin_y = %@",@(row),@(column),@(origin_x),@(origin_y));

        CALayer* imageView = imageViews[i];
        imageView.frame = CGRectMake(origin_x, origin_y, self.imgWH, self.imgWH);
    }
    
    return imageViews;
}

#pragma mark 计算图片的长宽
- (void)getImgWhByImgCount:(NSInteger)count{
    CGFloat imgWh = 0.0f;
    
    if (count == 1) {
        imgWh = self.frame.size.width;
    } else{
        NSInteger imgMargin = 3 + (self.imageType == TYAGIImageCircle?kCircelMoreMargin:0);

        imgWh = (self.frame.size.width - self.imgMargin * imgMargin) / 2;
    }
    
    self.imgWH = imgWh;
}

#pragma mark 合成图片
- (UIImage *)addImages:(NSArray *)images{
    __weak typeof(self) weakSelf = self;
    
    //如果是需要圆形，就重画
    [images enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (weakSelf.imageType == TYAGIImageCircle) {
            obj.cornerRadius = obj.bounds.size.width/2.0;
            obj.masksToBounds = YES;
        }
        
        [weakSelf.layer addSublayer:obj];
    }];
    
    //创建图形上下文
    UIGraphicsBeginImageContextWithOptions(self.frame.size,NO,[[UIScreen mainScreen] scale]);
    
    //获取图片
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();

    return resultingImage;
}
@end
