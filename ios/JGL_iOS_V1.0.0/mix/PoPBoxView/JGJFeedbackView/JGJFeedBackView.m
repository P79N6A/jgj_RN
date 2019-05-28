//
//  JGJFeedBackView.m
//  mix
//
//  Created by yj on 2019/2/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJFeedBackView.h"

#import "JGJCustomShareMenuView.h"
#import "JGJShareMenuView.h"

#import "JGJWebAllSubViewController.h"


#import "JGJMangerTool.h"

typedef void(^JGJFeedBackViewUploadBlock)(NSString *url);

@interface JGJFeedBackView ()

@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *feedBackBtn;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (copy, nonatomic) NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (copy, nonatomic) JGJFeedBackViewUploadBlock uploadBlock;

@property (strong, nonatomic) JGJMangerTool *timerTool;

@end

@implementation JGJFeedBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self setupView];
        
    }
    return self;
}

-(void)setupView{
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];

    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.contentDetailView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

    [self.contentDetailView.layer setLayerCornerRadius:5];
    
    self.shotImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.shotImageView.clipsToBounds = YES;
    
//    CGFloat btnCornerRadius = (self.cancelBtn.imageView.image.size.width / 2.0);
//
//    [self.cancelBtn.layer setLayerCornerRadius:btnCornerRadius];
    
    self.cancelBtn.clipsToBounds = YES;
}

- (void)setIs_shot_screen:(BOOL)is_shot_screen {
    
    _is_shot_screen = is_shot_screen;
    
    if (is_shot_screen) {
        
        [self userDidTakeScreenshot];
        
        //初始化定时器
        if (!_timerTool) {
            
            _timerTool = [[JGJMangerTool alloc] init];
            
            _timerTool.timeInterval = 5;
            
        }
        
        TYWeakSelf(self);
        
        [_timerTool startTimer];
        
        TYLog(@"--------截屏显示");
        
        
        _timerTool.toolTimerBlock = ^{
            
            [weakself dismiss];
            
            TYLog(@"--------截屏消失");
        };
        
    }
    
    
}

//截屏响应
- (void)userDidTakeScreenshot
{
    NSLog(@"检测到截屏");
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *shotImage = [self imageDataScreenShot];
    
    self.shotImageView.image = shotImage;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        [window addSubview:self];
        
    });
    
//    [self uploadImageRequest];
    
}

- (void)uploadImageRequest {
    
    if (!self.shotImageView.image) {
        
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:@[self.shotImageView.image] otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        NSArray *urls = (NSArray *)responseObject;
        
        if (urls.count > 0) {
            
            self.imageUrl = urls.firstObject;
            
            if (self.uploadBlock) {
                
                self.uploadBlock(self.imageUrl);
                
            }
        }
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (IBAction)shareBtnPressed:(UIButton *)sender {
    
    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];

    JGJShowShareMenuModel *shareModel = [[JGJShowShareMenuModel alloc] init];
    
    shareModel.is_show_savePhoto = YES;
    
    shareMenuView.Vc = self.targetVc;
    
    shareModel.shareImage = self.shotImageView.image;
    
    shareMenuView.shareMenuModel = shareModel;
    
    [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
    
    shareMenuView.savePhotoBtnH.constant = 0;
    
    shareMenuView.savePhotoBtn.hidden = YES;
    
    [self dismiss];
    
}

- (IBAction)feedBackBtnPressed:(UIButton *)sender {
    
    [self uploadImageRequest];
    
    NSString *url = [NSString stringWithFormat:@"%@my/feedback-post?pic=%@",JGJWebDiscoverURL, self.imageUrl];
    
    TYWeakSelf(self);
    
    if ([NSString isEmpty:self.imageUrl]) {
        
        self.uploadBlock = ^(NSString *url) {
            
            url = [NSString stringWithFormat:@"%@my/feedback-post?pic=%@",JGJWebDiscoverURL, url];
            
            [weakself feedBackWebVcWithUrl:url];
            
            [weakself dismiss];
            
        };
        
        
    }
    
//    else {
//
//        [self feedBackWebVcWithUrl:url];
//    }
    
//    [self dismiss];
    
}

- (void)feedBackWebVcWithUrl:(NSString *)url {
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
    
    UIViewController *vc = (UIViewController *)self.targetVc;
    
    if (!vc.navigationController) {
        
        [vc presentViewController:webVc animated:YES completion:nil];
        
    }else {
        
        [vc.navigationController pushViewController:webVc animated:YES];
        
    }
    
}

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    
    [self dismiss];
}

- (UIImage *)imageDataScreenShot
{

    CGSize imageSize = CGSizeZero;
    
    imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    return [UIImage imageWithData:data];;
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeView];
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self.contentView) {
        
        [UIView animateWithDuration:0.08 animations:^{
           
            self.contentView.alpha = 0;
            
            [self removeView];
            
        }];
    }
}

- (void)removeView {
    
    [self removeFromSuperview];
    
    [_timerTool inValidTimer];
}

@end
