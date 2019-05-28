//
//  JGJSingleChatDetailInfoHeadCell.h
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSingleChatDetailInfoHeadCell;
typedef enum : NSUInteger {
    JGJSingleChatDetailInfoHeadCellHeadPicButtonType,
    JGJSingleChatDetailInfoHeadCellGroupButtonType
} JGJSingleChatDetailInfoHeadCellButtonType;

@protocol JGJSingleChatDetailInfoHeadCellDelegate <NSObject>
- (void)JGJSingleChatDetailInfoHeadCell:(JGJSingleChatDetailInfoHeadCell *)cell buttonType:(JGJSingleChatDetailInfoHeadCellButtonType )buttonType;
@end
@interface JGJSingleChatDetailInfoHeadCell : UITableViewCell
@property (weak, nonatomic) id <JGJSingleChatDetailInfoHeadCellDelegate> delegate;
@property (strong, nonatomic) JGJSynBillingModel *contactModel;
@end
