//
//  JGJDataSourceMemberPopVIew.h
//  JGJCompany
//
//  Created by YJ on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJDataSourceMemberPopView;
@protocol JGJDataSourceMemberPopViewDelegate <NSObject>
@optional
- (void)JGJDataSourceMemberPopViewRemoveMember:(JGJSynBillingModel *)teamMemberModel;
- (void)JGJDataSourceMemberPopViewConfirmTeamMemberModel:(JGJDataSourceMemberPopView *)popView;
@end
@interface JGJDataSourceMemberPopView : UIView
- (instancetype)initWithFrame:(CGRect)frame teamMemberModel:(JGJSynBillingModel *)teamMemberModel;
@property (weak, nonatomic) id <JGJDataSourceMemberPopViewDelegate> delegate;
@property (strong, nonatomic, readonly) JGJCreatDiscussTeamRequest *teamRequest;
@property (strong, nonatomic, readonly) JGJSynBillingModel *teamMemberModel;
@end
