//
// LGPhotoPickerBrowserPhotoImageView.m
//  LGPhotoBrowser
//
//  Created by ligang on 15/10/27.
//  Copyright (c) 2015年 L&G. All rights reserved.

#import "LGPhotoPickerBrowserPhotoImageView.h"
#import "UIImage+TYALAssetsLib.h"

@interface LGPhotoPickerBrowserPhotoImageView ()
<
    UIActionSheetDelegate
>
@property (strong,nonatomic) UITapGestureRecognizer *scaleBigTap;
@end

@implementation LGPhotoPickerBrowserPhotoImageView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        // 监听手势
        [self addGesture];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
        // 监听手势
        [self addGesture];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        self.userInteractionEnabled = YES;
        // 监听手势
        [self addGesture];
	}
	return self;
}


#pragma mark -监听手势
- (void) addGesture{
    self.contentMode = UIViewContentModeScaleAspectFit;
    // 双击放大
    UITapGestureRecognizer *scaleBigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    scaleBigTap.numberOfTapsRequired = 2;
    scaleBigTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:_scaleBigTap = scaleBigTap];

    // 单击缩小
    UITapGestureRecognizer *disMissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    disMissTap.numberOfTapsRequired = 1;
    disMissTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:disMissTap];
    
    // 只能有一个手势存在
    [disMissTap requireGestureRecognizerToFail:scaleBigTap];
    
    //Tony修改过的地方
    //添加长按事件
    UILongPressGestureRecognizer *longPresssRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPresssRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPresssRecognizer];
}

//Tony修改过的地方
- (void)longPress:(UILongPressGestureRecognizer *)press {
    if (press.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"保存到相册"
                                                   otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        action.tag = 123456;
        
        [action showInView:self];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 123456 && buttonIndex == 0)
    {
        if (self.image)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [TYShowMessage showSuccess:@"保存成功"];
                
                NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                
                [self.image saveToAlbum:appName completionBlock:^{
//                    [TYShowMessage showSuccess:@"已保存到手机相册"];
                } failureBlock:^(NSError *error) {
                    [TYShowMessage showError:@"保存图片失败"];
                }];
            });
        }
    }
}

- (void)addScaleBigTap{
    [self.scaleBigTap addTarget:self action:@selector(handleDoubleTap:)];
}

- (void)removeScaleBigTap{
    [self.scaleBigTap removeTarget:self action:@selector(handleDoubleTap:)];
}

- (void)handleSingleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
		[_tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
		[_tapDelegate imageView:self doubleTapDetected:touch];
}

@end
