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
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic)  TYButton *wx_Button;
@property (strong, nonatomic)  TYButton *QQ_Button;
@property (strong, nonatomic)  TYButton *QQ_zone_Button;
@property (strong, nonatomic)  TYButton *wx_friend_Button;

@property (strong, nonatomic)  UILabel *departLable;
@property (strong, nonatomic)  UILabel *leftdepartLable;
@property (strong, nonatomic)  UILabel *centerdepartLable1;

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

- (UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 80)];
        _shareView.backgroundColor = [UIColor whiteColor];
        [_shareView addSubview:self.QQ_Button];
        [_shareView addSubview:self.wx_Button];
        [_shareView addSubview:self.QQ_zone_Button];
        [_shareView addSubview:self.wx_friend_Button];
        [_shareView addSubview:self.departLable];
        [_shareView addSubview:self.leftdepartLable];
        [_shareView addSubview:self.centerdepartLable1];
    }
    return _shareView;
}
- (TYButton *)QQ_Button
{
    if (!_QQ_Button) {
        
        _QQ_Button = [[TYButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*3, 0, TYGetUIScreenWidth/4, 80)];
        [_QQ_Button setTitle:@"QQ" forState:UIControlStateNormal];
        [_QQ_Button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        _QQ_Button.titleLabel.font = [UIFont systemFontOfSize:11];
        [_QQ_Button setImage:[UIImage imageNamed:@"RecordWorkpoints_QQ"] forState:UIControlStateNormal];
        [_QQ_Button addTarget:self action:@selector(clickQQ:) forControlEvents:UIControlEventTouchUpInside];
        _QQ_Button.tag = 1;
    }
    return _QQ_Button;
}
- (TYButton *)wx_Button
{
    if (!_wx_Button) {
        _wx_Button = [[TYButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*2, 0, TYGetUIScreenWidth/4, 80)];
        [_wx_Button setTitle:@"微信好友" forState:UIControlStateNormal];
        [_wx_Button setImage:[UIImage imageNamed:@"RecordWorkpoints_wx"] forState:UIControlStateNormal];
        [_wx_Button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        _wx_Button.titleLabel.font = [UIFont systemFontOfSize:11];
        [_wx_Button addTarget:self action:@selector(clickWX:) forControlEvents:UIControlEventTouchUpInside];
        _wx_Button.tag = 3;

    }
    return _wx_Button;

}
-(TYButton *)wx_friend_Button
{
    if (!_wx_friend_Button) {
        _wx_friend_Button = [[TYButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*0, 0, TYGetUIScreenWidth/4+ 4, 80)];
        [_wx_friend_Button setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        [_wx_friend_Button setImage:[UIImage imageNamed:@"JGJWXChat"] forState:UIControlStateNormal];
        [_wx_friend_Button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        _wx_friend_Button.titleLabel.font = [UIFont systemFontOfSize:11];
        [_wx_friend_Button addTarget:self action:@selector(clickWX_friend:) forControlEvents:UIControlEventTouchUpInside];
        _wx_friend_Button.tag = 4;
        
    }
    return _wx_friend_Button;
}
-(TYButton *)QQ_zone_Button
{
    if (!_QQ_zone_Button) {
        _QQ_zone_Button = [[TYButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*1, 0, TYGetUIScreenWidth/4, 80)];
        [_QQ_zone_Button setTitle:@"QQ空间" forState:UIControlStateNormal];
        [_QQ_zone_Button setImage:[UIImage imageNamed:@"JGJQQZone"] forState:UIControlStateNormal];
        [_QQ_zone_Button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        _QQ_zone_Button.titleLabel.font = [UIFont systemFontOfSize:11];
        [_QQ_zone_Button addTarget:self action:@selector(clickQQ_zone:) forControlEvents:UIControlEventTouchUpInside];
        _QQ_zone_Button.tag = 5;
        
    }
    return _QQ_zone_Button;


}
- (UILabel *)departLable
{
    if (!_departLable) {
        _departLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*3, 0, 1, 80)];
        _departLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _departLable;
}
-(UILabel *)leftdepartLable
{
    if (!_leftdepartLable) {
        _leftdepartLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*2, 0, 1, 80)];
        _leftdepartLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _leftdepartLable;


}
-(UILabel *)centerdepartLable1
{
    if (!_centerdepartLable1) {
        _centerdepartLable1 = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*1, 0, 1, 80)];
        _centerdepartLable1.backgroundColor = AppFontdbdbdbColor;
    }
    return _centerdepartLable1;

}
- (void)commonInit{

    
    _isAnimateing = NO;
    [[NSBundle mainBundle] loadNibNamed:@"JGJShareBillView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    self.bottomViewLayoutH.constant = bottomViewHRation*TYGetUIScreenHeight;
    [self.detailContentView.layer setLayerShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:20];
    [self.detailContentView addSubview:self.shareView];

}
- (void)clickQQ:(UIButton *)sender
{
    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillQQBtnClick:snsName:)]) {
        [self.delegate ShareBillQQBtnClick:self snsName:@"qq"];
    }
    [self hiddenShareBillView];
}

- (void)clickWX:(UIButton *)sender
{
    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillWxBtnClick:snsName:)]) {
        [self.delegate ShareBillWxBtnClick:self snsName:@"wxsession"];
    }
    [self hiddenShareBillView];

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
//微信朋友圈
-(void)clickWX_friend:(id)sender
{

    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillWxBtnClick:snsName:)]) {
        [self.delegate ShareBillWxBtnClick:self snsName:@"wechatTime"];
    }
    [self hiddenShareBillView];

}
//QQ空间
-(void)clickQQ_zone:(id)sender
{
    [self shareBtnClick:sender];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(ShareBillWxBtnClick:snsName:)]) {
        [self.delegate ShareBillWxBtnClick:self snsName:@"qZone"];
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
    }else if (sender.tag == 4){
        [self shareInVc:self.Vc linkUrl:self.sharelinkUrl snsName:@"wxtimeline" text:self.shareText imageUrl:self.shareImageUrl];

    }else if (sender.tag == 5){
        [self shareInVc:self.Vc linkUrl:self.sharelinkUrl snsName:@"qzone" text:self.shareText imageUrl:self.shareImageUrl];

    
    }
}

- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl snsName:(NSString *)snsName text:(NSString *)text imageUrl:(NSString *)imageUrl {
//
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
//        }else if([snsName isEqualToString:@"wxsession"]){
//            //微信
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = linkUrl;
//        }else if ([snsName isEqualToString:@"qzone"])
//        {
//            [UMSocialData defaultData].extConfig.qzoneData.url = linkUrl;
//
//        }else{
//            [UMSocialData defaultData].extConfig.wechatTimelineData.url = linkUrl;
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
