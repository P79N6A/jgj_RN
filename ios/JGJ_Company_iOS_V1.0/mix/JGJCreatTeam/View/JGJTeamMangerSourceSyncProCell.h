//
//  JGJTeamMangerSourceSyncProCell.h
//  JGJCompany
//
//  Created by YJ on 16/11/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJTeamMangerSourceSyncProCell;
@protocol JGJTeamMangerSourceSyncProCellDelegate <NSObject>
@optional
- (void)handleTeamMangerSourceSyncProCellRemoveSynproButtonPressed:(JGJTeamMangerSourceSyncProCell *)cell;

@end
@interface JGJTeamMangerSourceSyncProCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSyncProlistModel *prolistModel;
@property (weak, nonatomic) id <JGJTeamMangerSourceSyncProCellDelegate> delegate;
@end
