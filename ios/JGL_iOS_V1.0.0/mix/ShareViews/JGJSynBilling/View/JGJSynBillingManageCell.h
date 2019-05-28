//
//  JGJSynBillingManageCell.h
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
typedef void(^SelectedSynBillingModelBlock)(JGJSynBillingModel *);
@interface JGJSynBillingManageCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSynBillingModel *synBillingModel;
@property (nonatomic, strong)  JGJSynBillingCommonModel *synBillingCommonModel;
@property (nonatomic, copy) SelectedSynBillingModelBlock synBillingModelBlock;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;

@end
