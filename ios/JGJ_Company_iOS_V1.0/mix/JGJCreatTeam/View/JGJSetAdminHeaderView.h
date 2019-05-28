//
//  JGJSetAdminHeaderView.h
//  JGJCompany
//
//  Created by yj on 16/11/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJSetAdminHeaderView;
@protocol JGJSetAdminHeaderViewDelegate <NSObject>
- (void)adminHeaderViewDidSelected:(JGJSetAdminHeaderView *)headerView;
@end

@interface JGJSetAdminHeaderView : UIView
@property (weak, nonatomic) id <JGJSetAdminHeaderViewDelegate> delegate;
/**
 *  项目组信息
 */
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;
@end
