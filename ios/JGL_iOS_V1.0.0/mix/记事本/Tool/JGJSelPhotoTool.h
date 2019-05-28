//
//  JGJSelPhotoTool.h
//  mix
//
//  Created by yj on 2019/1/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JGJSelPhotoToolSelPhotosBlock)(NSArray *photos);

typedef void(^JGJSelPhotoToolBtnPressedBlock)(NSInteger index);

@interface JGJSelPhotoTool : NSObject

@property (assign, nonatomic) NSInteger maxImageCount;

@property (nonatomic, strong) NSMutableArray *photos;

//拍照或者选择图片按钮按下

@property (nonatomic, copy) JGJSelPhotoToolBtnPressedBlock selPhotoToolBtnPressedBlock;

+(instancetype)selPhotoWithTargetVc:(UIViewController *)targetVc selPhotosBlock:(JGJSelPhotoToolSelPhotosBlock)selPhotosBlock;

- (void)showSelPhotoTool;



@end

NS_ASSUME_NONNULL_END
