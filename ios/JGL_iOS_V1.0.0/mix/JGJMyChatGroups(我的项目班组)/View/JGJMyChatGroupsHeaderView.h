//
//  JGJMyChatGroupsHeaderView.h
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMyChatGroupsHeaderViewSwitchBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyChatGroupsHeaderView : UICollectionReusableView

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, copy) JGJMyChatGroupsHeaderViewSwitchBlock switchBlock;

+(CGFloat)headerHeight;

@end

NS_ASSUME_NONNULL_END
