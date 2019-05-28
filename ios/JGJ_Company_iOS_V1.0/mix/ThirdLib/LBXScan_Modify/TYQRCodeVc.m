//
//  TYQRCodeVc.m
//  Test
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 test. All rights reserved.
//

#import "TYQRCodeVc.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"

#import "TYPredicate.h"

#import "JGJWebAllSubViewController.h"

@interface TYQRCodeVc ()

@end

@implementation TYQRCodeVc

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = NO;
    
    [self setStyle];
}

- (void)setStyle{
    if (!self.style) {
        //设置扫码区域参数
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
        style.photoframeLineW = 3;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = NO;
        
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        style.colorAngle = JGJMainColor;
        
        style.animationImage = [UIImage imageNamed:@"scan_laser"];
        self.style = style;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self drawTitle];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        
        CGFloat qRScanViewWH = self.qRScanView.frame.size.width - self.style.xScanRetangleOffset*2;
        //计算topTile的Y值
        CGSize sizeRetangle = CGSizeMake(qRScanViewWH, qRScanViewWH);
        
        CGFloat YMinRetangle = self.view.frame.size.height / 2.0 - self.style.centerUpOffset + sizeRetangle.height*0.5 + 40;
        
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, YMinRetangle);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, YMinRetangle);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
//        _topTitle.text = @"将二维码放入框内";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
    
    [self.view bringSubviewToFront:_topTitle];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        TYLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    BOOL isWorRule = [self isProStyleWithScanStrResult:strResult];
    
    if (isWorRule) {
        
        //URL地址直接打开
        
        if ([TYPredicate isCheckUrl:strResult]) {
            
            TYLog(@"扫码地址strResult-----------%@", strResult);
            
            BOOL isContainDomainURL = [strResult containsString:JGJWebDomainURL];
            
            JGJWebType webType = isContainDomainURL ? JGJWebTypeInnerURLType : JGJWebTypeExternalThirdPartBannerType;
            
            if ([strResult containsString:@"open-invite.html"]) {
                
                webType = JGJWebTypeExternalThirdPartBannerType;
            }
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:webType URL:strResult];
            
            [self.navigationController pushViewController:webVc animated:YES];
            
            return;
            
        }
    }
    
    if (!strResult || isWorRule) {
        
        [self popAlertMsgWithScanResult:nil];
        
        [self showMaskView];
        
        return;
    }
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
    
}

#pragma mark - 子类判断有误二维码加上蒙层
- (void)showMaskView {
    
    
}

- (void)showError:(NSString*)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        strResult = @"识别失败";
    }
    
    TYLog(@"xxxx strResult = %@",strResult);
    //点击完，继续扫码
    [self reStartDevice];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    //如果设置了代理就走代理，如果没有设置就走继承
    if (self.delegate && [self.delegate respondsToSelector: @selector(QRCodeVc:scanResult:)]) {
        [self.delegate QRCodeVc:self scanResult:strResult];
        [self.navigationController popViewControllerAnimated: YES];
    }
    TYLog(@"xxxx 进入下一个界面");
}

#pragma mark - 扫码后是不是满足项目满足的条件 项目/班组二维码 群聊二维码 用户二维码 设备二维码
- (BOOL)isProStyleWithScanStrResult:(NSString *)strResult {
    
    BOOL isExistStyle = [strResult containsString:@"addFriend"] ||
    [strResult containsString:@"qrcode_token"] ||
    [strResult containsString:@"equipment/record"] ||
    [strResult containsString:@"group"] ||
    [strResult containsString:@"addFriend"] ||
    [strResult containsString:@"team"];
    
    return !isExistStyle;
    
}
@end
