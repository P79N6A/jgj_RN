//
//  JGJHomeAlertRightAwayRecommendView.h
//  mix
//
//  Created by Tony on 2018/6/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RightAwayToRecommendBlock)(void);
@interface JGJHomeAlertRightAwayRecommendView : UIView

@property (nonatomic, copy)void (^touchDismissBlock) (void);
@property (nonatomic, copy) RightAwayToRecommendBlock rightAwayToRecommendBlock;
@end
