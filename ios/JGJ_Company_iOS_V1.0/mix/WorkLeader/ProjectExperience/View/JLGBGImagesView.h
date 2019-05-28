//
//  JLGBGImagesView.h
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  具有缩放功能的图片浏览器

#import <UIKit/UIKit.h>

typedef void(^hiddenBGImageBlock)();

@interface JLGBGImagesView : UIView
@property (nonatomic,strong) NSMutableArray *imagesArray;
- (void)hiddenBGImageBlock:(hiddenBGImageBlock )hiddenBGImageBlock;
//- (void)hiddenBGImagesView;
//从第一个图片开始显示
- (void)showBGImagesInView:(UIView *)superView;
//从第几个图片开始显示
- (void)showBGImagesInView:(UIView *)superView index:(NSUInteger )index;
@end
