//
//  JGJMarkBillRecommendAndReconciliationBottomView.h
//  mix
//
//  Created by Tony on 2018/6/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJMarkBillRecommendAndReconciliationBottomViewDelegate <NSObject>

@optional
// 点击推荐给他人或者我要对账
- (void)didSelectedRecommendToOthersOrReconciliationWithIndex:(NSInteger)index;

@end
@interface JGJMarkBillRecommendAndReconciliationBottomView : UIView

@property (nonatomic, weak) id<JGJMarkBillRecommendAndReconciliationBottomViewDelegate> recommendAndReconciliationDelegate;
@property (nonatomic, strong) NSString *recordDetaileTitle;

@property (nonatomic, strong) NSString *wait_confirm_num;
@end
