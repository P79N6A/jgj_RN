//
//  JGJHomeAlertOneMinuteTestView.h
//  mix
//
//  Created by Tony on 2018/6/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookExplainEvent)(void);
@interface JGJHomeAlertOneMinuteTestView : UIView

@property (nonatomic, copy)void (^touchDismissBlock) (void);
@property (nonatomic, copy) LookExplainEvent explaintEvent;
@end
