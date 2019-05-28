//
//  JGJCustomProInfoAlertVIew.h
//  mix
//
//  Created by yj on 16/10/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJCustomProInfoAlertVIew;
@protocol JGJCustomProInfoAlertViewDelegate <NSObject>

//点击数据来源人姓名跳转到他的资料页面
- (void)customProInfoAlertViewWithalertView:(JGJCustomProInfoAlertVIew *)alertView didSelectedMember:(JGJSynBillingModel *)memberModel;

@end
@interface JGJCustomProInfoAlertVIew : UIView
@property (nonatomic, copy)void (^confirmButtonBlock) (void);
@property (nonatomic, copy)void (^cancelButtonBlock) (void);
+ (JGJCustomProInfoAlertVIew *)alertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel;
@property (weak, nonatomic) id <JGJCustomProInfoAlertViewDelegate> delegate;
@end
