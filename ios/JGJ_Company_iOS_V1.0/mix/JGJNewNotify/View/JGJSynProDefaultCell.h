//
//  JGJSynProDefaultCell.h
//  mix
//
//  Created by yj on 16/10/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSynProDefaultCell;
@protocol JGJSynProDefaultCellDelegate <NSObject>
- (void)handleSynProDefaultCellAction:(JGJSynProDefaultCell *)cell;
@end

@interface JGJSynProDefaultCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) id <JGJSynProDefaultCellDelegate> delegate;
@end
