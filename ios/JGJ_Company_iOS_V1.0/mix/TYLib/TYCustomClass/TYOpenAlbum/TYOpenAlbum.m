//
//  TYOpenAlbum.m
//  mix
//
//  Created by jizhi on 15/11/11.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  

#import "TYOpenAlbum.h"

#define ImageRatio 0.5

@interface TYOpenAlbum ()

@property (nonatomic ,strong) UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> *superViewController;
@end

@implementation TYOpenAlbum
/**
 *  图片选择
 */
-(void)addHeadImageInView:(UIViewController *)viewController
{//图片选择
    self.superViewController = [viewController copy];

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self.superViewController cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.superViewController.view];
}

#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.superViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self.superViewController;
    imagePicker.allowsEditing = YES;
    
    if(buttonIndex == 0){//照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{//相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //显示图片选择器
    [self.superViewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, ImageRatio);

    [self.imagesArray addObject:imageData];
    //隐藏当前的模态窗口
    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
    self.superViewController = nil;
}
@end
