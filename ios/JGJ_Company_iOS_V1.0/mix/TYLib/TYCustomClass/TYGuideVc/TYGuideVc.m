//
//  TYGuideVc.m
//  HuDuoDuoLogistics
//
//  Created by jizhi on 15/5/11.
//  Copyright (c) 2015年 JiZhiShengHuo. All rights reserved.
//


#import "TYGuideVc.h"
#import "JLGAppDelegate.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

static const NSInteger FuKeNewfeatureCount = 4;//引导页的数量
static const NSInteger pageControlHtoBottom = 50;//pageControll距离底部的距离

//static const CGFloat startBtnHToWRation = 0.3;//高度和宽度的比例 h = w*ration;
//static const CGFloat startBtnWToScreenWRation = 0.28;//button宽度和屏幕宽度的比例
//static const CGFloat startBtnToBottom = 80;//button距离底部的距离

#define startBtnToBottom (TYIS_IPHONE_5 || TYIS_IPHONE_6 ? 80 : 90)

@interface TYGuideVc () <UIScrollViewDelegate>
{
    BOOL _showPageControl;
}
//3. 定义一个block变量 用copy修饰
@property (nonatomic, copy) finishBlock myBlock;

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *nextButton;

@property (nonatomic, strong) UIImageView *subImageview_one;
@property (nonatomic, strong) UIImageView *subImageview_two;
@property (nonatomic, strong) UIImageView *subImageview_two_sub;

@property (nonatomic, strong) UIImageView *subImageview_three;
@property (nonatomic, strong) UIImageView *subImageview_three_sub;

@property (nonatomic, strong) UIImageView *subImageview_four;

@property (nonatomic, strong) NSTimer *firstTimer;
@property (nonatomic, strong) NSTimer *secondTimer;
@property (nonatomic, strong) NSTimer *thirdTimer;
@property (nonatomic, strong) NSTimer *fourthTimer;
@end

@implementation TYGuideVc

- (instancetype)initWithBlock:(finishBlock)block{
    if (self = [super init]) {
        self.myBlock = block;
        _showPageControl = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.mj_w;
    CGFloat scrollH = scrollView.mj_h;
    
    for (int i = 0; i< FuKeNewfeatureCount; i++) {
        //添加ImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.mj_w = scrollW;
        imageView.mj_h = scrollH;
        imageView.mj_y = 0;
        imageView.mj_x = i * scrollW;
        
        // 显示图片
        NSString *name;
        if (isiPhoneX) {
            name = [NSString stringWithFormat:@"new_feature_%d_iphonex.png", i + 1];
        }else{
            
          name = [NSString stringWithFormat:@"new_feature_%d.png", i + 1];
        }
        imageView.image = [UIImage imageNamed:name];
        
        [scrollView addSubview:imageView];
        
        
#pragma mark - 添加一个动画
        
        if (i == 0) {
            _firstTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_one) userInfo:nil repeats:YES];
            _subImageview_one = [[UIImageView alloc] init];
            [_subImageview_one setFrame:CGRectMake(0,0,730.00/2/375*TYGetUIScreenWidth ,562.00/2/375*TYGetUIScreenWidth)];
            _subImageview_one.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
            _subImageview_one.image = [UIImage imageNamed:@"new_feature_sub_1"];
            [imageView addSubview:_subImageview_one];
            
        }else if (i == 1){
            _secondTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_two) userInfo:nil repeats:YES];
            _subImageview_two = [[UIImageView alloc] init];
            [_subImageview_two setFrame:CGRectMake(0,0,730.0/2/375*TYGetUIScreenWidth ,720.00/2/375*TYGetUIScreenWidth)];
            _subImageview_two.center = CGPointMake(self.view.center.x, self.view.center.y - 30);

            _subImageview_two.image = [UIImage imageNamed:@"new_feature_sub_2"];
            _subImageview_two_sub = [[UIImageView alloc] init];
            
            [_subImageview_two_sub setFrame:CGRectMake(TYGetUIScreenWidth - 100, CGRectGetMinY(_subImageview_two.frame) + 720.00/4/375*TYGetUIScreenWidth, 70, 150)];
            _subImageview_two_sub.image = [UIImage imageNamed:@"new_feature_sub_sub_2"];
            
            [imageView addSubview:_subImageview_two];
            
            [imageView addSubview:_subImageview_two_sub];

        }else if (i == 2){
            _thirdTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_three) userInfo:nil repeats:YES];
            _subImageview_three = [[UIImageView alloc] init];
            [_subImageview_three setFrame:_subImageview_one.frame];
            _subImageview_three.image = [UIImage imageNamed:@"new_feature_sub_3"];
            [imageView addSubview:_subImageview_three];
            
            _subImageview_three_sub = [[UIImageView alloc] init];
            [_subImageview_three_sub setFrame:CGRectMake(TYGetUIScreenWidth - 140 - 38, CGRectGetMinY(_subImageview_three.frame) + 562.00/4.2/375*TYGetUIScreenWidth, 140, 180)];
            _subImageview_three_sub.image = [UIImage imageNamed:@"new_feature_sub_sub_3"];
            [imageView addSubview:_subImageview_three_sub];
            
            
        }else{
            _fourthTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_four) userInfo:nil repeats:YES];
            _subImageview_four = [[UIImageView alloc] init];
            [_subImageview_four setFrame:_subImageview_one.frame];
            _subImageview_four.image = [UIImage imageNamed:@"new_feature_sub_4"];
            [imageView addSubview:_subImageview_four];
        }
        
        // 如果是最后一个imageView，就往里面添加其他内容
