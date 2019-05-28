//
//  HJPhotoBrowser.m
//  photobrowser
//
//  Created by zuweizhong on 16-2-3.
//  Copyright (c) 2015年 zuweizhong. All rights reserved.
//

#import "HJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "HJBrowserImageView.h"

 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "HJPhotoBrowserConfig.h"

//  =============================================

@implementation HJPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
    UIActionSheet *actinSheet;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HJPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 50, 25);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:17];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.2;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }else{
        indexLabel.hidden = YES;
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setImage:[UIImage imageNamed:@"HJPhotoBrowser.bundle/save_icon"] forState:UIControlStateNormal];
    [saveButton setImage:[UIImage imageNamed:@"HJPhotoBrowser.bundle/save_icon_highlighted"] forState:UIControlStateHighlighted];
    saveButton.backgroundColor = [UIColor clearColor];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    _saveButton.hidden = YES;
    [self addSubview:saveButton];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    //[self addSubview:indicator];
    //[indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
//if (error) {
//    [TYShowMessage showSuccess:@"图片保存失败!"];
//}else{
//    [TYShowMessage showSuccess:@"图片保存成功!"];
//}
    /*
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 140, 40);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = HJPhotoBrowserSaveImageFailText;
    }   else {
        label.text = HJPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
     */
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        HJBrowserImageView *imageView = [[HJBrowserImageView alloc] init];
        imageView.tag = i;
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        
        
        UILongPressGestureRecognizer *saveLongGuessTure = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageshowView)];
        saveLongGuessTure.minimumPressDuration = 0.5;

        [imageView addGestureRecognizer:saveLongGuessTure];

        
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}
-(void)saveImageshowView
{

    [self savePicImage];
}
//保存图片
-(void)savePicImage
{

    if (!actinSheet) {
        actinSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        actinSheet.delegate = self;
        [actinSheet showInView:self];
    }


}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveImage];
        actinSheet = nil;
        [TYShowMessage showSuccess:@"图片保存成功!"];

    }else{
        [actinSheet removeFromSuperview];
        [actinSheet removeFromSuperview];
        actinSheet = nil;
        
 
    }
    
    
}
// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HJBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    HJBrowserImageView *currentImageView = (HJBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
//        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
        
        sourceView = recognizer.view;
    }
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];

    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:HJPhotoBrowserHideImageAnimationDuration animations:^{
//        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0;
        tempView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    HJBrowserImageView *imageView = (HJBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 1.5;
    }
    
    HJBrowserImageView *view = (HJBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += HJPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - HJPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HJBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = HJPhotoBrowserImageViewMargin + idx * (HJPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height-33);
    _saveButton.frame = CGRectMake(25, self.bounds.size.height - 45, 50, 25);
}

- (void)show
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectZero;
    self.center = window.center;
    [UIView animateWithDuration:.2 animations:^{
        self.frame = window.bounds;
    }];
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        HJBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[HJBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = nil;
    
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
//        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        
        sourceView = self.subImageViews[self.currentImageIndex];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:HJPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        HJBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}



@end
