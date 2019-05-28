//
//  JGJCusBottomButtonView.h
//  JGJCompany
//
//  Created by yj on 2017/7/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCusBottomButtonViewModel : NSObject

@property (nonatomic, strong) NSString *buttonTitle;

@end

@class JGJCusBottomButtonView;
typedef void(^HandleCusBottomButtonViewBlock)(JGJCusBottomButtonView *);

@interface JGJCusBottomButtonView : UIView

@property (nonatomic, strong) JGJCusBottomButtonViewModel *buttonViewModel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (nonatomic, copy) HandleCusBottomButtonViewBlock handleCusBottomButtonViewBlock;

+ (CGFloat)cusBottomButtonViewHeight;
@end
