//
//  JGJProSetMemberHeaderReusableView.h
//  JGJCompany
//
//  Created by yj on 2017/8/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJProSetMemberHeaderReusableView;

@protocol JGJProSetMemberHeaderReusableViewDelegate <NSObject>

- (void)proSetMemberHeaderReusableView:(JGJProSetMemberHeaderReusableView *)headerView;

@end

@interface JGJProSetMemberHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

@property (nonatomic, weak) id <JGJProSetMemberHeaderReusableViewDelegate> delegate;

@end
