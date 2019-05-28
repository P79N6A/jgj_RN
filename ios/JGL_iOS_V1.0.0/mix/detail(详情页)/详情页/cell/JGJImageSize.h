//
//  JGJImageSize.h
//  mix
//
//  Created by Tony on 2017/3/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJImageSize : NSObject
+(CGSize)getImageSizeWithURL:(id)imageURL;
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
