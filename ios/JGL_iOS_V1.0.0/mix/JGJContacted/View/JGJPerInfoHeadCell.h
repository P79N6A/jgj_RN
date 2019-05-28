//
//  JGJPerInfoHeadCell.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJPerInfoHeadCell;
@protocol JGJPerInfoHeadCellDelegate <NSObject>

@optional
- (void)perInfoHeadWithCell:(JGJPerInfoHeadCell *)cell perInfoModel:(JGJChatPerInfoModel *)perInfoModel;
@end
@interface JGJPerInfoHeadCell : UITableViewCell
@property (nonatomic, strong) JGJChatPerInfoModel *perInfoModel;
@property (weak, nonatomic) id <JGJPerInfoHeadCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *headPic;

+ (CGFloat)headHeightWithMessage:(NSString *)message status:(JGJFriendListMsgType)status;
@end
