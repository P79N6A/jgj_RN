//
//  TYUIImage.m
//  mix
//
//  Created by jizhi on 15/12/18.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYUIImage.h"

#define TYUIImageCompressionQuality 0.1

@implementation TYUIImage

#pragma mark - 压缩到100k以内
+(NSData *)imageData:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 0.7);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.6);
        }
    }
    
    return data;
}

@end
