//
//  JGJProTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJProTableViewCell : UITableViewCell
@property (strong ,nonatomic)JGJMyWorkCircleProListModel *model;
@property (strong, nonatomic) IBOutlet UILabel *prtoLable;
@end
