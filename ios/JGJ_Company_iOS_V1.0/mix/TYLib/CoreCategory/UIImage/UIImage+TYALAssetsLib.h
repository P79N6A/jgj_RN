//
//  UIImage+TYALAssetsLib.h
//  TYSamples
//
//  Created by Tony on 2016/7/15.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TYALAssetsLib)

/**
 *  保存图片到相册albumName
 *
 *  @param albumName       相册名
 *  @param completionBlock 成功的回调
 *  @param failureBlock    失败的回调
 */
- (void)saveToAlbum:(NSString *)albumName
    completionBlock:(void (^)(void))completionBlock
       failureBlock:(void (^)(NSError *error))failureBlock;
@end