//        if (i == FuKeNewfeatureCount - 1) {
//            [self setupLastImageView:imageView];
//        }
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(FuKeNewfeatureCount * scrollW, 0);
    scrollView.bounces = YES; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    //添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = FuKeNewfeatureCount;
    
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    
    CGFloat centerX = scrollW * 0.5;
    CGFloat centerY = scrollH - pageControlHtoBottom + 25;
    pageControl.center = CGPointMake(centerX, centerY);
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    //添加按钮
//    CGFloat viewMargin = 20;
//    CGFloat buttonW = 120;
//    CGFloat buttonH = 37.5;
//    CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
//    CGFloat buttonY = TYGetUIScreenHeight - startBtnToBottom;
//    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(viewMargin/2, viewMargin/2, buttonW, buttonH)];
//
//    nextButton.userInteractionEnabled = NO;//这样使用主要是button和scrollView的手势有冲突
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextButton setTitleColor:TYColorHex(0xaaaaaa) forState:UIControlStateNormal];
//    [nextButton.layer setLayerBorderWithColor:TYColorHex(0x969696) width:0.5 ration:0.16];
//
//    //增加一个范围大点的View,添加手势
//    UIView *nextView = [[UIView alloc] initWithFrame:TYSetRect(buttonX - viewMargin/2, buttonY - viewMargin/2, buttonW + viewMargin, buttonH + viewMargin)];
//    nextView.backgroundColor = [UIColor clearColor];
//    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [nextView addGestureRecognizer:singleTap];
//    
//    [nextView addSubview:nextButton];
//    [self.view addSubview:nextView];
//    self.nextButton = nextButton;
    
    
    CGFloat buttonW = 110;
    CGFloat buttonH = 40;
    CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
    CGFloat buttonY = TYGetUIScreenHeight - startBtnToBottom - buttonH + 20 ;
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"letsgo"] forState:UIControlStateNormal];
    

    nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 20;
//    nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    nextButton.layer.borderWidth = 1;
    [nextButton addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];

    //    [nextButton setImage:self.featureImage forState:UIControlStateNormal];
    
