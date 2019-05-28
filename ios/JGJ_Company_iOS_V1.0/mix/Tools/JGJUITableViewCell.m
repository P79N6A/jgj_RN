//
//  JGJUITableViewCell.m
//  mix
//
//  Created by Tony on 16/5/10.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUITableViewCell.h"

@implementation JGJUITableViewCell
- (void)setIsLastedCell:(BOOL)isLastedCell{
    _isLastedCell = isLastedCell;
    self.jgjCellBottomLineView.hidden = isLastedCell;
}
@end
