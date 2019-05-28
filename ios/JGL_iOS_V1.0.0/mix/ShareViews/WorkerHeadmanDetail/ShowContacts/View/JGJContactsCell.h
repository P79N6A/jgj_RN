//
//  JGJContactsCell.h
//  mix
//
//  Created by celion on 16/4/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFHLeaderDetailModel.h"
@interface JGJContactsCell : UITableViewCell
@property (nonatomic, strong) FindResultModel *findResultModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;
@end