//    [nextButton addTarget:self action:@selector(handleSingleTaptouchDown:) forControlEvents:UIControlEventTouchDown];
    
    
    

    [self.view addSubview:nextButton];
    
    
    
    self.nextButton = nextButton;

}
-(void)handleSingleTaptouchDown:(UIButton *)recognizer
{
//    double page = self.scrollView.contentOffset.x / self.scrollView.mj_w;
//    int pageNum = (int)(page + 0.5) + 1;
    
//    if (recognizer.state == UIControlStateHighlighted) {
//        recognizer.alpha = .5;
//
//    }
   
    

}
#pragma mark - 点击进入下一页
- (void)handleSingleTap:(UIButton *)recognizer{
    
//    if (recognizer.state != UIControlStateHighlighted) {
    
//    recognizer.alpha = 0.5;
        recognizer.alpha = 1;

//    }else{
//    
//    }
    
    

//    double page = self.scrollView.contentOffset.x / self.scrollView.mj_w;
//    int pageNum = (int)(page + 0.5) + 1;
//    
//    if (pageNum == FuKeNewfeatureCount) {//最后一个
//        [self goToHomeVc];
//    }else{
//        self.scrollView.userInteractionEnabled = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.scrollView.contentOffset = TYSetPoint(pageNum*self.scrollView.mj_w, 0);
//        }completion:^(BOOL finished) {
//            self.scrollView.userInteractionEnabled = YES;
//        }];
//    }
    
    [self goToHomeVc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.mj_w;
    
    //最后一页如果再滑动，就进入rootVc
    if ((int)(page + 0.8) >= FuKeNewfeatureCount) {
        [self goToHomeVc];
        return;
    }
    
    // 四舍五入计算出页码
    int pageNum = (int)(page + 0.5);

    self.pageControl.currentPage = pageNum;

//    NSString *titleString ;
//    UIColor *titleBackgroundColor = [[UIColor alloc] init];
//    UIColor *titleColor = [[UIColor alloc] init];
//    UIColor *layerBorderColor = [[UIColor alloc] init];
//    
////    CGFloat buttonW = 0.0;
////    CGFloat buttonH = 0.0;
////    CGFloat buttonCenterX = self.nextButton.center.x;
////    CGFloat buttonCenterY = self.nextButton.center.y;
//    
//    if (FuKeNewfeatureCount - 1 == pageNum) {
////        buttonW = 150.0;
////        buttonH = 40.0;
//        titleString = @"立即开启";
//        titleColor = [UIColor whiteColor];
//        layerBorderColor = TYColorHex(0x7ed5ec);
//        titleBackgroundColor = TYColorHex(0x5bd8ef);
//    }else{
////        buttonW = 120.0;
////        buttonH = 37.5;
//        titleString = @"下一步";
//        titleColor = TYColorHex(0xaaaaaa);
//        layerBorderColor = TYColorHex(0x969696);
//        titleBackgroundColor = [UIColor clearColor];
//    }
//    
////    self.nextButton.frame = CGRectMake(0, 0, buttonW, buttonH);
////    self.nextButton.center = CGPointMake(buttonCenterX, buttonCenterY);
//
//    self.nextButton.backgroundColor = titleBackgroundColor;
//    [self.nextButton setTitle:titleString  forState:UIControlStateNormal];
//    [self.nextButton setTitleColor:titleColor forState:UIControlStateNormal];
////    [self.nextButton.layer setLayerBorderWithColor:layerBorderColor width:0.5 ration:FuKeNewfeatureCount - 1 == pageNum?0.12:0.14];
//    [self.nextButton.layer setLayerBorderWithColor:layerBorderColor width:0.5 ration:0.16];
    
    
    CGFloat buttonW = 110;
    
    //    CGFloat buttonH = self.featureImage.size.height;
    
    CGFloat buttonH = 40;
    
    CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
    
    self.nextButton.layer.masksToBounds = NO;
    self.nextButton.backgroundColor = [UIColor clearColor];
    
    if (FuKeNewfeatureCount - 1 == pageNum) {
        //        self.featureImage = [UIImage imageNamed:@"next_open_icon"];
//        [self.nextButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [self.nextButton setImage:[UIImage imageNamed:@"letsgo"] forState:UIControlStateNormal];
        
//        [self.nextButton addTarget:self action:@selector(handleSingleTaptouchDown:) forControlEvents:UIControlEventTouchDown];
        
//        self.nextButton.imageView.image = nil;
        
        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
//        self.nextButton.backgroundColor = AppFontEB4E4EColor;
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.layer.cornerRadius = 20;
//        self.nextButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
//        self.nextButton.layer.borderWidth = 1;
    }else {
        //        self.featureImage = [UIImage imageNamed:@"new_feature_next"];
        
//        [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextButton setImage:[UIImage imageNamed:@"letsgo"] forState:UIControlStateNormal];

        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.layer.cornerRadius = 20;
//        self.nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.nextButton.layer.borderWidth = 1;
    }
    //    [self.nextButton setImage:self.featureImage forState:UIControlStateNormal];
    self.nextButton.frame = CGRectMake(buttonX, TYGetUIScreenHeight - startBtnToBottom - buttonH + 20 , buttonW, buttonH);
}

- (void)goToHomeVc{
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    [jlgAppDelegate setRootViewController];
}

- (void)dealloc
{
    TYLog(@"GuideViewController-dealloc");
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        obj = nil;
 }];
    
    
    [_firstTimer invalidate];
    _firstTimer = nil;
    [_secondTimer invalidate];
    _secondTimer = nil;
    [_thirdTimer invalidate];
    _thirdTimer = nil;
    [_fourthTimer invalidate];
    _fourthTimer = nil;
}

#if 0
/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* enterToMainRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startClick)];
    [imageView addGestureRecognizer:enterToMainRecognizer];
}

- (void)startClick
{
    self.myBlock();
}
#endif



-(void)aniaml_one
{
    [UIView animateWithDuration:2 animations:^{
        self.subImageview_one.transform = CGAffineTransformMakeTranslation(0, -30);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.subImageview_one.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }];
}
-(void)aniaml_two
{
    [UIView animateWithDuration:2 animations:^{
        self.subImageview_two.transform = CGAffineTransformMakeTranslation(0, -30);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.subImageview_two.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }];
}
-(void)aniaml_three
{
    [UIView animateWithDuration:2 animations:^{
        self.subImageview_three.transform = CGAffineTransformMakeTranslation(0, -30);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.subImageview_three.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }];
}
-(void)aniaml_four
{
    [UIView animateWithDuration:2 animations:^{
        self.subImageview_four.transform = CGAffineTransformMakeTranslation(0, -30);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.subImageview_four.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }];
}
@end
