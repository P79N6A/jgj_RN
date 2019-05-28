//
//  JGJMyChatGroupsBottomView.h
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMyChatGroupsBottomChatActionBlock)();

typedef void(^JGJMyChatGroupsBottomWorkReplyActionBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyChatGroupsBottomView : UIView

@property (nonatomic, copy) JGJMyChatGroupsBottomChatActionBlock chatActionBlock;

@property (nonatomic, copy) JGJMyChatGroupsBottomWorkReplyActionBlock workReplyActionBlock;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

+(CGFloat)bottomViewHeight;

@end

NS_ASSUME_NONNULL_END
