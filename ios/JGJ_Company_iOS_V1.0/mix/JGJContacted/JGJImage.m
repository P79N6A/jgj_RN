//
//  JGJImage.m
//  mix
//
//  Created by Tony on 2017/2/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJImage.h"

#import <Photos/PHAssetResource.h>

#import <Photos/Photos.h>

#define JGJWXW  (TYIS_IPHONE_6P ? 47 :55)

#define JGJWXH (TYIS_IPHONE_6P ? 140 :130)

@implementation JGJImage
+(UIImage *)imageScale:(UIImage *)image withSize:(CGSize)size
{

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
    
}

+ (CGSize )getFitImageSize:(NSArray *)pic_w_h maxImageSize:(CGSize )maxImageSize{
    
    //分别获取自己设置的最大宽高
    CGFloat maxImageW = maxImageSize.width;
    CGFloat maxImageH = maxImageSize.height;
    
    //图片实际的宽高
    CGFloat imageH = [[pic_w_h firstObject] floatValue];
    CGFloat imageW = [[pic_w_h lastObject] floatValue];
    
    imageW = [[pic_w_h firstObject] floatValue];
    imageH = [[pic_w_h lastObject] floatValue];
    
    CGFloat imageOriWH = imageW / imageH;
    CGFloat imageOriHW = imageH / imageW;
    
    if (imageOriWH < 1) {
        
        imageH = maxImageH;
        
        //0-0.1用原图大小
        if (imageOriWH > 0.1 && imageOriWH < 1) {
            
            imageW = imageH * imageOriWH;
        }else {
            
            imageH = JGJWXH;
            
            imageW = JGJWXW;
        }
        
    }else if (imageOriWH > 1) {
        
        imageW = maxImageW;
        

        if (imageOriHW > 0.1 && imageOriHW < 1) {
            
            imageH = maxImageW * imageOriHW;
        }else {
            
            imageH = JGJWXW;
            
            imageW = JGJWXH;
        }
        
    }else {
        
        imageH = maxImageH;
        imageW = maxImageW;
        
    }
    
    
    return CGSizeMake(imageW, imageH);
}

//根据PHAsset的string获取到图片的url
+ (UIImage *)getImageFromPHAssetLocalIdentifier:(NSString *)localIdentifier
{
    if ([NSString isEmpty:localIdentifier]) {
        
        return nil;
    }
    
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject;
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    
    __block NSData *backImageData = nil;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        backImageData  = imageData;
        
    }];
    
    UIImage *image = [UIImage imageWithData:backImageData];
    
    return image;
}

@end
