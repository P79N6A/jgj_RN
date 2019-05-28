//
//  JLGBaseBMapView.h
//  mix
//
//  Created by jizhi on 15/12/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLGBaseBMapView : UIView
@property (nonatomic,assign) CGFloat zoomLevel;
@property (copy,nonatomic) NSArray *prolocation;
@property (copy,nonatomic) NSString *titleString;
@property (copy,nonatomic) NSString *subtitleString;
@end
