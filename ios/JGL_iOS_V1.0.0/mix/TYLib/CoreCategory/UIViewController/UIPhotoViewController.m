//
//  UIPhotoViewController.m
//  mix
//
//  Created by Tony on 16/5/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"
#import "NSString+Extend.h"

#import "TZImagePickerController.h"

#import "TYUIImage.h"
#import "UIImageView+JKAddition.h"
#import "JGJLocationManger.h"

#import "JGJImage.h"

#define JGJPhotoMaxW 828

@interface UIPhotoViewController ()

@property (nonatomic, strong) JGJLocationMangerModel *locationMangerModel;
@property (nonatomic, strong) LGPhotoPickerBrowserPhoto *photo;
@property (nonatomic, strong) NSMutableArray *array;
@end
@implementation UIPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSheetImagePicker];
    self.maxImageCount = 4;
    
    if (![self isKindOfClass:NSClassFromString(@"JGJMarkBillRemarkViewController")] && self.isNeedWatermark) {

        TYWeakSelf(self);
        [JGJLocationManger locationMangerBlock:^(JGJLocationMangerModel *locationMangerModel) {

            weakself.locationMangerModel = locationMangerModel;
        }];
    }
    
}

- (JGJLocationMangerModel *)locationMangerModel {
    
    if (!_locationMangerModel) {
        
        _locationMangerModel = [[JGJLocationMangerModel alloc] init];;
    }
    return _locationMangerModel;
}
- (void)removeImageAtIndex:(NSInteger )index{
    [self.imagesArray removeObjectAtIndex:index];
    
    if (self.selectedAssets.count == 0) {
        return;
    }
//    [self.selectedAssets removeObjectAtIndex:index];
}

- (void)initSheetImagePicker{
    //不使用懒加载，主要先初始化，避免速度慢
    if (!self.sheet) {
        //设置拍照的点击
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    
    if (!self.imagePickerController) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
//        self.imagePickerController.allowsEditing = YES;
    }
}

#pragma mark - actionSheet的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex == 0){//照相
//        // 记事本 拍照 清除之前选的图片
//        if ([self isKindOfClass:NSClassFromString(@"JGJAddNewNotepadViewController")]) {
//            
////            [self.broswerVc.selectedAssets removeAllObjects];
////            [self.imagesArray removeAllObjects];
//        }
        
        //选择相册
        [self selTakePhoto];
    }
    else{//相册
        
        [self selPhotoAlbum];
    }
}

/**
 *  选择相册
 */
- (void)selTakePhoto{
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

/**
 *  选择拍照
 */
- (void)selPhotoAlbum {
    
    [self.broswerVc.selectedAssets removeAllObjects];
    
    //聊天上传图片清楚原来的数据，通知发图片则保留
    if ([self isKindOfClass:NSClassFromString(@"JGJChatRootVc")]) {
        
        [self.imagesArray removeAllObjects];
    }
    
    //2.3.5 -yj移除
    //        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
    
    //2.3.5 -yj添加
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount delegate:self];
    
    __weak typeof(self) weakSelf = self;
    
    __block NSMutableArray *photoAssets = [NSMutableArray new];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        //3.4聊天添加
        weakSelf.chatSelAssets = assets;
        
        [weakSelf pickerViewControllerDoneAsstes:photos isOriginal:isSelectOriginalPhoto];
    }];
    
    imagePickerVc.allowPickingVideo = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self setImage:info ByPicker:picker];
}

