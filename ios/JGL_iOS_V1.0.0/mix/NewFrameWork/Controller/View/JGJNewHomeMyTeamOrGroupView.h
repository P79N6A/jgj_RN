//
//  JGJNewHomeMyTeamOrGroupView.h
//  mix
//
//  Created by Tony on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GotoMyTeamOrGroupBlock)(void);
@interface JGJNewHomeMyTeamOrGroupView : UIView

@property (nonatomic, copy) GotoMyTeamOrGroupBlock gotoMyTeamOrGroupBlock;

- (void)isShowRedDot;

@end
