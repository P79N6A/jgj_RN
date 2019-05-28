//
//  JGJQuickCreatChatFooterView.h
//  mix
//
//  Created by yj on 2019/3/12.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJQuickCreatChatFooterActionBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJQuickCreatChatFooterView : UIView

@property (nonatomic, copy) JGJQuickCreatChatFooterActionBlock actionBlock;

@end

NS_ASSUME_NONNULL_END
