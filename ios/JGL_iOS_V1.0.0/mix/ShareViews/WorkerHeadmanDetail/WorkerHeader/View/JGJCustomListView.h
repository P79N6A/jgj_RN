//
//  JGJCustomListLable.h
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCustomListView : UIView

@property (nonatomic, assign) CGFloat totalHeight;
- (void)setCustomListViewDataSource:(NSArray *)dataSource lineMaxWidth:(CGFloat)lineMaxWidth;
- (void)setLableLayerColor:(UIColor *)layerColor width:(CGFloat)width textBackGroundColor:(UIColor *)backGroundColor textColor:(UIColor *)textColor;
@property (nonatomic, assign) CGFloat contentFontSize;;
@end
