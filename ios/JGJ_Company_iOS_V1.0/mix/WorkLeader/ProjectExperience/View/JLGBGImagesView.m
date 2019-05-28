//
//  JLGBGImagesView.m
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBGImagesView.h"
#import "JLGBGImage.h"

@interface JLGBGImagesView ()
<
    UIScrollViewDelegate
>
{
    CGRect _frame;
    
    UILabel *_label;
    
    UIScrollView *_scrollview;
    
    NSUInteger _currentPage;
}

//block
@property (copy,nonatomic) hiddenBGImageBlock hiddenBGImageBlock;
@end

@implementation JLGBGImagesView

- (void)hiddenBGImageBlock:(hiddenBGImageBlock)hiddenBGImageBlock{
    self.hiddenBGImageBlock = hiddenBGImageBlock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
        _frame = frame;
    }
    return self;
}

- (void)setupInit{
    self.imagesArray = [[NSMutableArray alloc] init];
}

- (void )setImagesArray:(NSMutableArray *)imagesArray{
    _imagesArray = imagesArray;
    
}

- (void)showBGImagesInView:(UIView *)superView{
    [self showBGImagesInView:superView index:0];
}

- (void)showBGImagesInView:(UIView *)superView index:(NSUInteger )index{
    
    //添加背景view及点击的手势
    self.frame = _frame;
    self.backgroundColor = [UIColor blackColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapBGviewAction:)];
    [self addGestureRecognizer:tap];
    [superView addSubview:self];
    
    //添加_scrollView,scrollView高度为BGView的0.7
    CGFloat scrollViewH = TYGetViewH(self)*0.7;
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, TYGetViewW(self), scrollViewH)];
    _scrollview.delegate = self;
    _scrollview.pagingEnabled = YES;
    _scrollview.center = self.center;
    _scrollview.minimumZoomScale = 0.9f;
    _scrollview.maximumZoomScale = 3.0f;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentOffset = CGPointMake(TYGetViewW(self)*index, 0);
    _scrollview.contentSize = CGSizeMake(TYGetViewW(self)*self.imagesArray.count,  scrollViewH);


    [self addSubview:_scrollview];
    
    //增加图片
    for (int i = 0; i < self.imagesArray.count; i++)
    {
        JLGBGImage *imageView = [[JLGBGImage alloc] initWithFrame:CGRectMake(TYGetViewW(_scrollview)*i, 0,TYGetViewW(self), scrollViewH)];
        imageView.tag = 100+i;
        imageView.imageUrl = [JLGHttpRequest_Public stringByAppendingString:self.imagesArray[i]];
        
        [_scrollview addSubview:imageView];
    }

    //添加label
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame), 60, 100, 40)];
    [self addSubview:_label];
    _label.textColor = [UIColor whiteColor];
    _label.text = [NSString stringWithFormat:@"%@/%@",@(index+1),@(self.imagesArray.count)];
    
    _currentPage = index;
}

//背景图片的手势
-(void)TapBGviewAction:(UITapGestureRecognizer *)sender
{
    [_label removeFromSuperview];

    for(int i = 0;i < self.imagesArray.count;i++)
    {
        UIImageView *imageview = (UIImageView *)[self viewWithTag:100+i];
        [imageview removeFromSuperview];
    }
    
    _scrollview.delegate = nil;
    [_scrollview removeFromSuperview];
    self.frame = CGRectZero;
    if (self.hiddenBGImageBlock) {
        self.hiddenBGImageBlock();
    }
}

//label显示
#pragma mark - scrollView的delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / TYGetViewW(_scrollview);
    _label.text = [NSString stringWithFormat:@"%@/%@",@(page+1),@(self.imagesArray.count)];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / TYGetViewW(_scrollview);
    
    if (page != _currentPage) {
        JLGBGImage *jlgBGImage = [self viewWithTag:100+_currentPage];
        jlgBGImage.zoomScale = 1.0;
    }
    _currentPage = page;
}

@end
