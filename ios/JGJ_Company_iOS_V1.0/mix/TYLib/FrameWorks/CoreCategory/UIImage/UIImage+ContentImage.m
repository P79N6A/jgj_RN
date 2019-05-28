//
//  UIImage+ContentImage.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/10/21.
//  Copyright © 2015年 Tony. All rights reserved.
//  将imageName的图片使用imageWithContentsOfFile保存，避免缓存益处

#import "UIImage+ContentImage.h"

@implementation UIImage (ContentImage)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (UIImage *)imageNamedJLG:(NSString *)name {
    
    NSString *imageUrl;
    if ([name rangeOfString:@".png"].location == NSNotFound) {
        imageUrl = [NSString stringWithFormat:@"%@/%@.png", [[NSBundle mainBundle] bundlePath], name];
    }else{
        imageUrl = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], name];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageUrl];
    return image;
}
#pragma clang diagnostic pop

@end
