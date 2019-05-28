//
//  JGJQRCodeVc.m
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJQRCodeVc.h"
#import "JGJJoinGroupVc.h"
#import "JGJCreateGroupVc.h"
#import "CustomAlertView.h"
#import "JGJPerInfoVc.h"
#import "JGJWebLoginViewController.h"

#import "JGJWebAllSubViewController.h"

#import "TYPredicate.h"
#import "JGJDataManager.h"

@interface JGJQRCodeVc ()
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation JGJQRCodeVc

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"扫描二维码";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhotoRightBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //web页面隐藏头子使用
    if (self.QRCodeVcBlock) {
        
        self.QRCodeVcBlock();
    }
}

//进入下一个界面
- (void)showNextVCWithScanResult:(LBXScanResult*)strResult{
    
    //会议处理
    if ([strResult.strScanned containsString:@"meeting"]) {
        
        //首页的话新建webView,会议扫描的话回传数据
        BOOL isCreatWebVc = NO;
        
        for (JGJWebAllSubViewController *webVc in self.navigationController.viewControllers) {
            
            if ([webVc isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
                
                if (webVc.responseCallback) {
                    
                    NSDictionary *scanDic = @{@"url" : strResult.strScanned?:@""};
                    
                    webVc.responseCallback(scanDic);
                    
                    isCreatWebVc = YES;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                break;
            }
            
        }
        
        
        if (!isCreatWebVc) {
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:strResult.strScanned];
            
            [self.navigationController pushViewController:webVc animated:YES];

        }
        
        return;
    }
    
    NSDictionary *parameters = [self dicWithString:strResult.strScanned];
    
    if ([strResult.strScanned containsString:@"equipment/record"] && ![NSString isEmpty:strResult.strScanned]) {
        
       JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:strResult.strScanned];
        
       [self.navigationController pushViewController:webVc animated:YES];
        
        return;
    }
    
    if ([parameters[@"class_type"] isEqualToString:@"addFriend"]) {
        
        // 设置好友来源为扫码添加
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromQRCode;

        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.uid = parameters[@"uid"];
        perInfoVc.jgjChatListModel.group_id = parameters[@"uid"];
        perInfoVc.jgjChatListModel.class_type = @"singleChat";
        [self.navigationController pushViewController:perInfoVc animated:YES];
        
    }
    
//    else if (![NSString isEmpty:strResult.strScanned] && [strResult.strScanned containsString:@"http"]) {
//
//        if ([TYPredicate isCheckUrl:strResult.strScanned]) {
//
//            JGJWebType webType = [strResult.strScanned containsString:JGJWebDomainURL] ? JGJWebTypeInnerURLType : JGJWebTypeExternalThirdPartBannerType;
//
//            if ([strResult.strScanned containsString:@"open-invite.html"]) {
//
//                webType = JGJWebTypeExternalThirdPartBannerType;
//            }
//
//            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:webType URL:strResult.strScanned];
//
//            [self.navigationController pushViewController:webVc animated:YES];
//
//        }
//
//    }
    
    else if ([parameters[@"class_type"] isEqualToString:@"team"] || [parameters[@"class_type"] isEqualToString:@"groupChat"]) {
        
        [self loadNetData:parameters];
    } else if ([parameters[@"class_type"] isEqualToString:@"group"]){
        
        [TYShowMessage showPlaint:@"对不起，你是吉工宝用户，无法加入班组"];
        [self reStartDevice];
    }else if ([[parameters allKeys]containsObject:@"qrcode_token"])
    {
//烧面二维码登录
        JGJWebLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"JGJWebLoginViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWebLoginVC"];
        [loginVC setValue:parameters forKey:@"paramDic"];
        loginVC.qrcode_token = parameters[@"qrcode_token"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    else {
    
        [TYShowMessage showPlaint:@"来自火星的二维码，无法识别！"];
        [self reStartDevice];
    }
}

- (void)loadNetData:(NSDictionary *)parameters {

    [JLGHttpRequest_AFN PostWithNapi:JGJCreateQrcodeURL parameters:parameters success:^(id responseObject) {
        self.proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
    } failure:^(NSError *error) {
        [self reStartDevice];
//        CustomAlertView *alertView = [CustomAlertView showWithMessage:@"该二维码已失效" leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:@"我知道了"];
//        alertView.messageLabel.font = [UIFont systemFontOfSize:AppFont32Size];
//        __weak typeof(self) weakSelf = self;
//        alertView.onOkBlock = ^{
//            [weakSelf reStartDevice];
//        };
    }];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    _proListModel = proListModel;
    JGJJoinGroupVc *joinGroupVc = [JGJJoinGroupVc new];
    joinGroupVc.proListModel = _proListModel;
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

- (NSDictionary *)dicWithString:(NSString *)qrcodeStr {
    //    http://api.ex.yzgong.com/?inviter_uid=100008576&time=1473242907&class_type=group&group_id=11
    NSRange range = [qrcodeStr rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        NSString *qrCodeStr = [qrcodeStr substringFromIndex:range.location + 1];
        qrCodeStr = [qrCodeStr stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        NSArray *qrCodes = [qrCodeStr componentsSeparatedByString:@"&"];
        NSMutableDictionary *qrcodeDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < qrCodes.count; i ++) {
            NSString *valueStr = qrCodes[i];
            NSString *keyStr = [valueStr substringToIndex:[valueStr rangeOfString:@":"].location];
            
            //全局用group_id
            if ([keyStr isEqualToString:@"team_id"]) {
                
                keyStr = @"group_id";
            }
            
            NSString *value = [valueStr substringFromIndex:[valueStr rangeOfString:@":"].location + 1];
            [qrcodeDic setObject:value forKey:keyStr];
        }
        return qrcodeDic;
    }
    return nil;
}

- (void)openPhotoRightBarButtonItem:(UIBarButtonItem *)item {
    
    if ([LBXScanWrapper isGetPhotoPermission]){
        
        [self openLocalPhoto];
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置->隐私中开启本程序相册权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)showMaskView {
    
    self.topTitle.text = @"";//无数据不要提示
    
    if (self.maskView) {
        
        [self.maskView removeFromSuperview];
        
    }
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.maskView = maskView;
    
    UILabel *errorTipsLable = [UILabel new];
    
    errorTipsLable.font = [UIFont systemFontOfSize:AppFont40Size];
    
    errorTipsLable.textAlignment = NSTextAlignmentCenter;
    
    errorTipsLable.numberOfLines = 0;
    
    errorTipsLable.textColor = [UIColor whiteColor];
    
    errorTipsLable.text = @"无法识别二维码\n点击屏幕继续扫描";
    
    [errorTipsLable markLineText:@"点击屏幕继续扫描" withLineFont:[UIFont systemFontOfSize:AppFont32Size] withColor:AppFont999999Color lineSpace:2];
    
    [maskView addSubview:errorTipsLable];
    
    errorTipsLable.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2, TYGetViewW(self.qRScanView), TYGetViewH(self.qRScanView));
    
    [errorTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(maskView.mas_centerX);
        
        make.centerY.mas_equalTo(maskView.mas_centerY).mas_offset(-50);
        
        make.width.mas_equalTo(300);
        
        make.height.mas_equalTo(71);
    }];
    
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    
    tap.numberOfTapsRequired = 1;
    
    [maskView addGestureRecognizer:tap];
    
}

#pragma mark - 点击蒙层
- (void)tapMaskView {
    
    if (self.maskView) {
        
        [self.maskView removeFromSuperview];
    }
    
}


@end
