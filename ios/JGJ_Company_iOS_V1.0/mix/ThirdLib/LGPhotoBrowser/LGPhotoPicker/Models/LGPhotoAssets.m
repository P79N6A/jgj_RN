//
//  LGAssets.m
//  LGPhotoBrowser
//
//  Created by ligang on 15/10/27.
//  Copyright (c) 2015年 L&G. All rights reserved.

#import "LGPhotoAssets.h"
#import "LGPhotoPickerCommon.h"
//tony修改过的
#import "TYUIImage.h"

//static CGFloat saveOriginImageRadio = 0.0001;

@implementation LGPhotoAssets
- (UIImage *)YZGGetImage{
    return  self.compressionImage?:self.thumbImage;
}

- (UIImage *)thumbImage{
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    if (IOS9_OR_LATER) {
        return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    } else {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
   
}

- (UIImage *)compressionImage{
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    
    //ton修改过的
    NSData *data2 = [TYUIImage imageData:fullScreenImage];
    
    //    NSData *data2 = UIImageJPEGRepresentation(fullScreenImage, 0.1);
    UIImage *image = [UIImage imageWithData:data2];
    fullScreenImage = nil;
    data2 = nil;
    return image;
}

- (UIImage *)originImage{
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    if (!image) {
        image = self.YZGGetImage;
    }
    return image;
}

- (UIImage *)fullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];

    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

- (BOOL)isVideoType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}

@end
