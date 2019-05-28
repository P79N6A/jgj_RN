//
//  JGJCheckContentTitleTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckContentTitleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *titleNameLable;
@property (strong, nonatomic) JGJCheckContentDetailModel *model;
@end
