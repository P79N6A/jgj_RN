//
//  JGJTeamDetailCommonPopView.h
//  JGJCompany
//
//  Created by yj on 16/11/11.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NoSynSourceType, //未同步
    OnlySyncSourceType, //仅有关联的同步源类型
    OnlySyncUnSourceType, //仅有未关联的同步元类型
    AllSyncSourceType //两者均有
} SyncSourceType;
@class JGJTeamDetailCommonPopView;
@protocol JGJTeamDetailCommonPopViewDelagate <NSObject>
@optional
- (void)teamDetailCommonPopView:(JGJTeamDetailCommonPopView *)popView;
- (void)teamDetailCommonPopViewCancelButtonPressed:(JGJTeamDetailCommonPopView *)popView;
//点击数据来源人姓名跳转到他的资料页面
- (void)teamDetailCommonPopViewWithpopView:(JGJTeamDetailCommonPopView *)popView didSelectedMember:(JGJSynBillingModel *)memberModel;
@end
@interface JGJTeamDetailCommonPopView : UIView
+ (JGJTeamDetailCommonPopView *)popViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel;
@property (weak, nonatomic) id <JGJTeamDetailCommonPopViewDelagate> delegate;
@property (strong, nonatomic, readonly) JGJTeamMemberCommonModel *commonModel;
@property (strong, nonatomic, readonly) JGJSourceSynProFirstModel *synProFirstModel;
@end
