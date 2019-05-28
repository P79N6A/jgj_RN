//
//  JGJAllWebURL.h
//  mix
//
//  Created by Tony on 16/4/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef JGJAllWebURL_h
#define JGJAllWebURL_h

// ====== 共同的URL ======
#define SettingURL                  @"web/html/mine/ph-setting.html"//== 设置 ==
#define ReceiveMsgURL               @"web/html/mine/ph-receive-msg.html"//== 回复==
#define CommentMsgURL               @"web/html/mine/ph-comment-msg.html"//== 评论 ==
#define AboutUsURL                  @"my/about"//== 关于我们 ==
#define SysMsgListUsURL             @"web/html/mine/ph-sys-msg-list.html"//== 消息 ==
//#define MineInfoURL                 @"web/html/mine/ph-mine-info.html"//== 修改资料 ==
//2.1.0修改
#define MineInfoURL                 [JGJWebDiscoverURL stringByAppendingString:@"my/info"]//== 修改资料 ==
#define AgreementURL                @"web/html/mine/ph-agreement.html"//== 用户协议 关于我们==
#define NewLifeURL                  [JGJWebDiscoverURL stringByAppendingString:[NSString stringWithFormat:@"%@",@"find"]]//== 新生活 ==

#define ContactUsURL                @"my/contact"//== 联系我们 ==
#define CooperateURL                @"web/html/mine/ph-cooperate.html"//== 合作的帮手 ==
#define CollectionMsgURL            @"web/html/mine/ph-collection-msg.html"//== 收藏 ==
#define PersonDetailSettingURL      @"web/html/make-friends/ph-person-detail.html"//== 个人主页 ==
#define MakeFriendWantToSayURL      @"web/html/make-friends/ph-want-to-say.html"//== 交朋友拍照 ==
#define MakeFriendURL               @"web/html/make-friends/ph-make-friends.html?region="//== 交朋友首页 ==
//#define CommentsURL                 @"web/html/mine/ph-comments.html"//== 意见反馈 ==
#define ModifyPasswordURL           @"web/html/mine/ph-modify-password.html"//== 修改密码 ==
#define DownLoadBillURL             @"bill?"//== 下载账单 ==
#define NewLifeNewsURL             [JGJWebDiscoverURL stringByAppendingString:[NSString \
                                    stringWithFormat:@"%@",@"news"]]//== 看咨询 ==
#define NewLifeGalleryURL          [JGJWebDiscoverURL stringByAppendingString:[NSString \
                                    stringWithFormat:@"%@",@"gallery"]]//== 美女 ==

#define GameError                   @"game/error"

#define WebProject                  [NSURL URLWithString:[NSString stringWithFormat:@"%@?ver=%@",[JLGHttpRequest_WX stringByAppendingString:@"project"],[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]]//== 找帮手 ==

#define WebProjectList              [JGJWebDiscoverURL stringByAppendingString:@"statistical"]//== 统计 ==

#define WebStatistics              [JGJWebDiscoverURL stringByAppendingString:@"statistical/charts?is_demo=0&talk_view=1"]//== 报表 ==
//我的积分
//#define WebScoreWeb                    [JGJAppWebNmURL stringByAppendingString:@"integral/inMine"]
//1758游戏平台提供的URL
#define GamePlatform1758URL         @"http://wx.1758.com/game/openpf/qipaiapp/oauth?"

//#define JGJWebIntegralInMall   @"integral/inMall" //积分商城
#define JGJWebMyProExpURL            [JGJWebDiscoverURL stringByAppendingString:@"my/exp"] //项目经验
#define JGJWebFindJobURL            [JGJWebDiscoverURL stringByAppendingString:@"work"] //找工作
#define JGJWebRecruitURL            [JGJWebDiscoverURL stringByAppendingString:@"job"] //招聘
#define JGJWebShoppingMal              @"integral/inMall" //积分商城
#define JGJWebScoreWebURL           [JGJWebDiscoverURL stringByAppendingString:@"integral/inMine"] //我的积分
#define CommentsURL                 [JGJWebDiscoverURL stringByAppendingString:@"my/feedback"]//== 意见反馈 ==
//报表的示例地址
#define StaticDemoWebURL [JLGHttpRequest_WX2 stringByAppendingString:@"statistics/chart?class_type=team&sync_from=示例数据&tag_id=0&sync_id=17&pro_name=保利玫瑰花语&is_demo=1"]

#define DefaultRecordFormURL [JLGHttpRequest_WX2 stringByAppendingString:@"project/list?class_type=team?is_demo=1"]
#define JGJWebWatchNovel      @"http://m.ireadercity.com/webapp/home/index.html" //看小说
#define JGJWebWatchVideo       @"http://m.tv.sohu.com/" //看视频
#define JGJWebLinkGame       @"http://m.jgjapp.com/newlife/gallery/" //美女连连看
#define JGJWebGameLink       @"http://wx.1758.com/game/openpf/qipaiapp/oauth" //玩游戏

#define JGJDefaultFindProURL @"project" //吉工家缺省用户找项目

#endif /* JGJAllWebURL_h */
