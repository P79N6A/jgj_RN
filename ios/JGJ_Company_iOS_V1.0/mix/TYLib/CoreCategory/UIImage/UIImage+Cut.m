//
//  UIImage+Cut.m
//  mohu
//
//  Created by 沐汐 on 14-10-6.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import "UIImage+Cut.h"

#import "UIImage+TYALAssetsLib.h"

@implementation UIImage (Cut)



/**
 *  图片剪切为圆形
 *
 *  @param originalImage 原始图片
 *
 *  @return 剪切后的圆形图片
 */
-(UIImage *)roundImage{
    
    //获取size
    CGSize size = [self sizeFromImage:self];
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建一个图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制圆形路径
    CGContextAddEllipseInRect(ctx, rect);
    
    //剪裁上下文
    CGContextClip(ctx);
    
    //绘制图片
    [self drawInRect:rect];
    
    //取出图片
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();

    return roundImage;
}



-(CGSize)sizeFromImage:(UIImage *)image{
    
    CGSize size = image.size;
    
    CGFloat wh =MIN(size.width, size.height);
    
    return CGSizeMake(wh, wh);
}






/*
 *  直接截屏
 */
+(UIImage *)cutScreen{
    return [self cutFromView:[UIApplication sharedApplication].keyWindow];
}


+(UIImage *)cutFromView:(UIView *)view{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在新建的图形上下文中渲染view的layer
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();

    return image;
}



-(UIImage *)cutWithFrame:(CGRect)frame{
    
    //创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    
    //释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
    
    
}

+ (UIImage *)viewSnapshot:(UIView *)view withInRect:(CGRect)rect;
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage,rect)];
    return image;
}

#pragma makr - 搞清截图
+ (UIImage *)viewHightSnapshot:(UIView *)view withInRect:(CGRect)rect;
{
    // 高清截屏
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 保存为图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    image = [self ct_imageFromImage:image inRect:rect];
    
    return image;
}

+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat x= rect.origin.x*scale,
    
    y=rect.origin.y*scale,
    
    w=rect.size.width*scale,
    
    h=rect.size.height*scale;
    
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    return newImage;
}


+ (UIImage *)viewSnapshotOriginal:(UIView *)view withInRect:(CGRect)rect;
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage,rect)];
    return img;

}

#pragma mark - 保存到手机相册
+ (UIImage *)saveScreenShotWithView:(UIView *)view offsetY:(CGFloat)offsetY isSavePhoto:(BOOL)isSavePhoto
{
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (view) {
        
        CGContextSaveGState(context);
        
        CGContextTranslateCTM(context, [view center].x, [view center].y);
        
        CGContextConcatCTM(context, [view transform]);
        
        CGContextTranslateCTM(context, -[view bounds].size.width*[[view layer] anchorPoint].x, -[view bounds].size.height*[[view layer] anchorPoint].y - offsetY - 10);
        
        [[view layer] renderInContext:context];
        
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGFloat heightOffset = 10;
    
    //画布创建上下文
//    UIGraphicsBeginImageContext(imageSize);
    
    UIGraphicsBeginImageContextWithOptions(imageSize,NO,[[UIScreen mainScreen] scale]);
    
    CGFloat offset = offsetY / 2.0;
    
    UIImage *topImage = [UIImage imageNamed:@"black_line_icon"];
    
    [topImage drawInRect:CGRectMake(0, 0, TYGetUIScreenWidth, offset + heightOffset)];//再把小图放在上下文中
    
    CGFloat midImageH = image.size.height + heightOffset + 5;
    
    [image drawInRect:CGRectMake(0, offset, image.size.width, midImageH)];//画到上下文中
    
    UIImage *bottomImage = [UIImage imageNamed:@"black_line_icon"];
    
    CGFloat IphonexOffset = offset + JGJ_IphoneX_BarHeight;
    
    CGFloat IphonexOffsetH = offset + JGJ_IphoneX_BarHeight;
    
    if ([NSString isFloatZero:offsetY]) {
        
        IphonexOffset += JGJ_NAV_HEIGHT;
        
        IphonexOffsetH += JGJ_NAV_HEIGHT;
    }
    
    [bottomImage drawInRect:CGRectMake(0, TYGetUIScreenHeight - IphonexOffset, TYGetUIScreenWidth, IphonexOffsetH)];//再把小图放在上下文中
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    
    UIGraphicsEndImageContext();//关闭上下文
    
    //    image = [UIImage imageByCroppingWithImage:image];
    
    image = [UIImage imageByCroppingWithImage:resultImg];
    
    if (image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            
            [image saveToAlbum:appName completionBlock:^{
                
                [TYShowMessage showSuccess:@"已保存到手机相册"];
                
            } failureBlock:^(NSError *error) {
                
                [TYShowMessage showError:@"保存图片失败"];
            }];
        });
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    CGFloat ration = 120 * 1024 / data.length;
    
    if (ration < 1) {
        
        data = UIImageJPEGRepresentation(image, ration * 0.8);
    }
    
    image = [UIImage imageWithData: data];
    
    return image;
}

//剪裁图片
+(UIImage*)imageByCroppingWithImage:(UIImage*)myImage
{
    
    CGFloat myWidth = myImage.size.width*myImage.scale;
    
    //image.size.width乘以缩放比才是真正的尺寸。
    //图像的实际的尺寸(像素)等于image.size乘以image.scale
    
    CGFloat myHeight = myImage.size.height * myImage.scale;
    
    CGRect rect = CGRectMake(0,0,myWidth,myHeight);
    
    CGImageRef imageRef = myImage.CGImage;
    
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef,rect);
    
    UIImage * cropImage = [UIImage imageWithCGImage:imagePartRef];
    
    CGImageRelease(imagePartRef);
    
    return cropImage;
    
}

+ (UIImage *)imageDataScreenShot
{
    
    CGSize imageSize = CGSizeZero;
    
    imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    
    return [UIImage imageWithData:data];;
    
}

@end
