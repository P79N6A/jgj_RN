//
//  JGJMemberAppraiseStarsCell.h
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberMangerModel.h"

//用于显示布局
typedef enum : NSUInteger {
    
    JGJMemberAppraiseStarsCellDefaultType, //默认查看类型
    
    JGJMemberAppraiseStarsCellEvaType //评价类型

} JGJMemberAppraiseStarsCellType;

@interface JGJMemberAppraiseStarsCell : UITableViewCell

@property (nonatomic, strong) JGJMemberAppraiseStarsModel *starsModel;

//星星头部距离
@property (nonatomic, assign) CGFloat maxStarLead;

@property (nonatomic, assign) JGJMemberAppraiseStarsCellType starsCellType;

@end
