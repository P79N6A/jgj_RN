//
//  JGJGroupChatSelelctedMemberHeadView.h
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJGroupChatSelelctedMemberHeadView;
@protocol JGJGroupChatSelelctedMemberHeadViewDelegate <NSObject>

@optional
- (void)JGJGroupChatSelelctedMemberHeadView:(JGJGroupChatSelelctedMemberHeadView *)headerView groupListModel:(JGJMyWorkCircleProListModel *)groupListModel;
@end
@interface JGJGroupChatSelelctedMemberHeadView : UIView
@property (nonatomic, strong) JGJMyWorkCircleProListModel *groupListModel;
@property (weak, nonatomic) id <JGJGroupChatSelelctedMemberHeadViewDelegate> delegate;
//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end
