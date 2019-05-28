//
//  JGJKeys.h
//  mix
//
//  Created by jizhi on 16/5/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef JGJKeys_h
#define JGJKeys_h

/////////////////TYUserDefaults需要使用的key/////////////////////////

#define JGJWeixinPayNitification        @"JGJWeixinPayNitification"//是否有真实名字
#define JGJUserName         @"user_name"  //当前用户昵称大于真实姓名
#define JLGUserUid           @"uid"//登录的标识
#define JGJDevicePushToken            @"JGJDevicepushTokensss"//推送token
#define JGJOldLogType            @"JGJOldLogType"//上次的日志类型
#define JLGOverTimeShow          @"JLGOverTimeShow"//登录的标识
#define JLGcontentOpenUrl            @"JLGcontentOpenUrl"//点击文章中的链接地址

#define JLGLogin            @"JLGLogin"//登录的标识
#define JLGAdverTisement            @"JLGAdverTisement"//登录的标识
#define JLGIsRequestChatList            @"JLGIsRequestChatList"//是否请求过列表接口
#define JLGisLoginBool      [TYUserDefaults boolForKey:JLGLogin]//登录的标识
#define JLGLoginFail        @"JLGLoginFail"//登录失效
#define JLGManageVcUpdate   @"JLGManageVcUpdate"//发布完项目以后更新
#define JLGLoginBool        [TYUserDefaults boolForKey:JLGLogin]//是否登录
#define JLGIsRealName        @"JLGIsRealName"//是否有真实名字
#define JLGIsRealNameBool   [TYUserDefaults boolForKey:JLGIsRealName]

#define JLGLatitude         @"JLGLatitude"//纬度
#define JLGLongitude        @"JLGLongitude"//经度
#define JLGLocation         @"JLGLocation"//定位是否成功
#define JLGLocationTime     @"JLGLocationTime"//更新定位间隔时间
#define JLGCityNo           @"JLGCityNo"//城市编码
#define JLGProvinceName     @"JLGProvinceName"//省会名字
#define JLGCityName         @"JLGCityName"//城市名字
#define JLGCityNoUp         @"JLGCityNoUp"//城市编码更新
#define JLGSelectCityNo     @"JLGSelectCityNo"//选择的城市编码
#define JLGSelectCityName   @"JLGSelectCityName"//选择的城市名字
#define JLGCityWebName      @"JLGCityWebName"//城市详细名字,主要用于传给网页
#define JLGCityWebNo        @"JLGCityWebNo"//城市详细编码,主要用于传给网页
#define JGJLocationAddress   @"JGJLocationAddress"//定位的结果<BMKReverseGeoCodeResult>
#define JGJLocationAddressDetail   @"JGJLocationAddressDetail"//定位的结果<BMKReverseGeoCodeResult>

#define JLGProvince  @"JLGProvince"

#define JLGReadNeed         @"JLGReadNeed"//是否需要已读
#define JLGToken            @"token"//用户Token
#define JLGPhone            @"JLGPhone"//电话号码
#define JLGSetRainer            @"JLGSetRainer"//电话号码

#define JLGRealName         @"real_name"//真实姓名
#define JLGFirstPid         @"JLGFirstPid"//最新项目的Pid
#define JLGHeadPic          @"head_pic"//服务器返回的头像
#define JLGPushChannelID    @"JLGPushChannelID"//推送的ChannelID
#define JLGAddressBookTime  @"JLGAddressBookTime"//上一次联系人读取的时间
#define JGJSocketReadFailList @"JGJSocketReadFailList"//socket发送失败以后保存的列表

#define YZGGetSysServerDate     @"YZGGetSysServerDate"//上一次读取服务器的时间
#define YZGGuideDayFirst        @"YZGGuideDayFirst"//点工第一次进入,NO:没有这个值，说明是第一个进入
#define YZGGuideContractFirst   @"YZGGuideContractFirst"//包工第一次进入,NO:没有这个值，说明是第一个进入
#define YZGGuideBorrowFirst     @"YZGGuideBorrowFirst"//借支第一次进入,NO:没有这个值，说明是第一个进入
#define YZGLockScreen           @"YZGLockScreen"//锁屏

