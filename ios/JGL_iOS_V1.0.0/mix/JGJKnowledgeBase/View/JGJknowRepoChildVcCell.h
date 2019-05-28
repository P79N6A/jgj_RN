//
//  JGJknowRepoChildVcCell.h
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
#import "SWTableViewCell.h"

@interface JGJknowRepoChildVcCell : SWTableViewCell

+ (CGFloat)knowRepoChildVcCellHeight;

@property (strong, nonatomic) JGJKnowBaseModel *knowBaseModel;

//搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
