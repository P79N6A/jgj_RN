//
//  JGJFilterslogsTypeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJFilterslogsTypeTableViewCell : UITableViewCell
@property (nonatomic,strong)JGJGetLogTemplateModel *model;
@property (strong, nonatomic) IBOutlet UILabel *typeLable;
@end
