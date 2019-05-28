//
//  JGJWorkTypeSelectedView.h
//  mix
//
//  Created by celion on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCityModel.h"

@class FHLeaderWorktypeCity;
@interface JGJWorkTypeSelectedView : UIView
@property (nonatomic, strong) FHLeaderWorktypeCity *workTypeModel;
- (instancetype)initWithFrame:(CGRect)frame workType:(FHLeaderWorktypeCity *)workType blockWorkType:(void(^)(FHLeaderWorktypeCity *workTypeModel)) workTypeModel;
@end
