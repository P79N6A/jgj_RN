//
//  JGJLoginFilterTypeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJLoginFilterTypeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) JGJFilterLogModel *filterModel;
@property (strong, nonatomic) IBOutlet UILabel *filterLogType;
@end
