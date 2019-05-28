//
//  UIPhotoViewController.h
//  mix
//
//  Created by Tony on 16/5/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPhoto.h"

@class UIPhotoViewController;
@protocol UIPhoneViewControllerDelegate <NSObject>

-(void)phoneVcDelegate:(UIPhotoViewController *)phoneVc ImagesArrayAddEnd:(NSArray *)imagesArr;

@end
@interface UIPhotoViewController :UIViewController
<
    UIActionSheetDelegate,
    UICollectionViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    LGPhotoPickerViewControllerDelegate,
    LGPhotoPickerBrowserViewControllerDelegate,
    LGPhotoPickerBrowserViewControllerDataSource
>
@property (nonatomic , weak) id<UIPhoneViewControllerDelegate> phoneVcDelegate;

@property (nonatomic,strong) UIActionSheet *sheet;
@property (nonatomic,assign) NSInteger maxImageCount;//最大的照片数量

@property (nonatomic,strong) UIImage *cameraImage;//拍照的图片
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) NSMutableArray *imagesUrlArray;//存放从服务器获取的url
@property (nonatomic,assign) NSInteger imageSelectedIndex;
@property (nonatomic,strong) NSMutableArray <LGPhotoAssets *>*selectedAssets;
@property (nonatomic,strong) LGPhotoPickerViewController *pickerVc;
@property (nonatomic,strong) LGPhotoPickerBrowserViewController *broswerVc;
@property (nonatomic,strong) UIImagePickerController *imagePickerController;

/**
 *  初始化sheet,imagePc
 *
 */
- (void)initSheetImagePicker;

/**
 *  增加完图片,供子界面调用
 *
 *  @param phoneVc   phonevc
 *  @param imagesArr 增加完的图片数组
 */
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr;

/**
 *  打开图片浏览器
 *
 *  @param style 打开的类型
 */
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style;

/**
 *  打开图片选择钱
 *
 *  @param style 类型
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style;

/**
 *  删除imageArr对应的图片和selectedAssets对应的assets
 *
 *  @param index 删除的索引
 */
- (void)removeImageAtIndex:(NSInteger )index;
@end
