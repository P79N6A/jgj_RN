//
//  JGJQuaSafeUnDealedResultView.h
//  JGJCompany
//
//  Created by yj on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQuaSafeUnDealedResultView;

@protocol JGJQuaSafeUnDealedResultViewDelegate <NSObject>

@optional

- (void)quaSafeUnDealedResultView:(JGJQuaSafeUnDealedResultView *)unDealedResultView selectedButtonType:(QuaSafeUnDealedResultViewButtonType)buttonType;

@end

@interface JGJQuaSafeUnDealedResultView : UIView

@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel *listModel;

@property (nonatomic, weak) id <JGJQuaSafeUnDealedResultViewDelegate> delegate;

@end
