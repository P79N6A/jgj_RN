//
//  JGJClosedGroupCell.h
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJClosedGroupCell;
@protocol JGJClosedGroupCellDelegate <NSObject>

- (void)openAgainBtnClick:(JGJClosedGroupCell *)JGJClosedGroupCell;

@end
@interface JGJClosedGroupCell : UITableViewCell

@property (nonatomic , weak) id<JGJClosedGroupCellDelegate> delegate;


@property (nonatomic , strong) JGJClosedGroupModel *jgjClosedGroupModel;

@end
