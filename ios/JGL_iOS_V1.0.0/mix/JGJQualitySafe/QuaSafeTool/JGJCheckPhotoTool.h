//
//  JGJCheckPhotoTool.h
//  JGJCompany
//
//  Created by yj on 2017/8/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJCheckPhotoTool : NSObject

//msg_src 图片地址  imageViews view的子视图imageView selPhotoIndex选中的图片
+ (void)browsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex;

//web查看图片 msg_src 图片地址  imageViews view的子视图imageView selPhotoIndex选中的图片
+ (void)webBrowsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex;

//聊天界面web查看图片 msg_src 图片地址  imageViews view的子视图imageView selPhotoIndex选中的图片
+ (void)chatViewWebBrowsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex;

//添加图片最新样式，查看图片方法
+ (void)browsePhotos:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex;
@end
