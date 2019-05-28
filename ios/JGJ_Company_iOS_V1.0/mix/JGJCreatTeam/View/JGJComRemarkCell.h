//
//  JGJComRemarkCell.h
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComRemarkCell : UITableViewCell

@property (nonatomic, strong) JGJCreatTeamModel *teamModel;

//是不是代班长情况
@property (nonatomic, assign) BOOL isAgency;

+(CGFloat)cellHeight;

@end
