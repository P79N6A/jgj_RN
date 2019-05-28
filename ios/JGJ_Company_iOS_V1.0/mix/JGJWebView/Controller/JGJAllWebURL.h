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
#define AboutUsURL                  @"my/about"//== 关于我们 ==
#define MineInfoURL                 [JGJWebDiscoverURL stringByAppendingString:@"my/info"]//== 修改资料 ==
#define AgreementURL                @"my/about"//== 用户协议 关于我们==

#define ContactUsURL                @"my/contact"//== 联系我们 ==

#define CommentsURL                 @"my/feedback"//== 意见反馈 ==

#define DownLoadBillURL             @"bill/list?"//== 下载账单 ==

#define NewLifeNewsURL             [JLGHttpRequest_Source stringByAppendingString:[NSString \
                                    stringWithFormat:@"%@",@"newlife/news"]]//== 看咨询 ==

#define NewLifeGalleryURL          [JLGHttpRequest_Source stringByAppendingString:[NSString \
                                    stringWithFormat:@"%@",@"newlife/gallery"]]//== 美女 ==

#define GameError                   @"game/error"

#define WebProject                  [NSURL URLWithString:[NSString stringWithFormat:@"%@?ver=%@",[JLGHttpRequest_WX stringByAppendingString:@"project"],[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]]//== 找帮手 ==

#define WebProjectList              [JGJWebDiscoverURL stringByAppendingString:@"statistical"]//== 统计 ==

#define WebStatistics              [JGJWebDiscoverURL stringByAppendingString:@"statistical/charts?is_demo=0&talk_view=1"]//== 报表 ==is_demo=1, talk_view=1

//1758游戏平台提供的URL
#define GamePlatform1758URL         @"http://wx.1758.com/game/openpf/qipaiapp/oauth?"
#define ScoreWeb                    @"http://nm.ex.yzgong.com/integral/inMine"

//报表的示例地址
#define StatisticsDemoWebURL [JGJWebDiscoverURL stringByAppendingString:@"statistical/charts?is_demo=1&pro_name=保利玫瑰花语&sync_id=17&tag_id=0&talk_view=0"]

#define DefaultRecordFormURL [JGJWebDiscoverURL stringByAppendingString:@"project/list?class_type=team?is_demo=1"]

#define JGJWebWatchNovel      @"http://m.ireadercity.com/webapp/home/index.html" //看小说

//2.1.2 -yj
#define NewLifeURL                  [JGJWebDiscoverURL stringByAppendingString:[NSString stringWithFormat:@"%@",@"find"]]//== 新生活 ==

//我的
#define JGJWebMyInfoURL     [JGJWebDiscoverURL stringByAppendingString:@"my"]

#endif /* JGJAllWebURL_h */
