//
//  JGJRemarkAvatarView.m
//  mix
//
//  Created by yj on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRemarkAvatarView.h"

#import "UIButton+WebCache.h"

#import "JGJCheckPhotoTool.h"

#define AvatarMaxCount 8

#define ImgMargin 5 //四周间距

#define AvatarViewW (TYGetUIScreenWidth - 20 * 2 - ImgMargin * 3)

@interface JGJRemarkAvatarView ()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation JGJRemarkAvatarView

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
         [self setAvatarHeaderView];
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setAvatarHeaderView];
    }
    
    return self;
}

- (void)setAvatarHeaderView {
    
    //    TYLog(@"imageViewCount ==== %@",@(self.imageViewCount));
    
    CGFloat avatarViewW = AvatarViewW;
    
    CGFloat imageViewHW = AvatarViewW / 4.0;
    
    for (NSInteger indx = 0; indx < AvatarMaxCount; indx++) {
        
        NSInteger row = indx / 4;
        
        NSInteger col = indx % 4;
        
        UIButton *btn = [UIButton new];
        
        [btn addTarget:self action:@selector(checkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 100 + indx;
        
//        btn.backgroundColor = AppFontEB4E4EColor;
        
        btn.x = (imageViewHW + ImgMargin) * col;
        
        btn.y = (imageViewHW + ImgMargin) * row;
        
        btn.width = imageViewHW;
        
        btn.height = imageViewHW;
        
        [self addSubview:btn];
        
        self.frame = CGRectMake(0, 0, avatarViewW, TYGetMaxY(self));
        
        
    }
    
    if ([self.delegate respondsToSelector:@selector(remarkAvatarView:)]) {
        
        [self.delegate remarkAvatarView:self];
        
    }
    
}

- (void)checkBtnPressed:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    
    [JGJCheckPhotoTool browsePhotos:self.images selImageViews:self.imageViews didSelPhotoIndex:index];
    
}

- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    self.imageViews = [NSMutableArray array];
    
    for (NSInteger index = 0; index < AvatarMaxCount; index++) {
        
        UIButton *btn  = self.subviews[index];
        
        btn.hidden = YES;
        
        if (index < images.count && [btn isKindOfClass:[UIButton class]]) {
            
            [self.imageViews addObject:btn.imageView];
            
            btn.hidden = NO;
            
            NSString *thumbnailsurl = images[index];
            
            NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/",JLGHttpRequest_UpLoadPicUrl_center_image, @"media/simages/m", thumbnailsurl]];
            
            [btn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultPic"]];
            
        }else {
            
            btn.hidden = YES;
        }
    }
    
}

+(CGFloat)avatarViewHeightWithImageCount:(NSInteger)imagesCount {
    
    NSInteger row = imagesCount / 4;
    
    CGFloat imageViewHW = AvatarViewW / 4.0;
    
    NSInteger offsetRow = imagesCount % 4 == 0 ? 0 : 1;
    
    NSInteger totalRow = (imagesCount / 4 + offsetRow);
    
    CGFloat avtarViewheight = imagesCount == 0 ? imageViewHW : ((totalRow) * imageViewHW);
    
    CGFloat height = avtarViewheight + (totalRow - 1) * ImgMargin;
    
    if (imagesCount == 0) {
        
        height = 0;
        
    }
    
    return height;
}

@end
