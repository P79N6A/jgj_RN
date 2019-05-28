//
//  HJPhotoBrowser.h
//  photobrowser
//
//  Created by zuweizhong on 16-2-3.
//  Copyright (c) 2015年 zuweizhong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HJButton, HJPhotoBrowser;

@protocol HJPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(HJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(HJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface HJPhotoBrowser : UIView <UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray *subImageViews;

@property (nonatomic, weak) id<HJPhotoBrowserDelegate> delegate;

- (void)show;

@end
