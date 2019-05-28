//
//  JGJRecruitmentController.m
//  mix
//
//  Created by Json on 2019/4/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRecruitmentController.h"
#import <React/RCTRootView.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>


#import "JGJWebAllSubViewController.h"
#import "TYPhone.h"
#import "JGJDataManager.h"
#import "JGJAddFriendSendMsgVc.h"
#import "JGJChatRootVc.h"
#import "JGJShareMenuView.h"
#import "JGJCustomShareMenuView.h"
#import "NSString+JSON.h"
#import "JGJCustomPopView.h"
#import "JLGLoginViewController.h"
#import <react-native-image-picker/ImagePickerManager.h>
#import "JGJMapViewController.h"
#import "JGJPosition.h"
#import "JGJCheckPhotoTool.h"

static JGJRecruitmentController *_recruitmentVc;

@interface JGJRecruitmentController ()<RCTBridgeModule,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) BOOL shouldHideTabBar;

@property (nonatomic, copy) RCTResponseSenderBlock didPickImageBlcok;

@end

@implementation JGJRecruitmentController

RCT_EXPORT_MODULE();

- (void)viewDidLoad {
    [super viewDidLoad];
    _recruitmentVc = self;
    
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.height;
    [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(statusBarH);
        make.bottom.mas_equalTo(self.view).offset(-tabBarH);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = self.shouldHideTabBar;
    
}


#pragma mark - UIImagePickerControllerDelegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (@available(iOS 11.0, *)) {
//        NSURL *imageURL = info[UIImagePickerControllerImageURL];
//
//        _recruitmentVc.didPickImageBlcok(@[imageURL.absoluteString]);
//    } else {
//        // Fallback on earlier versions
//    }
//}



#pragma mark - RN与原生通信方法

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

#pragma mark - 打开图片浏览器

RCT_EXPORT_METHOD(previewImage:(id)data){
    
    NSArray *imageUrls = data[@"imgData"];
    
    NSString *imgDiv =  data[@"imgDiv"];
    
    NSString *imgIndexStr = [NSString stringWithFormat:@"%@", data[@"imgIndex"]];
    
    NSInteger imgIndex = [imgIndexStr integerValue];
    
    NSMutableArray *imageArray = [NSMutableArray new];
    
    NSMutableArray *imageMergeUrls = [NSMutableArray new];
    
    for (NSInteger index = 0; index < imageUrls.count; index++) {
        
        UIImageView *imageView = [UIImageView new];
        
        imageView.image = [UIImage imageNamed:@"defaultPic"];
        
        [imageArray addObject:imageView];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", imgDiv,imageUrls[index]];
        
        [imageMergeUrls addObject:url];
        
    }
    
    [JGJCheckPhotoTool webBrowsePhotoImageView:imageMergeUrls selImageViews:imageArray didSelPhotoIndex:imgIndex];
}


#pragma mark - 打开地图页面

RCT_EXPORT_METHOD(openMapView:(id)data){
    TYLog(@"openMapView====>%@",data);
    JGJPosition *position = [JGJPosition mj_objectWithKeyValues:data];
    JGJMapViewController *mapController = [[JGJMapViewController alloc] init];
    mapController.postion = position;
    [_recruitmentVc.navigationController pushViewController:mapController animated:YES];
}

#pragma mark - 点击支付按钮,进行支付

RCT_EXPORT_METHOD(appPay:(NSString *)data :(RCTResponseSenderBlock)callBack){
//    TYLog(@"99999999======>%@",data);
    
    JGJWeiXin_pay *weiXin_pay = [JGJWeiXin_pay sharedManager];
    
    JGJAppBuyCombo *ComboModel = [JGJAppBuyCombo mj_objectWithKeyValues:data];
    
    JGJOrderListModel *orderListModel = [[JGJOrderListModel alloc]init];
    
    orderListModel.pay_type = ComboModel.pay_type;
    
    ComboModel.record_id = [ComboModel.record_id stringByReplacingOccurrencesOfString:@";"withString:@"&"];
    
    if ([ComboModel.pay_type isEqualToString:@"2"]) {
        //支付宝支付
        [weiXin_pay doAlipayPaypayCode:ComboModel.record_id andmodel:orderListModel];
    }else{
        
        JGJweiXinPaymodel *payModel = [JGJweiXinPaymodel mj_objectWithKeyValues:ComboModel.record_id];
        //微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = payModel.partnerid;//商户id
        req.prepayId            = payModel.prepayid;//订单号
        req.nonceStr            = payModel.noncestr;//随机字符串
        req.timeStamp           = payModel.timestamp;//时间戳
        req.package             = payModel.package;
        req.sign                = payModel.sign;
        weiXin_pay.payId        = payModel.prepayid;
        
        //保存订单号
        payModel.order_sn          = payModel.order_sn;
        if (!weiXin_pay.orderListmodel) {
            weiXin_pay.orderListmodel = [[JGJOrderListModel alloc]init];
        }
        weiXin_pay.orderListmodel = orderListModel;
        
        [WXApi sendReq:req];
    }
    
    weiXin_pay.paysuccess = ^(JGJOrderListModel * model) {
        
        NSDictionary *callBackDic = @{@"state" :@(1)};
        
        if (!model.paySucees) {
            
            callBackDic = @{@"state" :@(0)};
            
        }
        
        NSString *bugStatusJson = [NSString getJsonByData:callBackDic];
        
        callBack(@[bugStatusJson]);
    };

    
}

//RCT_EXPORT_METHOD(singleSelectPicture:(NSString *)msg :(RCTResponseSenderBlock)callBack){
//
//    TYLog(@"singleSelectPicture");
//
//    _recruitmentVc.didPickImageBlcok = callBack;
//
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
//
//    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
//        imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePickerVc.delegate = self;
//        [_recruitmentVc presentViewController:imagePickerVc animated:YES completion:nil];
//    }];
//    [alertVc addAction:albumAction];
//
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
//        imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [_recruitmentVc presentViewController:imagePickerVc animated:YES completion:nil];
//    }];
//
//    [alertVc addAction:cameraAction];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//    }];
//
//    [alertVc addAction:cancelAction];
//
//    [_recruitmentVc presentViewController:alertVc animated:YES completion:nil];
//
//}


#pragma mark token失效,打开登录页面

RCT_EXPORT_METHOD(login){
    JLGLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    [_recruitmentVc.navigationController pushViewController:loginVC animated:YES];
    loginVC.backVc = _recruitmentVc;
    __weak typeof(_recruitmentVc) weakSelf = _recruitmentVc; //2.1.0 -yj登录进来刷新页面
    loginVC.handleWebViewRefreshBlock = ^(UIViewController *backVc, BOOL isRefresh){
        if (isRefresh) {
        }
    };
}

#pragma mark 复制微信号,并打开微信

RCT_EXPORT_METHOD(copyWechatNumber:(NSString *)num){
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:num];
    
    [_recruitmentVc openWXApp:num];
}

