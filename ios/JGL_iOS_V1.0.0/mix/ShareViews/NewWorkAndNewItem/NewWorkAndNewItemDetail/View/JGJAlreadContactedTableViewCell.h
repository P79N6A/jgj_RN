//
//  JGJAlreadContactedTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFindJobAndProTableViewCell.h"

typedef NS_ENUM(NSUInteger, JGJAlreadContactedSubViewType) {
    JGJAlreadContactedSubViewTypeShowSkill = 1,
    JGJAlreadContactedSubViewTypeShowAppraise
};
@class JGJAlreadContactedTableViewCell;
@protocol JGJAlreadContactedTableViewCellDelegate <NSObject>
@optional
- (void )AlreadContactedShowSubView:(JGJAlreadContactedTableViewCell *)alreadContactedCell subViewType:(JGJAlreadContactedSubViewType )subViewType;
@end
@interface JGJAlreadContactedTableViewCell : JGJFindJobAndProTableViewCell
@property (nonatomic , weak) id<JGJAlreadContactedTableViewCellDelegate> delegate;

@end
