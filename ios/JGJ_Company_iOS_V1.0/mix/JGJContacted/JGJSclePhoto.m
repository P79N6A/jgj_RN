//
//  JGJSclePhoto.m
//  mix
//
//  Created by Tony on 2016/12/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSclePhoto.h"
#import "JGJPhotoImageScale.h"
#import "UIImageView+WebCache.h"
@implementation JGJSclePhoto
+(void)InitImageURL:(NSString *)URL_Str
{
    JGJPhotoImageScale *view = [[JGJPhotoImageScale alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,URL_Str]]];
    [view StartAnimation];


}
@end
