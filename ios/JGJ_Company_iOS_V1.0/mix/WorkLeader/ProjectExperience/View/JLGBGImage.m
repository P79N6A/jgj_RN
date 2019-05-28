//
//  JLGBGImage.m
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBGImage.h"


@interface JLGBGImage()
<
    UIScrollViewDelegate
>
{
    CGRect _frame;
    UIImage *_placeholderImage;
}
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation JLGBGImage


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        _placeholderImage = nil;
    }
    return self;
}

- (void)setupInit{
    [self setupScrollView];
    [self setupImageView];
}

//初始化scrollView
- (void)setupScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.exclusiveTouch = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.9f;
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.contentSize = CGSizeMake(TYGetViewW(self), TYGetViewH(self));
    [self addSubview:self.scrollView];
}

//初始化imageView
- (void )setupImageView{
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    //显示网络图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:_placeholderImage];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    
    [self setupInit];
}

- (void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    self.scrollView.zoomScale = zoomScale;
}
#pragma seeimg Scroller is  delegete
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
