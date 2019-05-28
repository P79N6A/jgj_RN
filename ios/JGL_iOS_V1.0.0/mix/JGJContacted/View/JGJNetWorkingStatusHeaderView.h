//
//  JGJNewWorkingStatusHeaderView.h
//  mix
//
//  Created by Tony on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
@interface JGJNetWorkingStatusHeaderView : UIView

- (void)setcontentWithNewWorkingStatus:(AFNetworkReachabilityStatus)status;

@end
