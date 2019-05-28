//
//  JGJUITableViewCell.h
//  mix
//
//  Created by Tony on 16/5/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface JGJUITableViewCell : SWTableViewCell
@property (nonatomic,assign) BOOL isLastedCell;//是否是最后一个cell
@property (nonatomic,strong) UIView *jgjCellBottomLineView;
@end

