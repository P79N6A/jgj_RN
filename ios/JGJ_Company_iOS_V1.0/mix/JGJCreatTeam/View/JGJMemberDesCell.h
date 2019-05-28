//
//  JGJMemberDesCell.h
//  mix
//
//  Created by yj on 2018/12/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMemberDesCell : UITableViewCell

@property (weak, nonatomic,readonly) IBOutlet UILabel *titleLable;

@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;//设置头部标题，是否显示删除按钮

@end
