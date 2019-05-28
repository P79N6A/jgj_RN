//
//  JGJWebAllSubViewController.h
//  mix
//
//  Created by Tony on 16/4/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBaseWebViewController.h"

#import "WebViewJavascriptBridge.h"

typedef NS_ENUM(NSUInteger, JGJWebType) {
    JGJWebTypeMineInfo = 0,//"我的资料"
    JGJWebTypePersonDetail,//"个人主页"
    JGJWebTypeCollectionMsg,//"收藏"
    JGJWebTypeReceiveMsg,//"回复"
    JGJWebTypeCommentMsg,//"评论"
    JGJWebTypeContactUs,//"联系我们"
    JGJWebTypeSetting,//"设置"
    JGJWebTypeSysMsgList,//"消息"
    JGJWebTypeCooperate,//"合作的帮手"
    JGJWebTypeMakeFriend,//"交朋友"
    JGJWebTypeNewLife,//"新生活"
    JGJWebTypeNewLifeNews, //"咨询"
    JGJWebTypeAgreement,//"协议"
    JGJWebTypeComments,//"意见反馈"
    JGJWebTypeModifyPassword,//修改密码
    JGJWebTypeModifyAboutUs,//关于我们
    JGJWebTypeDownLoadBill,//账单下载
    JGJWebTypeProjectList,//统计
    JGJWebTypeStatistics,//报表
    JGJWebTypeGameError,//游戏错误
    JGJWebTypePersonScore,//"个人主页"
    JGJWebFindHelperType, //找帮手
    JGJWebTypeDynamicType, //动态
    JGJWebTypeProDetailType, //找工作，项目详情页进入聊天页面
    JGJWebTypeMyCollection, //我的收藏
    JGJWebTypeDynamic, //动态
    JGJWebTypeInnerURLType,  //内部地址H5头子
    JGJWebTypeExternalThirdPartBannerType //第三方外部广告地址，显示头子
    
};

typedef void(^skipToNextVc)(UIViewController *nextVc);

@class JGJWebAllSubViewController;
@protocol JGJWebViewDelegate <NSObject>

- (void)webViewAddSource:(JGJWebAllSubViewController *)webView;

@end

@interface JGJWebAllSubViewController : JGJBaseWebViewController

@property (nonatomic , weak) id<JGJWebViewDelegate > delegate;

@property (nonatomic,copy) skipToNextVc skipToNextVc;

@property (nonatomic,assign) BOOL needLayout;

@property (nonatomic, assign) BOOL isExampleData;//显示隐藏顶部示例数据

@property (nonatomic,assign) BOOL isUnlogin;

@property (nonatomic, assign) BOOL isHiddenStatusBarImageView; //聊天报表不显示顶部黑条

//扫描二维码回调
@property (nonatomic, copy) WVJBResponseCallback responseCallback;

//是否需要显示关闭按钮
@property (nonatomic,assign) BOOL needCloseButton;

/**
 *  根据type选择URL
 *
 *  @param webType 网页类型
 *
 *  @return 返回webVc
 */
-(instancetype)initWithWebType:(JGJWebType )webType;

-(instancetype)initWithWebType:(JGJWebType )webType URL:(NSString *)url;

- (void)navigationBarHidden:(BOOL )hidden;
/*
 *
 *强制刷新H5页面
 */
- (void)refreashH5;

/*
 *
 *verInfo更新告知H5
 */
- (void)handleLoginInfo;

#pragma mark - 添加顶部
- (void)addTopCusNav;

@end
