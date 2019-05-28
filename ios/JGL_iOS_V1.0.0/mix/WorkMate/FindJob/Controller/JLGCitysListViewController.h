//
//  JLGCitysListViewController.h
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLGCitysListViewController;
@protocol JLGCitysListViewControllerDelegate <NSObject>
- (void)selectedCityVc:(JLGCitysListViewController *)jlgCitysListViewController cityCode:(NSString *)cityCode cityName:(NSString *)cityName;
@end
@interface JLGCitysListViewController : UIViewController
@property (nonatomic,assign) NSInteger roleType;
@property (nonatomic , weak) id<JLGCitysListViewControllerDelegate> delegate;
@end
