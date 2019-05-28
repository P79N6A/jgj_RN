//
//  JGJShareMenuView.m
//  mix
//
//  Created by Json on 2019/4/8.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJShareMenuView.h"
#import "TYAnimate.h"
#import "UIImage+Cut.h"
#import "CALayer+SetLayer.h"
#import "SDWebImageManager.h"

#import "JGJWebAllSubViewController.h"

#import "UIImage+TYALAssetsLib.h"

#import "UIImage+TYCreateQRCode.h"
#import "JGJConversationSelectionVc.h"

static const CGFloat bottomViewHRation = 80.f/667.f;//效果图比例
@interface JGJShareMenuView (){
    BOOL _isAnimateing;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (weak, nonatomic) IBOutlet UIView *contentBtnMenuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutH;


@property (weak, nonatomic) IBOutlet UIButton *savePhotoBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *savePhotoBtnH;



@end


@implementation JGJShareMenuView

- (void)showCustomShareMenuViewWithShareMenuModel:(JGJShowShareMenuModel *)ShareMenuModel {
    
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
    }
    
    if (!ShareMenuModel.is_show_savePhoto) {
        
        self.savePhotoBtnH.constant = 0;
        
        self.savePhotoBtn.hidden = YES;
    }
    
    self.contentDetailView.y = TYGetUIScreenHeight;
    
    self.contentDetailView.hidden = NO;
    
    
    if (!_isAnimateing) {
        _isAnimateing = YES;
        
        CGFloat y = TYGetUIScreenHeight - self.contentDetailView.height - JGJ_IphoneX_BarHeight;
        
        //添加动画
        CGRect detailContentFrame = CGRectMake(0, y, TYGetViewW(self.contentView), self.contentDetailView.height);
        
        [TYAnimate showWithView:self.contentDetailView byStartframe:detailContentFrame endFrame:detailContentFrame byBlock:^{
            
            _isAnimateing = NO;
        }];
        
    }
    
    self.shareMenuModel = ShareMenuModel;
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
    [[NSBundle mainBundle] loadNibNamed:@"JGJShareMenuView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    self.bottomViewLayoutH.constant = bottomViewHRation*TYGetUIScreenHeight;
    [self.contentDetailView.layer setLayerShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:20];
    
    self.contentDetailView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    
    [self.contentBtnMenuView.layer setLayerCornerRadius:5];
    
    [self.savePhotoBtn.layer setLayerCornerRadius:5];
    
    [self.cancelBtn.layer setLayerCornerRadius:5];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.shareMenuModel.is_show_savePhoto) {
        
        //点击按钮后回调H5
        if (self.shareButtonPressedBlock) {
            
            self.shareButtonPressedBlock(self.shareMenuViewType);
        }
    }
    
    [self hiddenCustomShareMenuView];
}

- (void)hiddenCustomShareMenuView {
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.contentDetailView.y = TYGetUIScreenHeight;
            
            self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
            
        } completion:^(BOOL finished){
            
            if (finished)
            {
                self.hidden = YES;
                
                [self removeFromSuperview];
                
            }
        }];
        
    }
}

- (BOOL)sendMiniProgramWithShareMenuModel:(JGJShowShareMenuModel *)shareModel
{
    [self removeFromSuperview];
    
    UIImage *image = nil;
    
    if (![NSString isEmpty:shareModel.wxMini.typeImg]) {
        
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",shareModel.wxMini.typeImg]];
        
    }else {
        
        if (shareModel.wxMini.wxMiniImage) {
            
            image = shareModel.wxMini.wxMiniImage;;
            
        }else {
            
            image = [UIImage viewSnapshot:self.Vc.view withInRect:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, 0.8 * TYGetUIScreenWidth)];
        }
        
    }
    
    if (!image) {
        
        image = [UIImage viewSnapshot:self.Vc.view withInRect:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, 0.8 * TYGetUIScreenWidth)];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    CGFloat ration = 120 * 1024 / data.length;
    
    if (ration < 1) {
        
        data = UIImageJPEGRepresentation(image, ration * 0.8);
    }
    
    WXMiniProgramObject *ext = [WXMiniProgramObject object];
    
    ext.webpageUrl = shareModel.imgUrl;
    
    ext.userName = shareModel.wxMini.appId;
    
    ext.path = shareModel.wxMini.path;
    
    ext.hdImageData = data;
    
    ext.withShareTicket = nil;
    
    ext.miniProgramType = WXMiniProTypeRelease ? WXMiniProgramTypeRelease : WXMiniProgramTypePreview;
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = shareModel.title;
    
    message.description = shareModel.describe;
    
    message.mediaObject = ext;
    
    message.thumbData = nil;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.message = message;
    
    req.scene = WXSceneSession;
    
    BOOL isSend = [WXApi sendReq:req];
    
    return NO;
    
}

- (void)umnShareImage:(UIButton *)sender {
    
    self.shareMenuViewType = sender.tag - 100;
    
    NSArray *platforms = nil;
    
    platforms = [self sharePlatforms];
    UMSocialPlatformType platformType = [platforms[self.shareMenuViewType] integerValue];
    
    [self shareImageToPlatformType:platformType];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    
    //3.5.2添加外部传入图片
    
    if (self.shareMenuModel.shareImage) {
        
        shareObject.shareImage = self.shareMenuModel.shareImage;
        
    }else {
        
        //截取当前控制器的图片
        
        shareObject.shareImage = [UIImage saveScreenShotWithView:self.Vc.view offsetY:JGJ_NAV_HEIGHT isSavePhoto:self.shareMenuModel.is_show_savePhoto];
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.Vc completion:^(id data, NSError *error) {
        if (error) {
            
            TYLog(@"************Share fail with error %@*********",error);
        }else{
            
            TYLog(@"response data is %@",data);
            
        }
    }];
    
}

