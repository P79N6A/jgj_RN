//
//  JGJChatBootomTeamButton.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatBootomTeamButton.h"

#define TYPadding 5

@implementation JGJChatBootomTeamButton

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


    self.contentMode = UIViewContentModeCenter;
    self.backgroundColor = TYColorHex(0xefefef);
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = AppFontfafafaColor;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];

    //    设置图片的坐标
    CGFloat imageWH = self.bounds.size.height*0.6;
    CGFloat imageX = (self.bounds.size.width - imageWH)/2.0;
    CGFloat imageY = self.bounds.size.height*0.1;
    
    //    设置图片的frame
    self.imageView.frame = CGRectMake(imageX, imageY, imageWH, imageWH);
    

    //    设置文本的坐标
    CGFloat labelX = 0;
    CGFloat labelY = imageY + imageWH + self.bounds.size.height*0.05;
    
    CGFloat labelW = self.bounds.size.width;
    CGFloat labelH = self.bounds.size.height - labelY;
    
    //    设置label的frame
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)titleStr:(NSString *)titleStr img:(UIImage *)img{
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateNormal];
}
@end
