//
//  JGJNineSquareView.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJNineSquareView;

@protocol JGJNineSquareViewDelegate <NSObject>

- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index;

@end

@interface JGJNineSquareView : UIView

- (void)imageCountLoadHeaderImageView:(NSArray *)images headViewWH:(CGFloat) headViewWH headViewMargin:(CGFloat) headViewMargins;

+ (CGFloat)nineSquareViewHeight:(NSArray *)images headViewWH:(CGFloat) headViewWH headViewMargin:(CGFloat) headViewMargins;

@property (nonatomic, weak) id <JGJNineSquareViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *imageViews;
@end
