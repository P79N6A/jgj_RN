//
//  JGJChatBootomButton.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatBootomButton.h"

#define TYPadding 5

//    获得按钮的大小
#define TYBtnWidth self.bounds.size.width
#define TYBtnHeight self.bounds.size.height

//    获得按钮中UILabel文本的大小
#define TYLabelWidth self.titleLabel.bounds.size.width
#define TYLabelHeight self.titleLabel.bounds.size.height

//    获得按钮中image图标的大小
#define TYImageWidth self.imageView.bounds.size.width
#define TYImageHeight self.imageView.bounds.size.height

@implementation JGJChatBootomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit{
    [self setTitleColor:TYColorHex(0x666666) forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"Chat_add"] forState:UIControlStateNormal];

    self.contentMode = UIViewContentModeCenter;
    self.backgroundColor = TYColorHex(0xefefef);
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:10.0];
}

/**
 *  布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];

    //    设置图片的坐标
    CGFloat imageX = (TYBtnWidth - TYLabelWidth - TYImageWidth - TYPadding) * 0.5;
    CGFloat imageY = (TYBtnHeight - TYImageHeight) * 0.5;
    
    //    设置图片的frame
    self.imageView.frame = CGRectMake(imageX, imageY, TYGetViewW(self.imageView), TYGetViewH(self.imageView));
    
    //    设置文本的坐标
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + TYPadding;
    CGFloat labelY = (TYBtnHeight - TYLabelHeight) * 0.5;
    
    //    设置label的frame
    self.titleLabel.frame = CGRectMake(labelX, labelY, TYLabelWidth, TYLabelHeight);
    
    //    设置圆角
//    [self.layer setLayerCornerRadiusWithRatio:0.5];2.1.0-yj
    [self.layer setLayerCornerRadius:self.frame.size.height / 2.0];
}

- (void)titleStr:(NSString *)titleStr img:(UIImage *)img{
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateNormal];
}

@end
