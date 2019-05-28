//
//  JGJTeamWorkListViewController.h
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelelctedMembersVcBlock)(id);

@interface JGJTeamWorkListViewController : UIViewController
typedef void(^BoolHaveGroup)(BOOL haveGrp);

@property (nonatomic,strong) BoolHaveGroup HaveGrounp;

//是否是记录单个人员
@property (nonatomic, assign) BOOL isRecordSingleMember;
/*
 *记多人push过来
 */
@property (nonatomic, assign) BOOL isRecordMorePeople;

//记账选择人员回调
@property (nonatomic, copy) SelelctedMembersVcBlock selelctedMembersVcBlock;
@end
