//
//  JGJHomeGoToOpenNotificationJurisdictionView.h
//  mix
//
//  Created by Tony on 2019/3/25.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OpenNotificationBlock)(void);
@interface JGJHomeGoToOpenNotificationJurisdictionView : UIView

@property (nonatomic, copy)void (^touchDismissBlock) (void);
@property (nonatomic, copy) OpenNotificationBlock openNotificationBlock;
@end
