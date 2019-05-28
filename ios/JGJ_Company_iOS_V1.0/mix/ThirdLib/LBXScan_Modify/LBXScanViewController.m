//
//
//  
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanViewController.h"


@interface LBXScanViewController ()

//底部遮罩用于从聊聊进入扫码底部有一块白色问题。iOS 12的问题。
@property (nonatomic, strong) UIView *bottomMaskView;

@end

@implementation LBXScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //底部遮罩用于从聊聊进入扫码底部有一块白色问题。iOS 12的问题。
    
    if (!self.bottomMaskView) {
        
        CGFloat height = JGJ_IphoneX_BarHeight + 50;
        
        UIView *bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height, TYGetUIScreenWidth, height)];
        
        bottomMaskView.backgroundColor = [UIColor blackColor];
        
        self.bottomMaskView = bottomMaskView;
        
        [TYKey_Window addSubview:bottomMaskView];
        
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = TYGetUIScreenRect;
        
        self.view.frame = rect;
        
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
        
        if (self.bottomMaskView) {
            
            [self.bottomMaskView removeFromSuperview];
            
            self.bottomMaskView = nil;
            
        }
    
    }
    
//      [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
    
    
}

- (void)reStartDevice
{
    [_scanObj startScan];
}

//启动设备
- (void)startScan
{
    if ( ![LBXScanWrapper isGetCameraPermission] )
    {
        [_qRScanView stopDeviceReadying];
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        [self showError:[NSString stringWithFormat:@"请到设置隐私中开启%@相机权限",appName]];
        
        return;
    }
    
  
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
         // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
        
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect) {
            
            cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
        }
        
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];

        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:videoView
                                              ArrayObjectType:nil
                                                     cropRect:cropRect
                                                      success:^(NSArray<LBXScanResult *> *array){
                                                          [weakSelf scanResultWithArray:array];
                                                      }];
            
        [_scanObj setNeedCaptureImage:_isNeedScanImage];
        
        [self cameraInitOver];
      
    }
    [_scanObj startScan];


    [_qRScanView stopDeviceReadying];
    
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)cameraInitOver
{
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
    
    if (self.bottomMaskView) {
        
        [self.bottomMaskView removeFromSuperview];
        
        self.bottomMaskView = nil;
        
    }
}



#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
}





//开关闪光灯
- (void)openOrCloseFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
}


#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
   
    
    picker.allowsEditing = NO;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];    
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
        
        [weakSelf scanResultWithArray:array];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//子类继承必须实现的提示
- (void)showError:(NSString*)str
{
    
}

@end
