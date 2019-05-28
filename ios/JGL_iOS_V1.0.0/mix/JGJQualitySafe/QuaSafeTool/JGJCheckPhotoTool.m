//
//  JGJCheckPhotoTool.m
//  JGJCompany
//
//  Created by yj on 2017/8/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPhotoTool.h"

#import "MJPhotoBrowser.h"

#import "MJPhoto.h"

@implementation JGJCheckPhotoTool

#pragma mark - 添加图片最新样式，查看图片方法

+ (void)browsePhotos:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex {
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSInteger index = 0; index < msg_src.count; index++) {
        
        NSString *file_path = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,msg_src[index]];
        
        UIImageView *imageView = imageViews[index];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSURL *filePathUrl = [NSURL URLWithString:file_path]; // 图片路径
        
        photo.url = filePathUrl; // 图片路径
        
        photo.isExistImage = YES;
        
        photo.image = imageView.image;
        
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = selPhotoIndex; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
    
}

+ (void)browsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex {
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSInteger index = 0; index < msg_src.count; index++) {
        
        NSString *file_path = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,msg_src[index]];
        
        UIImageView *imageView = imageViews[index];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSURL *filePathUrl = [NSURL URLWithString:file_path]; // 图片路径
        
        photo.url = filePathUrl; // 图片路径
        
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = selPhotoIndex; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
    
}

+ (void)webBrowsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex {
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSInteger index = 0; index < msg_src.count; index++) {
        
        NSString *file_path = msg_src[index];
        
        UIImageView *imageView = imageViews[index];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        photo.isH5CheckPhoto = YES;
        
        NSURL *filePathUrl = [NSURL URLWithString:file_path]; // 图片路径
        
        photo.url = filePathUrl; // 图片路径
        
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = selPhotoIndex; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
}

+ (void)chatViewWebBrowsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex {
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSInteger index = 0; index < msg_src.count; index++) {
        
        NSString *file_path = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,msg_src[index]];
        
        UIImageView *imageView = imageViews[index];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        id image = msg_src[index];
        
        if ([image isKindOfClass:[UIImage class]] && selPhotoIndex == index) {
            
            photo.isExistImage = YES;
            
            photo.image = image;
            
        }
        
        photo.isH5CheckPhoto = YES;
        
        NSURL *filePathUrl = [NSURL URLWithString:file_path]; // 图片路径
        
        photo.url = filePathUrl; // 图片路径
        
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    browser.currentPhotoIndex = selPhotoIndex; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
}

@end
