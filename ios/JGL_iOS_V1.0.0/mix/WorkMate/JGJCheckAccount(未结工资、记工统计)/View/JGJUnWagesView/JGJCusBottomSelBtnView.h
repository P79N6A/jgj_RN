//
//  JGJCusBottomSelBtnView.h
//  mix
//
//  Created by yj on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCusBottomSelBtnViewLeftBlock)(UIButton *sender);

typedef void(^JGJCusBottomSelBtnViewRightBlock)(UIButton *sender);

NS_ASSUME_NONNULL_BEGIN

@interface JGJCusBottomSelBtnView : UIView

@property (nonatomic, copy) NSString *leftTitle;

@property (nonatomic, copy) NSString *rightTitle;

@property (weak, nonatomic,readonly) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic,readonly) IBOutlet UIButton *rightBtn;

@property (nonatomic, copy) JGJCusBottomSelBtnViewLeftBlock leftBlock;

@property (nonatomic, copy) JGJCusBottomSelBtnViewRightBlock rightBlock;

+(CGFloat)bottomSelBtnViewHeight;

@end

NS_ASSUME_NONNULL_END
