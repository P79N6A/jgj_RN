//
//  JGJGetPeopleInfosTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJGetPeopleInfosTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViews;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *hadSelectLable;
@property (strong, nonatomic) JGJSetRainWorkerModel*mdeol;
@property (strong, nonatomic) IBOutlet UIButton *headButton;
@property (strong, nonatomic) JGJSynBillingModel *model;

@end
