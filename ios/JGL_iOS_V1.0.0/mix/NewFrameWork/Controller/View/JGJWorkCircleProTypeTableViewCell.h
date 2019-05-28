//
//  JGJWorkCircleProTypeTableViewCell.h
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJWorkCircleProListCollectionViewCell.h"

typedef enum : NSUInteger {
    ProTypeHeaderSwitchProButtonType,
    ProTypeHeaderChatButtonType,
    ProTypeHeaderWorkReplyButtonType,
} ProTypeHeaderButtonType;

@class JGJWorkCircleProTypeTableViewCell;
@protocol JGJWorkCircleProTypeTableViewCellDelegate <NSObject>

- (void)JGJWorkCircleProTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel;

- (void)proTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell buttonType:(ProTypeHeaderButtonType)buttonType;

@end

@interface JGJWorkCircleProTypeTableViewCell : UITableViewCell

@property (nonatomic, weak) id <JGJWorkCircleProTypeTableViewCellDelegate> delegate;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@end
