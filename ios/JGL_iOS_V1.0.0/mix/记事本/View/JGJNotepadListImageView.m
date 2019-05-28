//
//  JGJNotepadListImageView.m
//  mix
//
//  Created by Tony on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotepadListImageView.h"
#import "UIImageView+WebCache.h"
@interface JGJNotepadListImageView ()


@end

@implementation JGJNotepadListImageView


- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    CGFloat imageWidth = (TYGetUIScreenWidth - 70) / 4;
    CGFloat imageHeight = (TYGetUIScreenWidth - 70) / 4;
    
    NSInteger index = 0;
    if (_images.count <= 4) {
        
        index = _images.count;
        
    }else {
        
        index = 4;
    }
    for (int i = 0; i < index; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageWidth+ 10) * i, 0, imageWidth, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,_images[i]]] placeholderImage:IMAGE(@"defaultPic")];
        [self addSubview:imageView];
        
    }
    
    UIImageView *lastImageView = self.subviews.lastObject;
    // 加蒙层
    if (_images.count > 4) {
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
        countLabel.font = FONT(16);
        countLabel.textColor = [UIColor whiteColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        countLabel.text = [NSString stringWithFormat:@"+%ld",_images.count - 4];
        
        [lastImageView addSubview:countLabel];
    }
}
@end
