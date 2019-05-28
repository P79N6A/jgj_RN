//
//  UIImage+Size.h
//  TYSamples
//
//  Created by Tony on 16/6/29.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)
/**
 *  获取的照片要求在100k以内
 *
 *  @param image 传入的照片
 *
 *  @return 返回的数据
 */
+(NSData *)imageData:(UIImage *)image;

/**
 *  获取指定大小的图片
 *
 *  @param image 原始图片
 *  @param size  指定的尺寸
 *
 *  @return 生成的图片
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;


/**
 *  压缩图片到指定文件大小
 *
 *  @param image 原始图片
 *  @param size  指定的大小
 *
 *  @return 生成的图片
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
@end
