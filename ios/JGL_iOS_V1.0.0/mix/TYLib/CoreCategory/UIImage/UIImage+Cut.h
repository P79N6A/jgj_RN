//
//  UIImage+Cut.h
//  mohu
//
//  Created by 沐汐 on 14-10-6.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//  手机屏幕截图，图片指定区域截图：
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Cut)


/*
 *  圆形图片
 */
@property (nonatomic,strong,readonly) UIImage *roundImage;

/**
 *  从给定UIView中截图：UIView转UIImage
 */
+(UIImage *)cutFromView:(UIView *)view;

/**
 *  直接截屏
 */
+(UIImage *)cutScreen;



/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)cutWithFrame:(CGRect)frame;

/**
 *  指定区域截图：
 */
+ (UIImage *)viewSnapshot:(UIView *)view withInRect:(CGRect)rect;

/**
 *  指定区域截图：
 */
+ (UIImage *)saveScreenImage:(UIView *)view size:(CGSize)size;

// 搞清截图
+ (UIImage *)viewHightSnapshot:(UIView *)view withInRect:(CGRect)rect;


// 截图保存到手机相册
+ (UIImage *)saveScreenShotWithView:(UIView *)view offsetY:(CGFloat)offsetY isSavePhoto:(BOOL)isSavePhoto;

//截取当前屏幕
+ (UIImage *)imageDataScreenShot;
@end
