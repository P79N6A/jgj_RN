//
//  JGJBlackListCell.h
//  mix
//
//  Created by YJ on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@class JGJBlackListCell;
@protocol JGJBlackListCellDelegate <NSObject>

@optional
- (void)JGJBlackListCell:(JGJBlackListCell *)cell contactModel:(JGJSynBillingModel *)contactModel;
@end
@interface JGJBlackListCell : UITableViewCell
@property (nonatomic, strong) JGJSynBillingModel *contactModel;
@property (weak, nonatomic) id <JGJBlackListCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
