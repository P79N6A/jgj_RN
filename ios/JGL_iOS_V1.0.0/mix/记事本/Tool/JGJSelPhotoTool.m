//
//  JGJSelPhotoTool.m
//  mix
//
//  Created by yj on 2019/1/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSelPhotoTool.h"

#import "TZImagePickerController.h"

#import "JGJAddNewNotepadViewController.h"

@interface JGJSelPhotoTool ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, copy) JGJSelPhotoToolSelPhotosBlock selPhotosBlock;

@property (nonatomic, strong) UIViewController *targetVc;

@property (nonatomic,strong) UIActionSheet *sheet;

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@end

@implementation JGJSelPhotoTool

+(instancetype)selPhotoWithTargetVc:(UIViewController *)targetVc selPhotosBlock:(JGJSelPhotoToolSelPhotosBlock)selPhotosBlock {
    
    return [[self alloc] initWithSelPhotosBlock:selPhotosBlock targetVc:targetVc];
    
}

- (instancetype)initWithSelPhotosBlock:(JGJSelPhotoToolSelPhotosBlock)selPhotosBlock targetVc:(UIViewController *)targetVc{
    
    self = [super init];
    
    if (self) {
        
        self.selPhotosBlock = selPhotosBlock;
        
        self.targetVc = targetVc;
        
        [self selPhotosBlock];
        
    }
    
    return self;
    
}

- (void)showSelPhotoTool {
    
    [self.sheet showInView:self.targetVc.view];
    
}

- (void)selPhotoImage {
    
    if (self.maxImageCount == 0) {
        
        self.maxImageCount = 9;
        
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount delegate:self];
    
    __weak typeof(self) weakSelf = self;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSInteger maxCount = weakSelf.photos.count + photos.count;
        
        if (maxCount > weakSelf.maxImageCount) {
            
            NSString *des = [NSString stringWithFormat:@"最多只能上传%@张照片", @(weakSelf.maxImageCount)];
            
            [TYShowMessage showPlaint:des];
            
            return ;
        }
        
        [weakSelf.photos addObjectsFromArray:photos];
        
        if (weakSelf.selPhotosBlock) {
            
            weakSelf.selPhotosBlock(photos);
        }
        
    }];
    
    [self.targetVc  presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    UIViewController *vc = self.targetVc;
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex == 0){//照相
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{//相册
        
        [self selPhotoImage];
    }
    
    if (self.selPhotoToolBtnPressedBlock) {
        
        self.selPhotoToolBtnPressedBlock(buttonIndex);
    }
    
    //显示图片选择器
    [vc presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSInteger maxCount = self.photos.count + 1;
    
    if (maxCount > self.maxImageCount) {
        
        NSString *des = [NSString stringWithFormat:@"最多只能上传%@张照片", @(self.maxImageCount)];
        
        [TYShowMessage showPlaint:des];
        
        [self.targetVc dismissViewControllerAnimated:YES completion:nil];
        
        return ;
    }
    
    image = [UIImage imageWithData:imageData];
    
    if (image) {
        
        [self.photos addObject:image];
        
        if (self.selPhotosBlock) {
            
            self.selPhotosBlock(@[image]);
        }
    }
    
    [self.targetVc dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSMutableArray *)photos {
    
    if (!_photos) {
        
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
//        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (UIActionSheet *)sheet
{
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    return _sheet;
}

@end
