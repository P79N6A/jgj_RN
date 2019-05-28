//
//  JGJMyConnecView.h
//  mix
//
//  Created by yj on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMyConnecViewActionBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyConnecView : UIView

@property (nonatomic, copy) JGJMyConnecViewActionBlock actionBlock;

@end

NS_ASSUME_NONNULL_END
