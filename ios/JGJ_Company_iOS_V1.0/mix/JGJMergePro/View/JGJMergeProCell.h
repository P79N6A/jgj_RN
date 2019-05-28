//
//  JGJMergeProCell.h
//  JGJCompany
//
//  Created by yj on 16/9/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMergeProCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJMergeSplitProModel *mergeProModel;
+ (CGFloat)mergeProCellHeight;
@end
