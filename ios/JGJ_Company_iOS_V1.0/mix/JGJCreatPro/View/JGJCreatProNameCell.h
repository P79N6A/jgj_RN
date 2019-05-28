//
//  JGJCreatProBottomDecCell.h
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmCreatProBlock)(JGJCreatDiscussTeamRequest *);
@interface JGJCreatProNameCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)creatProNameCellHeight;
@property (nonatomic, copy) ConfirmCreatProBlock confirmCreatProBlock;
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel; //工作消息传过来的项目名称
@end
