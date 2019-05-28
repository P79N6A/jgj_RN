//
//  JGJMarkBillHomePageMaskingView.h
//  mix
//
//  Created by Tony on 2018/6/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaskingViewTouch)(void);
@interface JGJMarkBillHomePageMaskingView : UIView

@property (nonatomic, copy) MaskingViewTouch maskingTouch;
@property (nonatomic, assign) CGFloat runningWaterBtnY;
@end