#define JGJTabBarSelectedIndex  @"JGJTabBarSelectedIndex"//tabBar选择的索引

//工人身份显示"工头/班组长",工头身份显示"工人"
#define JGJRecordIDStr      (JLGisMateBool?@"班组长":@"工人")

#pragma mark - 发送通知
#define JGJModifyBillSuccess @"JGJModifyBillSuccess"//修改账单成功
#define JGJChatListDownVoiceSuccess @"JGJChatListDownVoiceSuccess"//下载音频成功
#define JGJNotReachableStatus @"JGJNotReachableStatus"
#define JGNotJReachableStatusBOOL [TYUserDefaults boolForKey:JGJNotReachableStatus] //当前网络是否可用

//每个版本需要的特殊字段
#define JGJ_Guanli_1_0_3_ClearCache @"JGJ_Guanli_1_0_3_ClearCache"

#define JGJInfoVer  @"infover"  //记录用户是否改变信息次数，web判断用户是否改变

#define JGJKnowBaseShareCount @"JGJKnowBaseShareCount" //资料库分享次数

#define AuthorLogin @"manger_author_login"

//是否是首次登陆

#define UnFirstLogin @"UnFirstLogin"

#define UnFirstLoginBOOL [TYUserDefaults boolForKey:UnFirstLogin] 

//微信绑定通知
#define JGJWXBindpostNotification @"JGJWXBindpostNotification"

#define JGJSendMessageFresh @"JGJSendMessageFresh" //是否发了消息

#define JGJIsSendMessageFreshBool  [TYUserDefaults boolForKey:JGJSendMessageFresh] //是否发了消息

#define JGJIsChatLockScreen @"JGJIsChatLockScreen"

#define JGJIsChatLockScreenBool  [TYUserDefaults boolForKey:JGJIsChatLockScreen] //是否是聊天页面锁屏，聊天页面锁屏后返回首页

//消息是否处理结束判断，聊天使用

#define JGJIsHandlingMsg @"JGJIsHandlingMsg"

#define JGJIsHandlingMsgBool [TYUserDefaults boolForKey:JGJIsHandlingMsg]

//是否是启动拉离线消息，避免和socket重连。连续调两次

#define JGJIslLaunchOfflineMsg @"JGJIslLaunchOfflineMsg"

#define JGJIslLaunchOfflineMsgBool [TYUserDefaults boolForKey:JGJIslLaunchOfflineMsg]

//程序挂起获取离线消息

#define JGJSuspendlOfflineMsg @"JGJSuspendlOfflineMsg"

#define JGJSuspendlOfflineMsgBool [TYUserDefaults boolForKey:JGJSuspendlOfflineMsg]

//修改姓名的通知，用于修改聊天界面人员显示的名字
#define JGJAddObserverModifyNameNotify @"JGJAddObserverModifyNameNotify"

//修改姓名的通知，用于修改聊天界面人员显示用户头像
#define JGJAddObserverModifyUserHeadPicNotify @"JGJAddObserverModifyUserHeadPicNotify"

//动态消息数量通知

#define JGJDynamicMsgNumNotify @"JGJDynamicMsgNumNotify"

//是否在后台运行

#define JGJAppIsDidisEnterBackground @"JGJAppIsDidisEnterBackground"

#define JGJAppIsDidisEnterBackgroundBool [TYUserDefaults boolForKey:JGJAppIsDidisEnterBackground]

#define JGJShareSuiteName   @"group.manger.jizhi.com"

#define JGJShareSuiteNameKey   @"jizhibadge"

#define JGJNotificationAlertTime   @"JGJNotificationAlertTime"

static NSNotificationName const JGJConversationSelectionVcMessageDidSendNotification = @"JGJConversationSelectionVcMessageDidSendNotification";
static NSNotificationName const JGJConversationSelectionVcMessageSendSuccessedNotification = @"JGJConversationSelectionVcMessageSendSuccessedNotification";

#endif /* JGJKeys_h */
