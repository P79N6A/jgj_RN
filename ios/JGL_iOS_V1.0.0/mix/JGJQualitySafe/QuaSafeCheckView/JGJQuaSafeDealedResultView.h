//
//  JGJQuaSafeDealedResultView.h
//  JGJCompany
//
//  Created by yj on 2017/7/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QuaSafeDealedResultViewcheckDetailButtonType, //查看详情
    
    QuaSafeDealedResultViewModifyResultButtonType, //整改结果
    
    QuaSafeDealedResultViewCheckRecordButtonType, //检查记录
    
} QuaSafeDealResultViewButtonType;

@class JGJQuaSafeDealedResultView;

@protocol JGJQuaSafeDealedResultViewDelegate <NSObject>

@optional

- (void)quaSafeDealResultView:(JGJQuaSafeDealedResultView *)dealResultView selectedButtonType:(QuaSafeDealResultViewButtonType)buttonType;

@end

@interface JGJQuaSafeDealedResultView : UIView

@property (nonatomic, strong) JGJInspectPlanProInfoDotListModel *listModel;

@property (nonatomic, weak) id <JGJQuaSafeDealedResultViewDelegate> delegate;

@end
