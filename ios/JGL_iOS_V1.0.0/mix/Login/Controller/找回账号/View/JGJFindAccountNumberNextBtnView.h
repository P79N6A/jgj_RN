//
//  JGJFindAccountNumberNextBtnView.h
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NextStep)(void);
@interface JGJFindAccountNumberNextBtnView : UIView

@property (nonatomic, copy) NextStep nextStep;
@property (nonatomic, assign) BOOL isHavChoiceRecordWorkpoints;
@end
