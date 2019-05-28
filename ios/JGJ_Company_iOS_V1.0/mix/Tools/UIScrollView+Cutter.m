//
//  UIScrollView+Cutter.m
//  JGJCompany
//
//  Created by yj on 2018/5/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "UIScrollView+Cutter.h"

@implementation UIScrollView (Cutter)

/**
 *  根据视图尺寸获取视图截屏
 *
 *  @return UIImage 截取的图片
 */

- (UIImage*)viewCutter
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[[UIScreen mainScreen] scale]);
    
    // 方法一 有时导航条无法正常获取
    // [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 方法二 iOS7.0 后推荐使用
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


/**
 *  根据视图尺寸获取视图截屏（一屏无法显示完整）,适用于UIScrollView UITableviewView UICollectionView UIWebView
 *
 *  @return UIImage 截取的图片
 */

- (UIImage *)scrollViewCutter
{
    //保存
    
    CGPoint savedContentOffset = self.contentOffset;
    
    CGRect savedFrame = self.frame;
    
    self.contentOffset = CGPointZero;
    
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    UIImage *image = [self viewCutter];
    
    //还原数据
    
    self.contentOffset = savedContentOffset;
    
    self.frame = savedFrame;
    
    return image;
    
}

@end