- (IBAction)handleShareButtonAction:(UIButton *)sender {
    
    self.shareMenuViewType = sender.tag - 100;

    //保存图片，分享图片
    
    if (self.shareMenuModel.is_show_savePhoto) {
        
        [self umnShareImage:sender];
        
        return;
    }
    
    NSArray *platforms = nil;
    
    platforms = [self sharePlatforms];
    
    UMSocialPlatformType platformType = [platforms[self.shareMenuViewType] integerValue];
    
    //点击微信好友且是分享小程序(找工作详情页分享)
    if (![NSString isEmpty:_shareMenuModel.wxMini.appId] && platformType == UMSocialPlatformType_WechatSession) {
        
        [self sendMiniProgramWithShareMenuModel:_shareMenuModel];
        
    }else {
        
        if (!TYiOS9Later) {
            
            self.shareMenuModel.url = [self.shareMenuModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }else {
            
            self.shareMenuModel.url = [self.shareMenuModel.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
        }
        
        [self shareInVc:self.Vc linkUrl:self.shareMenuModel.url platformType:platformType text:self.shareMenuModel.title imageUrl:self.shareMenuModel.imgUrl];
        
        
    }
    
    //点击按钮后回调H5
    if (self.shareButtonPressedBlock) {
        
        self.shareButtonPressedBlock(self.shareMenuViewType);
    }
    
}

- (NSArray *)sharePlatforms {
    
    NSArray *platforms = @[@(UMSocialPlatformType_WechatSession), //微信好友
                           @(UMSocialPlatformType_WechatTimeLine),//朋友圈
                           @(UMSocialPlatformType_QQ),//QQ好友
                           @(UMSocialPlatformType_Qzone), //QQ空间
                           ];
    
    return platforms;
    
}

#pragma mark - 分享给吉工家好友


- (IBAction)savePhotoBtnPressed:(UIButton *)sender {
    
    //截屏
    
    [UIImage saveScreenShotWithView:self.Vc.view offsetY:JGJ_NAV_HEIGHT isSavePhoto:YES];
    
    [self hiddenCustomShareMenuView];
    
    //点击按钮后回调H5
    if (self.shareButtonPressedBlock) {
        
        self.shareButtonPressedBlock(self.shareMenuViewType);
    }
}

- (UIImage *)screenShot {
    
    JGJShowShareMenuModel *shareModel = self.shareMenuModel;
    
    UIImage *image = nil;
    
    if (![NSString isEmpty:self.shareMenuModel.wxMini.typeImg]) {
        
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",shareModel.wxMini.typeImg]];
        
    }else {
        
        if (shareModel.wxMini.wxMiniImage) {
            
            image = shareModel.wxMini.wxMiniImage;;
            
        }else {
            
            image = [UIImage viewSnapshot:self.Vc.view withInRect:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, TYGetUIScreenWidth)];
        }
        
    }
    
    if (!image) {
        
        image = [UIImage viewSnapshot:self.Vc.view withInRect:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, TYGetUIScreenWidth)];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    CGFloat ration = 120 * 1024 / data.length;
    
    if (ration < 1) {
        
        data = UIImageJPEGRepresentation(image, ration * 0.8);
    }
    
    image = [UIImage imageWithData: data];
    
    return image;
}

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    
    //保存图片，分享图片
    
    if (self.shareMenuModel.is_show_savePhoto) {
        
        //点击按钮后回调H5
        if (self.shareButtonPressedBlock) {
            
            self.shareButtonPressedBlock(self.shareMenuViewType);
        }
        
    }
    
    [self hiddenCustomShareMenuView];
    
}



- (void)shareInVc:(UIViewController *)Vc linkUrl:(NSString *)linkUrl platformType:(UMSocialPlatformType)platformType text:(NSString *)text imageUrl:(NSString *)imageUrl {
    
    //    if ([self.delegate respondsToSelector:@selector(customShareMenuViewWithMenuView:shareMenuModel:)] && self.shareMenuViewType == JGJShareMenuViewDynamicType) {
    //
    //        [self.delegate customShareMenuViewWithMenuView:self shareMenuModel:self.shareMenuModel];
    //
    //    }
    
    NSString *title = self.shareMenuModel.title;
    
    NSString *desc = self.shareMenuModel.describe;
    
    //需求 #14806
    if (platformType == UMSocialPlatformType_WechatTimeLine) {
        
        title = [NSString stringWithFormat:@"%@，%@", self.shareMenuModel.title,self.shareMenuModel.describe];
        
        desc = @"";
    }
    
    NSString *url = self.shareMenuModel.url;
    
    if (!TYiOS9Later) {
        
        self.shareMenuModel.imgUrl = [self.shareMenuModel.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }else {
        
        self.shareMenuModel.imgUrl = [self.shareMenuModel.imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
    }
    
    [self shareWebPageToPlatformType:platformType shareInVc:Vc withTitle:title descr:desc url:url thumb:self.shareMenuModel.imgUrl];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareInVc:(UIViewController *)Vc withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb
{
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //    //创建网页内容对象
    //    NSString* thumbURL = thumb;
    
    //    UIImage *logImage = [UIImage imageNamed:@"AppIcon"];
    
    NSURL *imageUrl = [NSURL URLWithString:thumb];
    
    UIImage *logImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    NSData *data = UIImagePNGRepresentation(logImage);
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:data];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [self removeFromSuperview];
    
    //调用分享接口
#ifdef UM_Swift
    [UMShareSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:Vc completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:Vc completion:^(id data, NSError *error) {
#endif
            
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            
        }];
    }


@end
