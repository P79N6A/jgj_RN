//
//  JGJCheckModifyResultView.h
//  JGJCompany
//
//  Created by yj on 2017/11/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCheckModifyResultViewBlock)(JGJCheckModifyResultViewButtontype);

typedef void(^JGJCheckModifyResultViewConfirmButtonBlock)();


@interface JGJCheckModifyResultViewModel : NSObject

//按钮状态
@property (nonatomic, assign) JGJCheckModifyResultViewButtontype buttonType;


@end

@interface JGJCheckModifyResultView : UIView

@property (nonatomic, copy) JGJCheckModifyResultViewBlock modifyresultViewBlock;

@property (nonatomic, copy) JGJCheckModifyResultViewConfirmButtonBlock confirmButtonBlock;

+ (JGJCheckModifyResultView *)showWithMessage:(JGJCheckModifyResultViewModel *)resultViewModel;
@end