- (void)setImage:(NSDictionary *)info ByPicker:(UIImagePickerController *)picker{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        
        return;
    }else {
        
        CGFloat maxW = JGJPhotoMaxW;
        
        CGFloat ration = 1;
        
        if (image.size.width > image.size.height) {
            
            ration = (image.size.width / image.size.height) * 0.95;
            
            image = [JGJImage imageScale:image withSize:CGSizeMake((maxW * ration), maxW)];
            
        }else {
            
            ration = (image.size.height / image.size.width) * 0.95;
            
            image = [JGJImage imageScale:image withSize:CGSizeMake(maxW,(maxW * ration))];
            
        }
        
        
    }
    
    //隐藏当前的模态窗口
    [picker dismissViewControllerAnimated:YES completion:nil];

    if (self.isNeedWatermark) {
        
        if (self.locationMangerModel) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 120)];
            imageView.image = image;
            
            self.cameraImage = [imageView jk_setImage:image withWaterMark:IMAGE(@"watermarkMasking") inRect:CGRectMake(0, imageView.bounds.size.height - 100, imageView.bounds.size.width, 100)];
            
            // 1.获取名字
            NSString *name = [TYUserDefaults objectForKey:JGJUserName];
            // 2.获取当前拍摄时间
            NSString *currentTime = [[NSString alloc] init];
            currentTime = [NSString stringFromDate:[NSDate date] withDateFormat:@"yyyy-MM-dd HH:ss"];
            NSString *name_time = [[NSString alloc] initWithFormat:@"%@   %@",name,currentTime];
            
            // 3.获取当前定位信息
            NSString *address = [NSString stringWithFormat:@"%@%@ %@",self.locationMangerModel.city,self.locationMangerModel.address,self.locationMangerModel.name];
            
            // 先绘制位置信息
            CGFloat addressHeight = [NSString stringWithContentWidth:imageView.bounds.size.width - 30 content:address font:AppFont26Size];
            self.cameraImage = [imageView jk_setImage:self.cameraImage withStringWaterMark:address inRect:CGRectMake(15, imageView.bounds.size.height - 12 - addressHeight, imageView.bounds.size.width - 30, addressHeight) color:AppFontffffffColor font:FONT(AppFont26Size)];
            
            CGFloat name_timeHeight = [NSString stringWithContentWidth:imageView.bounds.size.width - 30 content:name_time font:AppFont26Size];
            // 绘制姓名和时间
            self.cameraImage = [imageView jk_setImage:self.cameraImage withStringWaterMark:name_time inRect:CGRectMake(15, imageView.bounds.size.height - 12 - addressHeight - 13 - name_timeHeight, imageView.bounds.size.width - 30, name_timeHeight) color:AppFontffffffColor font:FONT(AppFont26Size)];
        }
        
    }else {
        
        self.cameraImage = image;
    }
    
    [self.imagesArray addObject:self.cameraImage];
    
    if (self.phoneVcDelegate && [self.phoneVcDelegate respondsToSelector:@selector(phoneVcDelegate:ImagesArrayAddEnd:)]) {
        [self.phoneVcDelegate phoneVcDelegate:self ImagesArrayAddEnd:[self.imagesArray copy]];
    }else{
        [self phoneVc:self imagesArrayAddEnd:[self.imagesArray copy]];
    }
    
    image = [self fixOrientation:self.cameraImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    //使用完就置nil
    self.pickerVc = nil;
    
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
    self.pickerVc.maxCount = self.maxImageCount;// - self.imagesArray.count;   // 最多能选N张图片
    [self.pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    NSMutableArray *muAssets = [assets mutableCopy];
    
    //去掉重复的数据
    for (LGPhotoAssets *lastSelAssets in self.selectedAssets) {
        
        for (LGPhotoAssets *curselAssets in assets) {
            
            if ([lastSelAssets isEqual:curselAssets]) {
                [muAssets removeObject:curselAssets];
            }
        }
    }
    
    assets = muAssets.copy;
    
    NSUInteger maxSelCount = self.imagesArray.count + assets.count;
    
    if (maxSelCount > 9) {
        
        [TYShowMessage showPlaint:@"最多只能上传9张照片"];
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger cameraIndex = -1;
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
    
    [assets enumerateObjectsUsingBlock:^( UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        //yj-3.3.0添加(PhotoBrowser)
        
        NSData *data2 = [TYUIImage imageData:obj];
        
        UIImage *image = [UIImage imageWithData:data2];

        [imagesArray addObject:image];
        
        //yj-3.3.0移除(PhotoBrowser)
//        [imagesArray addObject:obj.YZGGetImage];
    }];
    
    //    [self.imagesArray removeAllObjects];//先清空，状态都已经保存好了，只需要马上添加
    //    [self.selectedAssets removeAllObjects];
    
    
    //放入url照片
    if (self.imagesUrlArray.count) {
        // 去重
        for (int i = 0; i < self.imagesUrlArray.count; i ++) {
            
            if (![self.imagesArray containsObject:self.imagesUrlArray[i]]) {
                
                [self.imagesArray addObject:self.imagesUrlArray[i]];
            }
        }
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
    if (self.cameraImage && cameraIndex != -1) {
        if (self.imagesArray.count < cameraIndex) {
            cameraIndex = self.imagesArray.count;
        }
    }
    
    
    self.broswerVc.selectedAssets = self.selectedAssets;
    
    if (self.phoneVcDelegate && [self.phoneVcDelegate respondsToSelector:@selector(phoneVcDelegate:ImagesArrayAddEnd:)]) {
        [self.phoneVcDelegate phoneVcDelegate:self ImagesArrayAddEnd:[self.imagesArray copy]];
    }else{
        [self phoneVc:self imagesArrayAddEnd:[imagesArray copy]];
    }
    //使用完就置nil
    self.pickerVc = nil;

}

#pragma mark - 图片浏览器取消
- (void)pickerViewControllerCancel{
    //使用完就置nil
    self.pickerVc = nil;
}

#pragma mark - 图片浏览器
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    
    self.broswerVc.showType = style;
    self.broswerVc.imageSelectedIndex = self.imageSelectedIndex;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:self.broswerVc animated:YES completion:nil];
}

#pragma mark - 图片浏览器
// 图片编辑完成返回
- (void)photoBrowserCompleteBtnClickWithCurrentIndexPatch:(NSInteger)currentPage image:(UIImage *)image {
    
    [self.imagesArray replaceObjectAtIndex:currentPage withObject:image];
    
    if (self.phoneVcDelegate && [self.phoneVcDelegate respondsToSelector:@selector(phoneVcDelegate:ImagesArrayAddEnd:)]) {
        [self.phoneVcDelegate phoneVcDelegate:self ImagesArrayAddEnd:[self.imagesArray copy]];
    }else{
        [self phoneVc:self imagesArrayAddEnd:[self.imagesArray copy]];
    }
    
    //使用完就置nil
    self.pickerVc = nil;
}
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.imagesArray.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *LGPhotoPickerBrowserArray = [[NSMutableArray alloc] init];
    
//    [self.imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        _photo = [[LGPhotoPickerBrowserPhoto alloc] init];
//        
//        if ([obj isKindOfClass:[NSString class]]) {
//            
//            NSString *finalPicUrl = [JLGHttpRequest_Public stringByAppendingString:obj];
//            _photo.photoURL = [NSURL URLWithString:finalPicUrl];
//            
//        }else{
//            
//            _photo.photoImage = obj;
//
//        }
//        
//        [LGPhotoPickerBrowserArray addObject:_photo];
//    }];
    
    for (NSInteger index = 0; index < self.imagesArray.count;index++) {
        
        id obj = self.imagesArray[index];
        
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            NSString *finalPicUrl = [JLGHttpRequest_Public stringByAppendingString:obj];
            
            photo.photoURL = [NSURL URLWithString:finalPicUrl];
            
        }else{
            
            photo.photoImage = obj;
            
        }
        
        [LGPhotoPickerBrowserArray addObject:photo];
    }
    
    return [LGPhotoPickerBrowserArray objectAtIndex:indexPath.item];
}


#pragma mark - 懒加载
- (LGPhotoPickerBrowserViewController *)broswerVc
{
    if (!_broswerVc) {
        _broswerVc = [[LGPhotoPickerBrowserViewController alloc] init];
        _broswerVc.isShowEditeBtn = self.isShowEditeBtn;
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

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
