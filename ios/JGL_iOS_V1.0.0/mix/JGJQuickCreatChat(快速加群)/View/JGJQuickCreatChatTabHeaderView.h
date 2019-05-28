//
//  JGJQuickCreatChatTabHeaderView.h
//  mix
//
//  Created by yj on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJQuickCreatChatTabHeaderViewBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJQuickCreatChatTabHeaderView : UIView

@property (copy, nonatomic) JGJQuickCreatChatTabHeaderViewBlock tabHeaderViewBlock;

+(CGFloat)headerHeight;

@end

NS_ASSUME_NONNULL_END
