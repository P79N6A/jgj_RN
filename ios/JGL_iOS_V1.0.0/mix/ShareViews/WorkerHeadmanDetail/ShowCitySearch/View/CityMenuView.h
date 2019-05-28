//
//  CityMenuView.h
//  mix
//
//  Created by yj on 16/4/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLGCityModel;
@interface CityMenuView : UIView
- (instancetype)initWithFrame:(CGRect)frame cityName:(void(^)(JLGCityModel *cityModel)) cityModel;
@property (nonatomic, assign) BOOL isCancelAllProvince;//是否取消全省
@end
