//
//  JGJShareBillView.m
//  mix
//
//  Created by Tony on 16/6/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJShareBillView.h"
#import "TYButton.h"
#import "TYAnimate.h"
#import "CALayer+SetLayer.h"
#import "SDWebImageManager.h"

static const CGFloat bottomViewHRation = 80.f/667.f;//效果图比例

@interface JGJShareBillView ()
{
    BOOL _isAnimateing;
}
@property (weak, nonatomic) IBOutlet TYButton *qqButton;
@property (weak, nonatomic) IBOutlet TYButton *downloadButton;
@property (weak, nonatomic) IBOutlet TYButton *wxButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *detailContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutT;
@end

@implementation JGJShareBillView

- (void)showShareBillView{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
    }
    
    if (!_isAnimateing) {
        _isAnimateing = YES;
        //添加动画
        CGRect detailContentFrame = CGRectMake(0, TYGetViewH(self.contentView) - self.bottomViewLayoutH.constant, TYGetViewW(self.contentView), self.bottomViewLayoutH.constant);
        [TYAnimate showWithView:self.detailContentView byStartframe:detailContentFrame endFrame:detailContentFrame byBlock:^{
            _isAnimateing = NO;
        }];
    }
}

- (void)hiddenShareBillView{
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _isAnimateing = NO;
    [[NSBundle mainBundle] loadNibNamed:@"JGJShareBillView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    self.bottomViewLayoutH.constant = bottomViewHRation*TYGetUIScreenHeight;
    [self.detailContentView.layer setLayerShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:20];
}

- (IBAction)QQBtnClick:(id)sender {
    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillQQBtnClick:snsName:)]) {
        [self.delegate ShareBillQQBtnClick:self snsName:@"qq"];
    }
    [self hiddenShareBillView];
}

- (IBAction)DownLoadBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillDownLoadBtnClick:)]) {
        [self.delegate ShareBillDownLoadBtnClick:self];
    }
    [self hiddenShareBillView];
}

- (IBAction)WxBtnClick:(id)sender {
    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillWxBtnClick:snsName:)]) {
        [self.delegate ShareBillWxBtnClick:self snsName:@"wxsession"];
    }
    [self hiddenShareBillView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenShareBillView];
}

- (void)shareBtnClick:(UIButton *)sender{
    if (sender.tag == 1) {//QQ
        [self shareInVc:self.Vc linkUrl:self.sharelinkUrl snsName:@"qq" text:self.shareText imageUrl:self.shareImageUrl];
    }else if(sender.tag == 3){//微信
    [self shareInVc:self.Vc linkUrl:self.sharelinkUrl snsName:@"wxsession" text:self.shareText imageUrl:self.shareImageUrl];
    }
}

- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl snsName:(NSString *)snsName text:(NSString *)text imageUrl:(NSString *)imageUrl {

//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    //分享的图片
//    __block UIImage *shareImage;
//    NSURL *shareImageURL = [NSURL URLWithString:imageUrl];
//
//    [manager downloadImageWithURL:shareImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        //取图片
//        if (image) {
//            shareImage = image;
//        }else{
//            shareImage = [UIImage imageNamed:@"Logo"];
//        }
//        
//        if ([snsName isEqualToString:@"qq"]) {
//            //QQ
//            [UMSocialData defaultData].extConfig.qqData.url = linkUrl;
//        }else{
//            //微信
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = linkUrl;
//        }
//
//#if 0//直接分享的方式
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:text image:shareImage location:nil urlResource:nil presentedController:self.Vc completion:^(UMSocialResponseEntity * response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                TYLog(@"分享成功");
//            }
//        }];
//#else//自定义分享样式
//        [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:shareImage socialUIDelegate:Vc];
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
//        snsPlatform.snsClickHandler(Vc,[UMSocialControllerService defaultControllerService],YES);
//#endif
//    }];
}

@end
