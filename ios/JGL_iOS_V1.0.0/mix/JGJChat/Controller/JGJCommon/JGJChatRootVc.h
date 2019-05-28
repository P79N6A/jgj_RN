//
//  JGJChatRootVc.h
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"
#import "JGJChatListType.h"
#import "JGJChatSignModel.h"
#import "MultipleChoiceTableView.h"

@class JGJChatRootChildVcModel;
@interface JGJChatRootChildVcModel : NSObject
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,assign) JGJChatListType vcType;
@end

@interface JGJChatRootVcRedModel : TYModel

@end

typedef void(^JGJChatRootVcBackBlock)(JGJMyWorkCircleProListModel *workProListModel);

typedef void(^JGJChatRootBackBlock)();

@interface JGJChatRootVc : UIPhotoViewController
<
    MultipleChoiceTableViewDelegate
>
//子Vc数组
@property(strong, nonatomic) NSMutableArray<JGJChatRootChildVcModel *> *childVcs;

/**
 *  需要请求服务器的model
 */
@property (nonatomic,strong) JGJChatRootRequestModel *chatRootRequestModel;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 *  需要显示红点的model
 */
@property (nonatomic,strong) JGJChatRootVcRedModel *chatRootVcRedModel;

@property (strong, nonatomic) MultipleChoiceTableView *mulChoiceView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (copy, nonatomic) JGJChatRootVcBackBlock chatRootVcBackBlock;

@property (nonatomic, strong,readonly) UILabel *titleLable;

@property (nonatomic, copy) JGJChatRootBackBlock chatRootBackBlock;

////H5进入招聘消息4.0.1
//@property (nonatomic, strong) JGJChatRecruitMsgModel *chatRecruitMsgModel;

//添加滑动的view
- (void)SegmentTapView;

//添加底部的vc
-(void)MultipleChoiceTableView;

//通用设置
- (void )commonSet;

/**
 *  增加通知类内容
 *
 *  @param dataInfo 数据
 */
- (void)addAllNotice:(NSDictionary *)dataInfo;

/**
 *  添加签到数据
 */
- (void)addSighDataWithSign_List:(ChatSign_List *)sign_List;

/**
 *  通过传入类型获取UIViewController
 */
- (UIViewController *)getChildVcWithType:(JGJChatListType )chatListType;

- (NSArray *)getChildVcs;
@end
