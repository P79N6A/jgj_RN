//
//  JGJLoadStatusViewCell.h
//  mix
//
//  Created by yj on 2018/11/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJLoadStatusViewCell;

@protocol JGJLoadStatusViewCellDelegate <NSObject>

@optional

- (void)loadStatusViewCell:(JGJLoadStatusViewCell *)cell;

@end

@interface JGJLoadStatusViewCell : UITableViewCell

//1加载中，2加载失败，3加载成功
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, weak) id <JGJLoadStatusViewCellDelegate> delegate;

@end
