//
//  JGJTaskJoinMemberCell.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJTaskJoinMemberCell;

@protocol JGJTaskJoinMemberCellDelegate <NSObject>

@optional

- (void)taskJoinMemberCell:(JGJTaskJoinMemberCell *)cell didSelectedMember:(JGJSynBillingModel *)memberModel;

@end

@interface JGJTaskJoinMemberCell : UITableViewCell

@property (nonatomic, weak) id <JGJTaskJoinMemberCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *taskTracerModels; //任务追踪者模型

@end
