//
//  JGJGlobalDefine.h
//  mix
//
//  Created by jizhi on 16/5/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef JGJGlobalDefine_h
#define JGJGlobalDefine_h

#import "JLGHttpRequest_AFN.h"
#import "JGJSocketRequest.h"
#import "JGJYQModel.h"
#import "JGJKeys.h"
#import "Masonry.h"
#import "JGJFonts.h"
#import "JGJColors.h"
#import "MJExtension.h"
#import "CommonModel.h"
#import "TYLoadingHub.h"
#import "TYShowMessage.h"
#import "CALayer+SetLayer.h"
#import "UITableViewCell+Extend.h"
#import "JGJSocketRequest.h"
#import "JGJRequestModel.h"
#import "JGJTime.h"

#import "JGJKnowBaseModel.h"
#import "JGJKnowBaseRequestModel.h"

#import "JGJQualitySafeModel.h"
#import "JGJQualitySafeRequestModel.h"

#import "JGJProicloudListModel.h"
#import "JGJProicloudRequestModel.h"

#import "UIView+Extend.h"

#import "UIView+GNUtil.h"

#import "JGJProiCloudDataBaseTool.h"

#import "JGJQuaSafeHomeModel.h"

#import "JGJQuaSafeInspectRequset.h"

#import "JGJComTool.h"

#import "UITableView+JGJLoadCategory.h"

#define JGJNavBarFont       (TYIS_IPHONE_5_OR_LESS?16.f:17.f)//返回字体的大小

#define JGJLeftButtonHeight 44.f//返回button的高度

#define ImageUrlCenterCut @"media/simages/m"

#import "JGJEmotion.h"
#import "SDAutoLayout.h"
#import "JGJURLs.h"

#import "JGJChatGetOffLineMsgInfo.h"

#import "JGJSocketRequest+ChatMsgService.h"

//退出
#define JLGExitLogin        {[TYUserDefaults setObject:@"" forKey:JLGPhone];[TYUserDefaults setBool:NO forKey:JLGLogin];[TYUserDefaults removeObjectForKey:JLGToken];[TYUserDefaults setBool:NO forKey:JLGIsRealName];[TYUserDefaults setBool:NO forKey:YZGGuideDayFirst];[TYUserDefaults setBool:NO forKey:YZGGuideContractFirst];[TYUserDefaults setBool:NO forKey:YZGGuideBorrowFirst];[TYUserDefaults setObject:nil forKey:JLGHeadPic];[TYUserDefaults setObject:nil forKey:JLGRealName];[TYUserDefaults synchronize];[[UIApplication sharedApplication] cancelAllLocalNotifications];[UIApplication sharedApplication].applicationIconBadgeNumber = 0;[JGJSocketRequest closeSocket];}

//使用自己的键盘监控
#define TYKeyboardObserver (0)

//#define IQKEYBOARDMANAGER_DEBUG (1)

typedef enum : NSUInteger {
    workDefaultType = 0,
    workCellType,
    workLeaderCellType
} SelectedWorkType;

#endif /* JGJGlobalDefine_h */
