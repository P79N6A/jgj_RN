//
//  TYMoreButton.m
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYMoreButton.h"

/**
 *  定义宏：按钮中文本和图片的间隔
 */
#define TYPadding 10
#define TYBtnRadio 0.6

//    获得按钮的大小
#define TYBtnWidth self.bounds.size.width
#define TYBtnHeight self.bounds.size.height

//    获得按钮中UILabel文本的大小
#define TYLabelWidth self.titleLabel.bounds.size.width
#define TYLabelHeight self.titleLabel.bounds.size.height

//    获得按钮中image图标的大小
#define TYImageWidth self.imageView.bounds.size.width
#define TYImageHeight self.imageView.bounds.size.height

@implementation TYMoreButton


+ (instancetype)TYShareButton{
    return [[self alloc] initWithAlignmentStatus:TYAlignmentStatuDefault];
}

+ (instancetype)TYShareButtonStatus:(TYAlignmentStatus )status{
    return [[self alloc] initWithAlignmentStatus:status];
}

- (instancetype)initWithAlignmentStatus:(TYAlignmentStatus)status{
    TYMoreButton *ty_button = [[TYMoreButton alloc] init];
    ty_button.status = status;
    return ty_button;
}

- (void)setStatus:(TYAlignmentStatus)status{
    _status = status;
}

#pragma mark - 左对齐
- (void)alignmentLeft{
    //    获得按钮的文本的frame
    //    获得按钮的图片的frame
    CGRect imageFrame = self.imageView.frame;
    
    //    设置按钮的图片的x坐标紧跟文本的后面
    imageFrame.origin.x = TYPadding;
    
    //    获得按钮的文本的frame
    CGRect titleFrame = self.titleLabel.frame;
    
    //    设置按钮的文本的x坐标为0-－－左对齐
    titleFrame.origin.x =  2*TYPadding + CGRectGetWidth(imageFrame);
    

    //    重写赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}

#pragma mark - 右对齐
- (void)alignmentRight{
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = self.bounds.size.width - TYImageWidth - TYPadding;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = imageFrame.origin.x - frame.size.width - 2*TYPadding;
    //    重写赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}

#pragma mark - 居中对齐
- (void)alignmentCenter{
    //    设置文本的坐标
    CGFloat labelX = (TYBtnWidth - TYLabelWidth - TYImageWidth - TYPadding) * 0.5;
    CGFloat labelY = (TYBtnHeight - TYLabelHeight) * 0.5;
    
    //    设置label的frame
    self.titleLabel.frame = CGRectMake(labelX, labelY, TYLabelWidth, TYLabelHeight);
    
    //    设置图片的坐标
    CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame) + TYPadding;
    CGFloat imageY = (TYBtnHeight - TYImageHeight) * 0.5;
    //    设置图片的frame
    self.imageView.frame = CGRectMake(imageX, imageY, TYImageWidth, TYImageHeight);
}

#pragma mark - 图标在上，文本在下(居中)
- (void)alignmentTop{
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGFloat imageX = (TYBtnWidth - TYImageWidth) * 0.5;
    self.imageView.frame = CGRectMake(imageX, TYBtnHeight * 0.5 - TYImageHeight * TYButtonTopRadio, TYImageWidth, TYImageHeight);
    self.titleLabel.frame = CGRectMake((self.center.x - frame.size.width) * 0.5, TYBtnHeight * 0.5 + TYLabelHeight * TYButtonTopRadio, TYImageWidth, TYLabelHeight);
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}

#pragma mark - 图标在下，文本在上(居中)
- (void)alignmentBottom{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGFloat imageX = (TYBtnWidth - TYImageWidth) * 0.5;
    self.titleLabel.frame = CGRectMake((self.center.x - frame.size.width) * 0.5, TYBtnHeight * 0.5 - TYLabelHeight * (1 + TYButtonBottomRadio), TYLabelWidth, TYLabelHeight);
    self.imageView.frame = CGRectMake(imageX, TYBtnHeight * 0.5 , TYImageWidth, TYImageHeight);
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    // 判断
    if (_status == TYAlignmentStatuDefault || _status == TYAlignmentStatusTop) {
        [self alignmentTop];
    }
    else if (_status == TYAlignmentStatusLeft){
        [self alignmentLeft];
    }
    else if (_status == TYAlignmentStatusCenter){
        [self alignmentCenter];
    }
    else if (_status == TYAlignmentStatusRight){
        [self alignmentRight];
    }
    else if (_status == TYAlignmentStatusBottom){
        [self alignmentBottom];
    }
}
@end
