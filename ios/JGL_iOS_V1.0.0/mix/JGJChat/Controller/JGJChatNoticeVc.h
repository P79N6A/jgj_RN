//
//  JGJChatNoticeVc.h
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAddProExperienceViewController.h"
#import "JGJChatListType.h"
#import "CustomAlertView.h"

typedef NS_ENUM(NSUInteger, JGJChatSignVcType) {
    
    JGJChatSignVcUseType = 1, //默认使用签到
    
    JGJChatSignVcCheckType  //查看类型
};

@interface JGJChatNoticeVc : JLGAddProExperienceViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UITextViewDelegate
>

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,assign) JGJChatListType chatListType;

@property (nonatomic,copy) NSString *pro_name;

@property (weak, nonatomic,readonly) IBOutlet UIButton *releaseButton;

- (void)commonInit;

/**
 *  签到类型
 */
@property (nonatomic, assign) JGJChatSignVcType signVcType;

/**
 *  刷新签到列表数据
 */
-(void)freshDataList;
@end
