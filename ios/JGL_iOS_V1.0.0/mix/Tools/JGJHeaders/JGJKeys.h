//
//  JGJKeys.h
//  mix
//
//  Created by jizhi on 16/5/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef JGJKeys_h
#define JGJKeys_h

//适配用的
//状态栏高度
#define HitoStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏高度
#define HitoNavHeight 44
//顶部高度
#define HitoTopHeight (HitoStatusHeight+HitoNavHeight)
//iPhoneX安全区域高度
#define HitoSafeAreaHeight (HitoStatusHeight>20?34:0)
//底部高度
#define HitoBottomHeight (49+HitoSafeAreaHeight)

/////////////////TYUserDefaults需要使用的key/////////////////////////
#define JGJWeixinPayNitification        @"JGJWeixinPayNitification"

#define JGJUserName         @"user_name"  //当前用户是根据用户是否有真实姓名或者昵称显示
#define JLGUserUid           @"uid"
#define JLGUserstamp          @"userStamp"

#define JLGcontentOpenUrl            @"JLGcontentOpenUrl"//点击文章中的链接地址

#define JLGLogin            @"JLGLogin"//登录的标识
#define JLGLastRecordBillPeople            @"JLGLastRecordBillPeoples"//存储最近一次的记账人信息
#define JGJOldLogType            @"JGJOldLogType"//上次的日志类型
#define JGJRemovePoorView   @"JGJRemovePoorView"

#define JLGAdverTisement            @"JLGAdverTisement"//登录的标识
#define JLGisLoginBool      [TYUserDefaults boolForKey:JLGLogin]//登录的标识
#define JLGLoginFail        @"JLGLoginFail"//登录失效
#define JLGManageVcUpdate   @"JLGManageVcUpdate"//发布完项目以后更新
#define JLGLoginBool        [TYUserDefaults boolForKey:JLGLogin]//是否登录
#define JLGisMateBool       !JLGisLeaderBool//[TYUserDefaults boolForKey:JLGisMate]//是否是工友登录
#define JLGisLeader         @"JLGisLeader"//班组长/工头的标识
#define JLGisLeaderBool     [TYUserDefaults boolForKey:JLGisLeader]//!JLGisMateBool//是否是班组长登录
#define JLGMateIsInfo       @"JLGMateIsInfo"//是否有工友权限
#define JLGLeaderIsInfo     @"JLGLeaderIsInfo"//是否有班组长/工头权限
#define JLGMateIsInfoBool       [TYUserDefaults boolForKey:JLGMateIsInfo]//是否有工友权限
#define JLGLeaderIsInfoBool     [TYUserDefaults boolForKey:JLGLeaderIsInfo]//是否有班组长/工头权限
#define JLGIsRealName        @"JLGIsRealName"//是否有真实名字
#define JLGIsRealNameBool   [TYUserDefaults boolForKey:JLGIsRealName]

#define JLGProvince  @"JLGProvince"

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
#define JGJLocationAddress   @"JGJLocationAddress"//定位的结果<BMKReverseGeoCodeResult>
#define JGJLocationAddressDetail   @"JGJLocationAddressDetail"//定位的结果<BMKReverseGeoCodeResult>

#define JLGCityWebName      @"JLGCityWebName"//城市详细名字,主要用于传给网页
#define JLGCityWebNo        @"JLGCityWebNo"//城市详细编码,主要用于传给网页

#define JLGReadNeed         @"JLGReadNeed"//是否需要已读
#define JLGToken            @"token"//用户Token
#define JLGPhone            @"JLGPhone"//电话号码
#define JGJDevicePushToken            @"JGJDevicepushTokensss"//推送token
#define JGJSHA1Sign  [JGJSHA1 retrunSha_1Str]


#define JGJMoneyNumStr(moneyStrs) [JGJTime retrunMoneyNumWithNum:moneyStrs]//返回亿和万
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
//工人身份显示"班组长/工头",工头身份显示"工人"
#define JGJRecordIDStr      (JLGisMateBool?@"班组长/工头":@"工人")

#pragma mark - 发送通知
#define JGJModifyBillSuccess @"JGJModifyBillSuccess"//修改账单成功
#define JGJChatListDownVoiceSuccess @"JGJChatListDownVoiceSuccess"//下载音频成功
#define JGJNotReachableStatus @"JGJNotReachableStatus"
#define JGNotJReachableStatusBOOL [TYUserDefaults boolForKey:JGJNotReachableStatus] //当前网络是否可用

//每个版本需要的特殊字段
#define JGJ_Geren_2_0_3_ClearCache @"JGJ_Geren_2_0_3_ClearCache"

#define JGJInfoVer  @"infover"  //记录用户是否改变信息次数，web判断用户是否改变

#define JGJKnowBaseShareCount @"JGJKnowBaseShareCount" //资料库分享次数

#define JGJIsShowWork @"JGJIsShowWork"

#define JGJIsShowWorkBool [TYUserDefaults integerForKey:JGJIsShowWork]

//#define JGJCurLocalInfoName @"JGJCurLocalInfoName"
//
//#define JGJCurLocalInfoAddress @"JGJCurLocalInfoAddress"

#define AuthorLogin @"person_author_login"

//微信绑定通知
#define JGJWXBindpostNotification @"JGJWXBindpostNotification"

#define JGJUnionid @"JGJUnionid"

//是否是首次登陆

#define UnFirstLogin @"UnFirstLogin"

