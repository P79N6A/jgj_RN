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
 *  刷新签到列表数据
 */
-(void)freshDataList;
@end
