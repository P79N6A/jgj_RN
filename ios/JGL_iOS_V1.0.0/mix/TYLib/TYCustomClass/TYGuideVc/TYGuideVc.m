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

static const NSInteger FuKeNewfeatureCount = 3;//引导页的数量
static const NSInteger pageControlHtoBottom = 37;//pageControll距离底部的距离

static const NSInteger IPhoneXPageControlHtoBottom = 77;//IPhoneX的pageControll距离底部的距离

//static const CGFloat startBtnHToWRation = 0.34;//高度和宽度的比例 h = w*ration;
//static const CGFloat startBtnWToScreenWRation = 0.315;//button宽度和屏幕宽度的比例
//static const CGFloat startBtnToBottom = 80;//button距离底部的距离

#define startBtnToBottom (TYIS_IPHONE_5_OR_LESS ? 50 : (TYIS_IPHONE_6 ? 55 : 60))

#define IPhoneXStartBtnToBottom 107  //IPhoneX 下一步按钮距离底部的距离

@interface TYGuideVc () <UIScrollViewDelegate>
{
    BOOL _showPageControl;
}
//3. 定义一个block变量 用copy修饰
@property (nonatomic, copy) finishBlock myBlock;

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *nextButton;
@property (nonatomic, weak) UIImage *featureImage;
@property (nonatomic, strong) UIImageView *subImageview_one;
@property (nonatomic, strong) UIImageView *subImageview_two;
@property (nonatomic, strong) UIImageView *subImageview_three;
@property (nonatomic, strong) UIImageView *subImageview_four;

@property (nonatomic, strong) NSTimer *firstTimer;
@property (nonatomic, strong) NSTimer *secondTimer;
@property (nonatomic, strong) NSTimer *thirdTimer;
@property (nonatomic, strong) NSTimer *fourthTimer;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
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
        NSString *name = [NSString stringWithFormat:@"new_feature_%d.jpg", i + 1];
        
        if (JGJ_IphoneX_Or_Later) {
            
            name = [NSString stringWithFormat:@"new_feature_iphoneX_%d.jpg", i + 1];
        }
        
        imageView.image = [UIImage imageNamed:name];
        
        
#pragma mark - 添加一个动画

//        if (i == 0) {
//            _firstTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_one) userInfo:nil repeats:YES];
//            _subImageview_one = [[UIImageView alloc] init];
//            [_subImageview_one setFrame:CGRectMake(0,0,730.00/2/375*TYGetUIScreenWidth ,562.00/2/375*TYGetUIScreenWidth)];
//            _subImageview_one.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
//            _subImageview_one.image = [UIImage imageNamed:@"new_feature_sub_1"];
//            [imageView addSubview:_subImageview_one];
//  
//        }else if (i == 1){
//           _secondTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_two) userInfo:nil repeats:YES];
//            _subImageview_two = [[UIImageView alloc] init];
//            [_subImageview_two setFrame:_subImageview_one.frame];
//            _subImageview_two.image = [UIImage imageNamed:@"new_feature_sub_2"];
//            [imageView addSubview:_subImageview_two];
//        }else if (i == 2){
//           _thirdTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_three) userInfo:nil repeats:YES];
//            _subImageview_three = [[UIImageView alloc] init];
//            [_subImageview_three setFrame:_subImageview_one.frame];
//            _subImageview_three.image = [UIImage imageNamed:@"new_feature_sub_3"];
//            [imageView addSubview:_subImageview_three];
//        }else{
//            _fourthTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(aniaml_four) userInfo:nil repeats:YES];
//            _subImageview_four = [[UIImageView alloc] init];
//            [_subImageview_four setFrame:_subImageview_one.frame];
//            _subImageview_four.image = [UIImage imageNamed:@"new_feature_sub_4"];
//            [imageView addSubview:_subImageview_four];
//        }
        [scrollView addSubview:imageView];
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
    

    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = FuKeNewfeatureCount;
    
    pageControl.currentPageIndicatorTintColor = AppFont000000Color;
    
    pageControl.pageIndicatorTintColor = TYColorHexAlpha(0x000000, 0.2);
    
    [pageControl setValue:[UIImage imageNamed:@"pagectrl_black_icon"] forKeyPath:@"currentPageImage"];
    
    [pageControl setValue:[UIImage imageNamed:@"pagectrl_dark_icon"] forKeyPath:@"pageImage"];
    
    CGFloat centerX = scrollW * 0.5;
    
    CGFloat centerY = scrollH - pageControlHtoBottom;
    
    //IphoneX的位置
    if (IS_IPHONE_X_Later) {
        
        centerY = scrollH - IPhoneXPageControlHtoBottom;
    }
    
    pageControl.center = CGPointMake(centerX, centerY);
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    self.featureImage = [UIImage imageNamed:@"next_open_icon"];
    
    CGFloat buttonW = 129;
    CGFloat buttonH = 40;
    CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
    CGFloat buttonY = TYGetUIScreenHeight - startBtnToBottom - buttonH ;
    
    if (IS_IPHONE_X_Later) {
        
        buttonY = TYGetUIScreenHeight - IPhoneXStartBtnToBottom - buttonH ;
    }
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"guide_nextStep_icon"] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    [nextButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 20;
//    nextButton.layer.borderColor = AppFontd7252cColor.CGColor;
//    nextButton.layer.borderWidth = 1;

//    [nextButton setImage:self.featureImage forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
    
    
    self.nextButton = nextButton;
}

