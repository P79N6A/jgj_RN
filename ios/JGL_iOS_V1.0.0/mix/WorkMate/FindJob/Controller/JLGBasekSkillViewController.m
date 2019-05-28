//
//  JLGBasekSkillViewController.m
//  mix
//
//  Created by jizhi on 15/11/29.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBasekSkillViewController.h"
#import "TYShowMessage.h"
#import "TYLoadingHub.h"
#import "JLGAddImageView.h"
#import "CALayer+SetLayer.h"
#import "UIButton+WebCache.h"
#import "NSString+Extend.h"



#define margin 20
#define minY   64
@interface JLGBasekSkillViewController ()
<
    JLGAddImageViewDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>
{
    CGFloat _imageViewW;
    UIActionSheet *_sheet;
    NSInteger _imageIndex;
    NSInteger _totalImageIndex;
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic,strong) UIButton *finishButton;
@property (nonatomic,assign) NSInteger beforeImageNum;//记录以前的照片数量
@property (nonatomic,strong) NSMutableArray *addImageViewArray;//存放addImageView 的数组

@end

@implementation JLGBasekSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewInit];
    [self JLGHttpRequest];
}

- (void)JLGHttpRequest{
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/showproexperience" parameters:@{@"pid":self.dataDic[@"pid"]} success:^(NSDictionary *responseObject) {
        NSArray *urlArray = responseObject[@"url"];
        if (urlArray.count < 1) {
            return ;
        }
        weakSelf.beforeImageNum = urlArray.count;

        //添加图片
        [urlArray enumerateObjectsUsingBlock:^(NSString *picUrl, NSUInteger idx, BOOL *stop) {
            
            if (idx >= 9) {
                return ;
            }
            //添加addImage
            _imageIndex = idx;
            
            if (idx == 8) {
                [weakSelf addImagesWithFinishButton];
            }else{
                idx == urlArray.count - 1?[weakSelf addImagesWithFinishButton]:[weakSelf addImagesNoFinishButton];
            }

            
            //显示图片并更新
            JLGAddImageView *jlgAddImageView = self.addImageViewArray[_imageIndex];
            
            //获取网络图片
            [jlgAddImageView.addImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[JLGHttpRequest_Public stringByAppendingString:picUrl]] forState:UIControlStateNormal placeholderImage:nil];
            jlgAddImageView.userInteractionEnabled = NO;
            [weakSelf.addImageViewArray replaceObjectAtIndex:_imageIndex withObject:jlgAddImageView];
        }];
    }];
}

- (void)dealloc{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *  obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        if ([obj isKindOfClass:[JLGAddImageView class]]) {
            JLGAddImageView *addImageView = (JLGAddImageView *)obj;
            addImageView.delegate = nil;
            addImageView = nil;
        }
    }];
    
    self.addImageViewArray = nil;
    self.finishButton = nil;
}

- (void)setViewInit{
    
    //添加addImageView
    _imageViewW = (TYGetUIScreenWidth - 4*margin)/3;//每个imagView的高度
    self.addImageViewArray = [NSMutableArray array];
    CGFloat imageY = margin + minY;
    imageY -= TYiOS8Later?44:0;
    CGRect frame = TYSetRect(margin, imageY, _imageViewW, _imageViewW);
    [self addAddImageViewWithTag:0 frame:frame];
    
    //发布按钮
    self.finishButton = [[UIButton alloc] init];
    self.finishButton.backgroundColor = JLGBlueColor;
    [self.finishButton.layer setLayerCornerRadius:4.0];
    [self.finishButton setTitle:@"发布" forState:UIControlStateNormal];
    self.finishButton.frame = TYSetRect(margin, imageY + margin + _imageViewW, TYGetUIScreenWidth - 2*margin, 40);
    [self.finishButton addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                         
    [self.view addSubview:self.finishButton];
    
    //设置拍照的点击
    _sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
}

- (void)finishBtnClick:(UIButton *)sender{
    if (self.addImageViewArray.count == 0 || self.addImageViewArray == nil) {
        [TYShowMessage showPlaint:@"请添加照片"];
    }
    
    NSMutableArray *imageArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.addImageViewArray enumerateObjectsUsingBlock:^(JLGAddImageView *obj, NSUInteger idx, BOOL * stop) {
        //最后一个图片不上传，因为没有添加
        if (idx == weakSelf.addImageViewArray.count - 1) {
            return ;
        }
        
        //如果之前获取了图片，也不添加
        if ((idx < weakSelf.beforeImageNum)&& weakSelf.beforeImageNum!=0 ) {
            return ;
        }
        
        [imageArray addObject:obj.addImage];
    }];
    
    [TYLoadingHub showLoadingWithMessage:@"切换身份中..."];
    [JLGHttpRequest_AFN uploadImagesWithApi:@"jlwork/showskill" parameters:self.dataDic imagearray:imageArray success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"晒手艺成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showError:@"晒手艺失败"];
    }];
}

#pragma mark - JLGAddImageView
-(void)addImageButtonIndex:(NSInteger )imageIndex{
    if (_totalImageIndex == 9) {
        [TYShowMessage showPlaint:@"最多可以上传9张图片"];
        return ;
    }
    _imageIndex = imageIndex;
    [_sheet showInView:self.view];
}

#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    
    if(buttonIndex == 0){//照相
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{//相册
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //显示图片选择器
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    //显示图片并更新
    JLGAddImageView *jlgAddImageView = self.addImageViewArray[_imageIndex];
    jlgAddImageView.addImage = image;
    [self.addImageViewArray replaceObjectAtIndex:_imageIndex withObject:jlgAddImageView];
    
    //隐藏当前的模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //如果是点击原来的，就不添加
    if (_imageIndex < _totalImageIndex) {
        return ;
    }
    
    [self addImagesWithFinishButton];
}

- (void)addImagesNoFinishButton{
    [self addImagesWithIsAddFinishButton:NO];
}

- (void)addImagesWithFinishButton{
    TYLog(@"_imageIndex = %@",@(_imageIndex));
    [self addImagesWithIsAddFinishButton:YES];
}

//添加图片,isAddFinishButton是否添加finishButton
- (void)addImagesWithIsAddFinishButton:(BOOL )isAddFinishButton{
    //添加新的addImage
    CGFloat imageViewY = minY + margin + (margin + _imageViewW)*(++_totalImageIndex/3);
    imageViewY -= TYiOS8Later?44:0;
    CGRect frame = TYSetRect(0, imageViewY, _imageViewW, _imageViewW);
    if (_totalImageIndex%3 == 0) {
        frame.origin.x = margin;
    }else{
        frame.origin.x = (margin + _imageViewW)*(_totalImageIndex%3) + margin;
    }
    
    [self addAddImageViewWithTag:_totalImageIndex frame:frame];
    
    if (isAddFinishButton) {
        //修改发布按钮的frame
        CGRect finishButtonFrame = self.finishButton.frame;
        finishButtonFrame.origin = CGPointMake(margin, imageViewY + margin + _imageViewW);
        self.finishButton.frame = finishButtonFrame;
    }
}

- (void)addAddImageViewWithTag:(NSInteger )tag frame:(CGRect )frame{
    JLGAddImageView *jlgAddImageView = [[JLGAddImageView alloc] initWithFrame:frame];
    jlgAddImageView.tag = tag;
    jlgAddImageView.delegate = self;
    
    [self.view addSubview:jlgAddImageView];
    [self.addImageViewArray insertObject:jlgAddImageView atIndex:tag];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

@end