#pragma mark 隐藏tabbar

RCT_EXPORT_METHOD(footerController:(id)data){
    CGFloat insetBottom = 0;
    if ([data[@"state"] isEqualToString:@"hide"]) {
        _recruitmentVc.tabBarController.tabBar.hidden = YES;
        _recruitmentVc.shouldHideTabBar = YES;
        
        if (@available(iOS 11.0, *)) {
            // 适配iPhoneX
            insetBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        }
    } else if([data[@"state"] isEqualToString:@"show"]){
        _recruitmentVc.tabBarController.tabBar.hidden = NO;
        _recruitmentVc.shouldHideTabBar = NO;
        
        if (@available(iOS 11.0, *)) {
            // 适配iPhoneX
            CGFloat windowInsetBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
            
            insetBottom = windowInsetBottom + 49;
        } else {
            insetBottom = 49;
        }
    }
    [_recruitmentVc.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_recruitmentVc.view).offset(-insetBottom);
    }];
    
    
}
#pragma mark  打开webview,加载网页

RCT_EXPORT_METHOD(openWebView:(NSString *)path){
    NSString *url = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,path];
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];   webVc.hidesBottomBarWhenPushed = YES;
    [_recruitmentVc.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - 获取token并传递

RCT_EXPORT_METHOD(getAppToken:(NSString *)msg :(RCTResponseSenderBlock)callback){
    NSString *token = [TYUserDefaults objectForKey:JLGToken];
    callback(@[token]);
}

#pragma mark  调用打电话

RCT_EXPORT_METHOD(appCall:(NSString *)number){
    [TYPhone callPhoneByNum:number view:_recruitmentVc.view];
}

#pragma mark  调起分享面板

RCT_EXPORT_METHOD(showShareMenu:(id)data :(RCTResponseSenderBlock)callback){
    
        
        //type 0 普通分享 1朋友圈 2微信
        NSDictionary *dic = (NSDictionary *)data;
        
        JGJShowShareMenuModel *shareModel = [JGJShowShareMenuModel mj_objectWithKeyValues:dic];
        
        if (shareModel.type == 0) {
            
            TYLog(@"showShareMenu == %@", data);
            
            
            if (shareModel.topdisplay == 1) {
                
                JGJShareMenuView *shareMenuView = [[JGJShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                
                shareMenuView.Vc = _recruitmentVc;
                
                [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
                
                shareMenuView.shareButtonPressedBlock = ^(JGJShareType type) {

                    //回调给H5
                    callback(@[@{}]);
                    
                };
            } else {
                JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                
                shareMenuView.Vc = _recruitmentVc;
                
                [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
                
                shareMenuView.shareButtonPressedBlock = ^(JGJShareMenuViewType type) {
                    // 如果是吉工家好友,工友圈,面对面分享,不进行回调
                    if (type == JGJShareMenuViewJGJFriendlyType
                     || type == JGJShareMenuViewWorkCircleType
                     || type == JGJShareMenuViewFaceToFaceType) {
                        return;
                    }
                    //回调给H5
                    callback(@[@{}]);
                    
                };
            }
            
        }else {
            
            if (shareModel.topdisplay == 1) {
                
                JGJShareMenuView *shareMenuView = [[JGJShareMenuView alloc] init];
                
                shareMenuView.shareMenuModel = shareModel;
                
                NSArray *snsNames = @[@"", @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatSession),  @(UMSocialPlatformType_QQ)];
                
                NSArray *snsNameTypes = @[@"0", @(JGJShareTypeWXType), @(JGJShareTypeWXChatType), @(JGJShareTypeQQType)];
                
                UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
                
                if (shareModel.type <= 3 && shareModel.type > 0) {
                    
                    platformType = [snsNames[shareModel.type] integerValue];
                    
                    shareMenuView.shareMenuViewType = [snsNameTypes[shareModel.type] integerValue];
                }
                
                [shareMenuView shareInVc:_recruitmentVc linkUrl:shareModel.url?:@"" platformType:platformType text:shareModel.describe?:@"" imageUrl:shareModel.imgUrl];
                
            } else {
                
                JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] init];
                
                shareMenuView.shareMenuModel = shareModel;
                
                //                    weakSelf.shareMenuView = shareMenuView;
                
                NSArray *snsNames = @[@"", @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatSession),  @(UMSocialPlatformType_QQ)];
                
                NSArray *snsNameTypes = @[@"0", @(JGJShareMenuViewWXType), @(JGJShareMenuViewWXChatType), @(JGJShareMenuViewQQType)];
                
                UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
                
                if (shareModel.type <= 3 && shareModel.type > 0) {
                    
                    platformType = [snsNames[shareModel.type] integerValue];
                    
                    shareMenuView.shareMenuViewType = [snsNameTypes[shareModel.type] integerValue];
                }
                
                [shareMenuView shareInVc:_recruitmentVc linkUrl:shareModel.url?:@"" platformType:platformType text:shareModel.describe?:@"" imageUrl:shareModel.imgUrl];
            }
        }
        
    
}
#pragma mark  进入聊天

RCT_EXPORT_METHOD(createChat:(id)data){
    TYLog(@"发起聊天data===%@", data);
    
    JGJChatFindJobModel *chatModel = [JGJChatFindJobModel mj_objectWithKeyValues:data];
    
    if ([chatModel.page isEqualToString:@"job"]) {
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromFindJobs;
    } else if ([chatModel.page isEqualToString:@"dynamic"]) {
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromWorkmateCommunity;
    } else if ([chatModel.page isEqualToString:@"connection"]) {
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromConnection;
    }
    
//    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
//    if ([myUid isEqualToString:chatModel.group_id]) {
//        [TYShowMessage showSuccess:@"当前不能和自己聊天"];
//        return ;
//    }
    if (chatModel.is_chat) {
        
        [_recruitmentVc handleH5ChatRecruitWithDic:data];
        
    }else {
        
        JGJAddFriendSendMsgVc *sendMsgVc = [_recruitmentVc handleAddFriendWithChatModel:chatModel];
        
        TYWeakSelf(self);
        
        sendMsgVc.sendMsgSuccessBlock = ^(NSDictionary *response) {
            
//            if (responseCallback) {
//
//                responseCallback(chatModel.group_id);
//
//            }
            
        };
    }
}

#pragma mark  获取地理位置

RCT_EXPORT_METHOD(getLocation:(id)data :(RCTResponseSenderBlock)callback){
    
    NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *city = [TYUserDefaults objectForKey:JLGCityName];
    
    NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
    
    NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
    
    NSString *province = [TYUserDefaults objectForKey:JLGProvinceName];
    
    //    adcode = @"510100";
    //
    //    city = @"成都市";
    //
    //    lat = @"30.553262";
    //
    //    lng = @"104.067372";
    //
    //    province = @"四川省";
    
    NSDictionary *callBackDic = @{@"adcode" : adcode?:@"",
                                  
                                  @"city" : city?:@"",
                                  
                                  @"lat" : lat?:@"",
                                  
                                  @"lng" : lng ?:@"",
                                  
                                  @"province" : province?:@""
                                  
                                  };
    
    NSString *localJson = [NSString getJsonByData:callBackDic];
    
    callback(@[localJson]);

}

#pragma mark - 私有方法

- (void)handleH5ChatRecruitWithDic:(NSDictionary *)dic {
    
    JGJChatRecruitMsgModel *chatRecruitMsgModel = [JGJChatRecruitMsgModel mj_objectWithKeyValues:dic];
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    //    chatFindJobModel.isProDetail = YES; //招工信息进入聊天页面
    
    //    proListModel.chatfindJobModel = chatFindJobModel;
    proListModel.class_type = @"singleChat";
    //
    //这句是保证group_id唯一性用了setter方法
    
    proListModel.team_id = nil;
    
    proListModel.team_name = nil;
    //
    proListModel.group_id = chatRecruitMsgModel.group_id; //个人uid
    
    proListModel.group_name = chatRecruitMsgModel.group_name;
    
    proListModel.is_find_job = YES;
    
    //    //先赋值招聘信息
    //    chatRootVc.chatRecruitMsgModel = chatRecruitMsgModel;
    
    proListModel.chatRecruitMsgModel = chatRecruitMsgModel;
    
    //在赋值组信息
    chatRootVc.workProListModel = proListModel;
    
    _recruitmentVc.navigationController.navigationBarHidden = NO;
    [_recruitmentVc.navigationController pushViewController:chatRootVc animated:YES];
    
//    TYWeakSelf(self);
    
//    chatRootVc.chatRootBackBlock = ^{
//
//        weakself.webView.frame = weakself.view.bounds;
//
//    };
}

- (JGJAddFriendSendMsgVc *)handleAddFriendWithChatModel:(JGJChatFindJobModel *)chatModel {
    JGJAddFriendSendMsgVc *addFriendSendMsgVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendSendMsgVc"];
    JGJChatPerInfoModel *perInfoModel = [JGJChatPerInfoModel new];
    perInfoModel.uid = chatModel.group_id;
    perInfoModel.top_name = chatModel.group_name;
    addFriendSendMsgVc.perInfoModel = perInfoModel;
    [self.navigationController pushViewController:addFriendSendMsgVc animated:YES];
    
    return addFriendSendMsgVc;
}

- (void)openWXApp:(NSString *)num {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = [NSString stringWithFormat:@"该微信号: %@ 已复制，请在微信中添加朋友时粘贴搜索",num];
    
    desModel.popTextAlignment = NSTextAlignmentCenter;
    
    desModel.contentViewHeight = 150;
    
    desModel.lineSapcing = 3;
    
    desModel.leftTilte = @"我知道了";
    
    desModel.rightTilte = @"打开微信";
    
    desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
    
    desModel.titleFont = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.onOkBlock = ^{
        
        //创建一个url，这个url就是WXApp的url，记得加上：//
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        
        //打开url
        [[UIApplication sharedApplication] openURL:url];
        
    };
    
}





@end
