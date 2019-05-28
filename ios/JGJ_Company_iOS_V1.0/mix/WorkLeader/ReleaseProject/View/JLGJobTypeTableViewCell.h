//
//  JLGJobTypeTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLGJobTypeTableViewCell : UITableViewCell

@property (assign,nonatomic) CGFloat pointViewLConstFloat;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//多选的时候改变的状态
- (void)setChangeStatus:(BOOL)Status;

//单选的时候改变的状态
- (void)setChangeSingleStatus:(BOOL)Status;
@end
