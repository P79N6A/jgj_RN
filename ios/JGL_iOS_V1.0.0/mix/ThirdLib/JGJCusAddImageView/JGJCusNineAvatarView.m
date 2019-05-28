//
//  JGJCusNineAvatarView.m
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import "JGJCusNineAvatarView.h"

#import "TZImagePickerController.h"

#import "JGJCheckPhotoTool.h"

static JGJCusNineAvatarView *avatarView;

@interface JGJCusNineAvatarView()<JGJCusCheckViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) JGJCusCheckView *checkView;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic,strong) UIActionSheet *sheet;

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@end

@implementation JGJCusNineAvatarView

@synthesize photos = _photos;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        avatarView = self;
        
        [self setAvatarRow];
        
        [self setSubUI:nil];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.delegate = delegate;
        
//        [self setSubUI:nil];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        avatarView = self;
        
        [self setAvatarRow];
        
        [self setSubUI:nil];
    }
    
    return self;
}

- (void)setAvatarRow {
    
    if (TYGetUIScreenWidth <= 320) {
        
        self.row = 3;
        
        self.col = 3;
        
    }else {
        
        self.row = 4;
        
        self.col = 4;
    }
}

+(CGFloat)avatarSingleViewHeight {
    
    CGFloat ImgMargin = 10.0;
    
    CGFloat col = 4;
    
    if (avatarView.col > 1) {
        
        col = avatarView.col;
    }
    
    CGFloat avatarViewW = (TYGetUIScreenWidth - ImgMargin * (col + 1));
    
    CGFloat imageViewHW = avatarViewW / col;
    
    return imageViewHW;
}

- (void)setSubUI:(NSArray *)images {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.imageViews removeAllObjects];
    
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
    CGFloat ImgMargin = 10.0;
    
    CGFloat avatarViewW = (TYGetUIScreenWidth - ImgMargin * (avatarView.col + 1));
    
    CGFloat imageViewHW = avatarViewW / avatarView.col;
    
    NSInteger count = self.maxImageCount == images.count & images.count > 0 ? self.maxImageCount : images.count+ 1;
    
    if (!self.isShowAddBtn || self.isCheckImage) {
        
        count = self.maxImageCount == images.count & images.count > 0 ? self.maxImageCount : images.count;
        
    }
    
    for (NSInteger indx = 0; indx < count; indx++) {
        
        NSInteger row = indx / avatarView.row;
        
        NSInteger col = indx % avatarView.col;
        
        CGFloat x = (imageViewHW + ImgMargin) * col + ImgMargin;
        
        CGFloat y = (imageViewHW + ImgMargin) * row + ImgMargin;
        
        CGFloat width = imageViewHW;
        
        CGFloat height = imageViewHW;
        
        JGJCusCheckView *checkView = [[JGJCusCheckView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        checkView.is_sel_photo = NO;
        
        if (indx < images.count) {
            
            checkView.is_sel_photo = NO;
            
            checkView.images = @[images[indx]];
            
            [self.imageViews addObject:checkView.imageBtn.imageView];
            
            checkView.delBtn.hidden = self.isCheckImage;
            
        }else {
            
            checkView.images = nil;
            
            checkView.is_sel_photo = YES;
            
            [checkView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:5];
            
            checkView.layer.masksToBounds = YES;
            
            checkView.delBtn.hidden = YES;
        }
        
        checkView.tag = 100 + indx;
        
        self.checkView = checkView;
        
        checkView.delegate = self;
        
        checkView.backgroundColor = AppFontEB4E4EColor;
        
        [self addSubview:checkView];

    }
    
    CGFloat height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:count];
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, height);
    
}

- (void)setPhotos:(NSMutableArray *)photos {
    
    _photos = photos;
    
    [self setSubUI:_photos];
}

- (void)cusCheckView:(JGJCusCheckView *)checkView checkBtnPressed:(JGJCusCheckButton *)sender {
    
    NSInteger index = checkView.tag - 100;
    
    if (checkView.is_sel_photo) {
        
//        [self.sheet showInView:self];
        
    }else {
        
        UIViewController *vc = [self getCurrentViewController];
        
        [vc.view endEditing:YES];
        
        [JGJCheckPhotoTool browsePhotos:self.photos selImageViews:self.imageViews didSelPhotoIndex:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(cusNineAvatarView:checkView:)]) {
        
        [self.delegate cusNineAvatarView:self checkView:checkView];
        
    }
}

- (void)cusCheckView:(JGJCusCheckView *)checkView delBtnPressed:(JGJCusCheckButton *)sender {
    
    NSInteger index = checkView.tag - 100;
    
    if (index < self.photos.count) {
        
        [self.photos removeObjectAtIndex:index];
    }
    
    [self setSubUI:self.photos];
    
    if ([self.delegate respondsToSelector:@selector(cusNineAvatarView:checkView:)]) {
        
        [self.delegate cusNineAvatarView:self checkView:checkView];
        
    }
    
}

- (void)selPhotoImage {
    
    if (self.maxImageCount == 0) {
        
        self.maxImageCount = 8;
        
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
        
        [weakSelf setSubUI:weakSelf.photos];

    }];
    
    UIViewController *vc = [self getCurrentViewController];
    
    
    [vc presentViewController:imagePickerVc animated:YES completion:nil];
}

+ (CGFloat)avatarViewHeightWithPhotoCount:(NSInteger)count {
    
    if (count < avatarView.maxImageCount && avatarView.isShowAddBtn) {
        
        count += 1;
    }
    
    NSInteger offsetRow = count % avatarView.row  == 0 ? 0 : 1;
    
    NSInteger totalRow = (count / avatarView.row  + offsetRow);
    
    CGFloat imageViewHW = [JGJCusNineAvatarView avatarSingleViewHeight];
    
    CGFloat avtarViewheight = count == 0 ? imageViewHW : ((totalRow) * imageViewHW);
    
    CGFloat height = avtarViewheight + (totalRow + 1) * 10;
    
    return height;
}

#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    UIViewController *vc = [self getCurrentViewController];
    
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
    
    //显示图片选择器
    [vc presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //隐藏当前的模态窗口
    
    UIViewController *vc = [self getCurrentViewController];
    
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
        
        [vc dismissViewControllerAnimated:YES completion:nil];
        
        return ;
    }
    
    image = [UIImage imageWithData:imageData];
    
    if (image) {
        
       [self.photos addObject:image];
    }
    
    [self setSubUI:self.photos];
    
    [vc dismissViewControllerAnimated:YES completion:nil];

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

- (NSMutableArray *)imageViews {
    
    if (!_imageViews) {
        
        _imageViews = [[NSMutableArray alloc] init];
    }
    
    return _imageViews;
}

- (UIActionSheet *)sheet
{
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    return _sheet;
}

/** 获取当前View的控制器对象 */
- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