#pragma mark - 点击进入下一页
- (void)nextBtnClick:(id )sender{
    double page = self.scrollView.contentOffset.x / self.scrollView.mj_w;
    int pageNum = (int)(page + 0.5) + 1;

    if (pageNum == FuKeNewfeatureCount) {//最后一个
        [self goToHomeVc];
    }else{
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = TYSetPoint(pageNum*self.scrollView.mj_w, 0);
        }completion:^(BOOL finished) {
            self.scrollView.userInteractionEnabled = YES;
        }];
    }
    
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
//    self.pageControl.hidden = pageNum == (FuKeNewfeatureCount - 1);

//    if (pageNum == (FuKeNewfeatureCount - 1)) {//最后一页
//        [self.nextButton setTitle:@"立即开启"  forState:UIControlStateNormal];
//        [self.nextButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
//        
//        [self.nextButton setImage:self.featureImage forState:UIControlStateNormal];
//        CGFloat buttonW = 165;
//        CGFloat buttonH = 40;
//        CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
//        
//        [self.nextButton.layer setLayerCornerRadius:20];
//        self.nextButton.backgroundColor = [UIColor whiteColor];
//        [self.nextButton setImage:nil forState:UIControlStateNormal];
//        self.nextButton.frame = CGRectMake(buttonX, (TYGetUIScreenHeight - 100), buttonW, buttonH);
//    }else{
//        CGFloat buttonW = self.featureImage.size.width;
//        CGFloat buttonH = self.featureImage.size.height;
//        CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
//
//        self.nextButton.layer.masksToBounds = NO;
//        self.nextButton.backgroundColor = [UIColor clearColor];
//        [self.nextButton setImage:self.featureImage forState:UIControlStateNormal];
//        self.nextButton.frame = CGRectMake(buttonX, TYGetUIScreenHeight - startBtnToBottom - buttonH, buttonW, buttonH);
//    }
    
//    CGFloat buttonW = self.featureImage.size.width;
    CGFloat buttonW = 129;

//    CGFloat buttonH = self.featureImage.size.height;
    
    CGFloat buttonH = 40;

    CGFloat buttonX = (TYGetUIScreenWidth - buttonW)/2;
    
    self.nextButton.layer.masksToBounds = NO;
//    self.nextButton.backgroundColor = [UIColor clearColor];
    
    if (FuKeNewfeatureCount - 1 == pageNum) {
//        self.featureImage = [UIImage imageNamed:@"next_open_icon"];
//        [self.nextButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [self.nextButton setImage:[UIImage imageNamed:@"next_open_icon"] forState:UIControlStateNormal];

        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:19];
//        self.nextButton.backgroundColor = AppFontd7252cColor;
//        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.layer.cornerRadius = 20;
//        self.nextButton.layer.borderColor = AppFontd7252cColor.CGColor;
//        self.nextButton.layer.borderWidth = 1;
    }else {
//        self.featureImage = [UIImage imageNamed:@"new_feature_next"];
    
//        [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextButton setImage:[UIImage imageNamed:@"guide_nextStep_icon"] forState:UIControlStateNormal];

        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:19];
//        [self.nextButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.layer.cornerRadius = 20;
//        self.nextButton.layer.borderColor = AppFontd7252cColor.CGColor;
//        self.nextButton.layer.borderWidth = 1;
    }
    
//    [self.nextButton setImage:self.featureImage forState:UIControlStateNormal];
    self.nextButton.frame = CGRectMake(buttonX, TYGetUIScreenHeight - startBtnToBottom - buttonH , buttonW, buttonH);
    
    if (IS_IPHONE_X_Later) {
        
        self.nextButton.frame = CGRectMake(buttonX, TYGetUIScreenHeight - IPhoneXStartBtnToBottom - buttonH , buttonW, buttonH);
        
    }
}

- (void)goToHomeVc{
//    UIViewController *yzgSelectedRoleViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
//
//    [self presentViewController:yzgSelectedRoleViewController animated:YES completion:nil];
    
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    [jlgAppDelegate setRootViewController];
    
}

- (void)dealloc
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
//    [_firstTimer invalidate];
//    _firstTimer = nil;
//    [_secondTimer invalidate];
//    _secondTimer = nil;
//    [_thirdTimer invalidate];
//    _thirdTimer = nil;
//    [_fourthTimer invalidate];
//    _fourthTimer = nil;

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



//-(void)aniaml_one
//{
//    [UIView animateWithDuration:2 animations:^{
//    self.subImageview_one.transform = CGAffineTransformMakeTranslation(0, -30);
//        
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//    self.subImageview_one.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//        
//    }];
//}
//-(void)aniaml_two
//{
//    [UIView animateWithDuration:2 animations:^{
//        self.subImageview_two.transform = CGAffineTransformMakeTranslation(0, -30);
//        
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            self.subImageview_two.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//        
//    }];
//}
//-(void)aniaml_three
//{
//    [UIView animateWithDuration:2 animations:^{
//        self.subImageview_three.transform = CGAffineTransformMakeTranslation(0, -30);
//        
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            self.subImageview_three.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//        
//    }];
//}
//-(void)aniaml_four
//{
//    [UIView animateWithDuration:2 animations:^{
//        self.subImageview_four.transform = CGAffineTransformMakeTranslation(0, -30);
//        
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            self.subImageview_four.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//        
//    }];
//}
@end