#define UnFirstLoginBOOL [TYUserDefaults boolForKey:UnFirstLogin]

#define SwitchRecordWorkDes @"按“工天”显示" //切换按

#define SwitchRecordHourDes @"按“小时”显示" //切换按

#define JGJSelRole @"JGJSelRole" //是否选择了角色

#define JGJIsSelRoleBool  [TYUserDefaults boolForKey:JGJSelRole] //是否选择了角色

#define JGJSendMessageFresh @"JGJSendMessageFresh" //是否发了消息

#define JGJIsSendMessageFreshBool  [TYUserDefaults boolForKey:JGJSendMessageFresh] //是否发了消息

#define JGJIsChatLockScreen @"JGJIsChatLockScreen"

#define JGJIsChatLockScreenBool  [TYUserDefaults boolForKey:JGJIsChatLockScreen] //是否是聊天页面锁屏，聊天页面锁屏后返回首页

#define JGJWorkPointMask  @"JGJWorkPointMask"

#define JGJWorkPointMaskBool [TYUserDefaults boolForKey:JGJWorkPointMask] //蒙层是否显示

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

//已添加首页引导

#define JGJIsAddHomeMaskView   @"JGJIsAddHomeMaskView"

#define JGJIsAddHomeMaskViewBool [TYUserDefaults boolForKey:JGJIsAddHomeMaskView]

//吉工家首页加载状态

#define JGJHomeLoadStatusKey     @"JGJHomeLoadStatusKey"

//1加载中，2加载失败，3加载成功

#define JGJHomeLoadStatus     [TYUserDefaults integerForKey:JGJHomeLoadStatusKey]

//记账详情修改

#define JGJModifyAccountDetailKey   @"JGJModifyAccountDetailKey"

//角标获取推送本地处理

#define JGJAppBadgeKey   @"JGJAppBadgeKey"

#define JGJAppBadgeValue     [TYUserDefaults integerForKey:JGJAppBadgeKey]

//动态消息数量通知

#define JGJDynamicMsgNumNotify @"JGJDynamicMsgNumNotify"

//是否在后台运行

#define JGJAppIsDidisEnterBackground @"JGJAppIsDidisEnterBackground"

#define JGJAppIsDidisEnterBackgroundBool [TYUserDefaults boolForKey:JGJAppIsDidisEnterBackground]

//当前有哪些组传给服务器，用于校准未读数

#define JGJAppIsDidCallBackGroups @"JGJAppIsDidCallBackGroups"

#define JGJAppIsDidCallBackGroupsBool [TYUserDefaults boolForKey:JGJAppIsDidCallBackGroups]

//推送延展和当前target共享数据，处理外部角标和内部角标一致问题。延展内部收到通知自动加1

#define JGJShareSuiteName   @"group.person.jizhi.com"

#define JGJShareSuiteNameKey   @"jizhibadge"

#define JGJHomeIsLoadNoteList @"JGJHomeIsLoadNoteList"
#define JGJUserHaveMakeANote @"JGJUserHaveMakeANote"
#define JGJHomeVCIsClicKNOtePadBtn @"JGJHomeVCIsClicKNOtePadBtn"
#define JGJHomeBottomViewClickCount @"JGJHomeBottomViewClickCount"

#define JGJHomeVCScrollTipsLabelHaveScroll @"JGJHomeVCScrollTipsLabelHaveScroll"

#define ShareSocketConnect_normale_msg_idSet @"shareSocketConnect_normale_msg_idSet"

#define ShareSocketConnect_msg_idSet @"shareSocketConnect_msg_idSet"
#define JGJHomeVCIsShowDifferentAlertView @"JGJHomeVCIsShowDifferentAlertView"
#define JGJHomeVCIsNotChangeRoleId @"JGJHomeVCIsNotChangeRoleId"
#define JGJHomeVCIsShowScrollShowMoreMasking @"JGJHomeVCIsShowScrollShowMoreMasking"
#define JGJRecoredMorePeopleSelectedType @"JGJRecoredMorePeopleSelectedType"

#define JGJSwitchRecordBillShowModel @"点击可切换记工显示方式"

#define JGJMorePeopleSelectedTypeLocalCache @"JGJMorePeopleSelectedTypeLocalCache"



#define JGJLoginFirstChangeRole @"JGJLoginFirstChangeRole"
#define JGJNotificationAlertTime @"JGJNotificationAlertTime"

#define JGJSureBillArray @"JGJSureBillArray_"
#define JGJHomeCalendarBillData @"JGJHomeCalendarBillData"

#define JGJRefreshHomeCalendarBillData @"JGJRefreshHomeCalendarBillData"

#define JGJBuilderDiaryMoreparmDic @"JGJBuilderDiaryMoreparmDic"
#define JGJBuilderDiarymoreWeatherParm @"JGJBuilderDiarymoreWeatherParm"


//是否首次登陆切换身份，首次切换身份后选择角色。页面直接消失。登陆选角色整个页面切换

#define JGJLoginFirstChangeRoleBool    [TYUserDefaults boolForKey:JGJLoginFirstChangeRole]

//#define JGTestFunction YES

static NSNotificationName const JGJConversationSelectionVcMessageDidSendNotification = @"JGJConversationSelectionVcMessageDidSendNotification";
static NSNotificationName const JGJConversationSelectionVcMessageSendSuccessedNotification = @"JGJConversationSelectionVcMessageSendSuccessedNotification";

#endif /* JGJKeys_h */
