//
//  JGJPublQualityLocaCell.h
//  mix
//
//  Created by YJ on 17/6/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJPublQualityLocaCell : UITableViewCell

@property (nonatomic, strong) JGJQualityLocationModel *locationModel;

//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
