//
//  JGJSplitProCell.h
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JGJSplitProCellHeight 80
@interface JGJSplitProCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJMergeSplitProModel *splitProModel;
@end
