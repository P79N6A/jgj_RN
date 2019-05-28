//
//  MyInfoCell.h
//  mix
//
//  Created by celion on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyInfoCell : UITableViewCell
- (void)cellMyWorkZone:(MyWorkZone *)myZone indexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@end
