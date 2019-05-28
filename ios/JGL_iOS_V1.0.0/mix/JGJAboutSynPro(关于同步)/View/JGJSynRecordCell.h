//
//  JGJSynRecordCell.h
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSynRecordCell;

@protocol JGJSynRecordCellDelegate <NSObject>

@optional

- (void)synRecordCellCancelButtonPressedWithCell:(JGJSynRecordCell *)cell;

@end

@interface JGJSynRecordCell : UITableViewCell

@property (nonatomic, weak) id <JGJSynRecordCellDelegate> delegate;

@property (nonatomic, strong) JGJSynedProListModel *proListModel;

@property (nonatomic, strong) JGJSynedProModel *synedProModel;

@end
