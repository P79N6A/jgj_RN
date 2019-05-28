//
//  JGJPepleInfoTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@interface JGJPepleInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *projectLable;
@property (nonatomic,strong) YZGGetBillModel *JlgGetBillModel;

@end
