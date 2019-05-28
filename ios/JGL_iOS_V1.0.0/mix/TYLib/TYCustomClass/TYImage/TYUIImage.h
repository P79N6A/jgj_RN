//
//  TYUIImage.h
//  mix
//
//  Created by jizhi on 15/12/18.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYUIImage : UIImage

/**
 *  获取的照片要求在100k以内
 *
 *  @param image 传入的照片
 *
 *  @return 返回的数据
 */
+(NSData *)imageData:(UIImage *)image;
@end
