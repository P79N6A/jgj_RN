//
//  MJPhoto.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MJPhoto : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, strong) NSString *photoDescription; // 描述

@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;

@property (nonatomic, assign) BOOL firstShow;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引

//是否是H5查看图片，H5查看图片中间放大回到中间
@property (nonatomic, assign) BOOL isH5CheckPhoto;

//添加图片最新样式查看图片，判断是否存在图片。保证不影响以前

@property (nonatomic, assign) BOOL isExistImage;
@end
