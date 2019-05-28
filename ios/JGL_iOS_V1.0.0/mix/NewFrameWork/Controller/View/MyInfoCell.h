//
//  MyInfoCell.h
//  mix
//
//  Created by celion on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

//typedef enum : NSUInteger {
//    workCellType,
//    workLeaderCellType
//} WorkType;
#import <UIKit/UIKit.h>
@interface MyInfoCell : UITableViewCell

- (void)cellWithType:(SelectedWorkType)type indexPath:(NSIndexPath *)indexPath ;
@property (nonatomic, strong) MyWorkZone *myWorkZone;
@property (nonatomic, strong) MyWorkLeaderZone *myWorkLeaderZone;
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@end
