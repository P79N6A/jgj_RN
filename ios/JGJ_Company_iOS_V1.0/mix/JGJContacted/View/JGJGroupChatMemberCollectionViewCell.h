//
//  JGJGroupChatMemberCollectionViewCell.h
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJGroupChatMemberCollectionViewCell;
@protocol JGJGroupChatMemberCollectionViewCellDelegate <NSObject>
@optional
//群使用
- (void)handleJGJGroupChatMemberCollectionViewCell:(JGJGroupChatMemberCollectionViewCell *)cell commonModel:(JGJTeamMemberCommonModel *)commonModel;
@end
@interface JGJGroupChatMemberCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JGJSynBillingModel *memberModel;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;
@property (nonatomic, weak) id <JGJGroupChatMemberCollectionViewCellDelegate> delegate;

//搜索的值改变颜色
@property (nonatomic, copy) NSString *searchValue;
@end
