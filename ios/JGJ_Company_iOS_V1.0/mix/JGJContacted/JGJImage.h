//
//  JGJImage.h
//  mix
//
//  Created by Tony on 2017/2/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJImage : NSObject
+(UIImage *)imageScale:(UIImage *)image withSize:(CGSize)size;

//传入最大图片尺寸，和图片原始尺寸。等比例缩放一个尺寸
+ (CGSize )getFitImageSize:(NSArray *)pic_w_h maxImageSize:(CGSize )maxImageSize;

/**
 *  传入相册唯一标识，获取图片
 */
+ (UIImage *)getImageFromPHAssetLocalIdentifier:(NSString *)localIdentifier;
@end
