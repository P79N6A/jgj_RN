//
//  UIPhotoViewController.m
//  mix
//
//  Created by Tony on 16/5/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"
#import "NSString+Extend.h"

@implementation UIPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSheetImagePicker];
    self.maxImageCount = 4;
}

- (void)removeImageAtIndex:(NSInteger )index{
    [self.imagesArray removeObjectAtIndex:index];
    
    if (self.selectedAssets.count == 0) {
        return;
    }
    [self.selectedAssets removeObjectAtIndex:index];
}

- (void)initSheetImagePicker{
    //不使用懒加载，主要先初始化，避免速度慢
    if (!self.sheet) {
        //设置拍照的点击
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"头像设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
    }
}

#pragma mark - actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex == 0){//照相
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else{//相册
        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
    }
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self setImage:info ByPicker:picker];
}

- (void)setImage:(NSDictionary *)info ByPicker:(UIImagePickerController *)picker{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    //隐藏当前的模态窗口
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.cameraImage = image;
    [self.imagesArray addObject:self.cameraImage];
    
    if (self.phoneVcDelegate && [self.phoneVcDelegate respondsToSelector:@selector(phoneVcDelegate:ImagesArrayAddEnd:)]) {
        [self.phoneVcDelegate phoneVcDelegate:self ImagesArrayAddEnd:[self.imagesArray copy]];
    }else{
        [self phoneVc:self imagesArrayAddEnd:[self.imagesArray copy]];
    }
}

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr{

}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    self.pickerVc.showType = style;
    
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (LGPhotoAssets *assets in self.selectedAssets) {
        if (![NSString isEmpty:[[assets assetURL] absoluteString]]) {
            [selectedAssets addObject:assets];
        }
    }
    
    self.pickerVc.selectPickers = selectedAssets;
    self.pickerVc.maxCount = self.maxImageCount - self.imagesArray.count;   // 最多能选N张图片
    [self.pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger cameraIndex = 0;
    __block NSMutableArray *imagesArray = [NSMutableArray array];
    
    //记录url照片
    [self.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {//将url先保存起来
        if ([obj isKindOfClass:[NSString class]]) {
            [imagesArray addObject:obj];
        }else if(weakSelf.cameraImage && [[NSString stringWithFormat:@"%p",obj] isEqualToString:[NSString stringWithFormat:@"%p",weakSelf.cameraImage]]){//如果有拍照的图片，并且idx时就是拍照的图片，记录index
            cameraIndex = idx;
        }
    }];
    
    self.imagesUrlArray = [imagesArray mutableCopy];
    
    [imagesArray removeAllObjects];//清空，获取照片
    [assets enumerateObjectsUsingBlock:^( LGPhotoAssets *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imagesArray addObject:obj.YZGGetImage];
    }];
    
    [self.imagesArray removeAllObjects];//先清空，状态都已经保存好了，只需要马上添加
    [self.selectedAssets removeAllObjects];
    
    //放入url照片
    if (self.imagesUrlArray.count) {
        [self.imagesArray addObjectsFromArray:self.imagesUrlArray];
        [self.imagesUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.selectedAssets addObject:[LGPhotoAssets new]];//只用来占位，没有作用
        }];
    }
    
    //放入获取的本地图片
    if (imagesArray.count) {
        [self.imagesArray addObjectsFromArray:imagesArray];
        [self.selectedAssets addObjectsFromArray:assets];
    }

    //在原来的位置插入相机照片
    if (self.cameraImage && cameraIndex) {
        if (self.imagesArray.count < cameraIndex) {
            cameraIndex = self.imagesArray.count;
        }
        [self.imagesArray insertObject:self.cameraImage atIndex:cameraIndex];
        [self.selectedAssets insertObject:[LGPhotoAssets new] atIndex:cameraIndex];
    }
    
    if (self.phoneVcDelegate && [self.phoneVcDelegate respondsToSelector:@selector(phoneVcDelegate:ImagesArrayAddEnd:)]) {
        [self.phoneVcDelegate phoneVcDelegate:self ImagesArrayAddEnd:[self.imagesArray copy]];
    }else{
        [self phoneVc:self imagesArrayAddEnd:[self.imagesArray copy]];
    }
}

#pragma mark - 图片浏览器
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    self.broswerVc.showType = style;
    self.broswerVc.imageSelectedIndex = self.imageSelectedIndex;
    [self presentViewController:self.broswerVc animated:YES completion:nil];
}

#pragma mark - 图片浏览器
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.imagesArray.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *LGPhotoPickerBrowserArray = [[NSMutableArray alloc] init];
    
    [self.imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *finalPicUrl = [JLGHttpRequest_AFNUrl stringByAppendingString:obj];
            photo.photoURL = [NSURL URLWithString:finalPicUrl];
        }else{
            photo.photoImage = obj;
        }
        
        [LGPhotoPickerBrowserArray addObject:photo];
    }];
    
    return [LGPhotoPickerBrowserArray objectAtIndex:indexPath.item];
}

#pragma mark - 懒加载
- (LGPhotoPickerBrowserViewController *)broswerVc
{
    if (!_broswerVc) {
        _broswerVc = [[LGPhotoPickerBrowserViewController alloc] init];
        _broswerVc.delegate = self;
        _broswerVc.dataSource = self;
    }
    
    return _broswerVc;
}

- (NSMutableArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

- (NSMutableArray *)imagesUrlArray
{
    if (!_imagesUrlArray) {
        _imagesUrlArray = [[NSMutableArray alloc] init];
    }
    return _imagesUrlArray;
}

- (LGPhotoPickerViewController *)pickerVc
{
    if (!_pickerVc) {
        _pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
        _pickerVc.status = PickerViewShowStatusCameraRoll;
        _pickerVc.delegate = self;
    }
    
    return _pickerVc;
}


- (NSMutableArray <LGPhotoAssets *>*)selectedAssets
{
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

@end
