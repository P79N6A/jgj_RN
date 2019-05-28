//
//  JGJAddTeamMemberCell.h
//  mix
//
//  Created by YJ on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
typedef void(^SelectedSynBillingModelBlock)(JGJSynBillingModel *);
@interface JGJAddTeamMemberCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSynBillingModel *synBillingModel;
@property (nonatomic, strong)  JGJSynBillingCommonModel *synBillingCommonModel;
@property (nonatomic, copy) SelectedSynBillingModelBlock synBillingModelBlock;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;
//搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

//尾部的最大距离
@property (nonatomic, assign) CGFloat maxTrail;
@end
