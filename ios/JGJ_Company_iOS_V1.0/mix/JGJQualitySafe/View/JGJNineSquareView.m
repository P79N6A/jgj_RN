//
//  JGJNineSquareView.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNineSquareView.h"

#import "UIView+GNUtil.h"

#import "UIImageView+WebCache.h"

#import "NSString+Extend.h"

#import "UIButton+WebCache.h"

//#define ImgMargin 5
//
//#define AvatarViewW 80
//
//#define AvatarViewH 80

@interface JGJNineSquareView ()

@property (nonatomic, assign) CGFloat squareViewRow;

@property (nonatomic, assign) CGFloat headViewWH;

@property (nonatomic, assign) CGFloat headViewMargin;

@end

@implementation JGJNineSquareView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setNineSquareView];
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setNineSquareView];
    }
    
    return self;

}

- (void)setNineSquareView{
    
    for (NSInteger indx = 0; indx < 9; indx++) {
        
        UIButton *headBtn = [UIButton new];
        
        headBtn.tag = 100 + indx;
        
        [self addSubview:headBtn];
    }
    
}

- (void)imageCountLoadHeaderImageView:(NSArray *)images headViewWH:(CGFloat) headViewWH headViewMargin:(CGFloat) headViewMargin {
    
    CGFloat headerImageHW = headViewWH;
    
    
    self.imageViews = [NSMutableArray new];
    
    self.headViewWH = headViewWH;
    
    self.headViewMargin = headViewMargin;
    
    for (UIButton *headBtn in self.subviews) {
        
        NSInteger index = headBtn.tag - 100;
        
        headBtn.hidden = YES;
        
        if (headBtn.tag >= 100 && index < images.count) {
            
            NSString *imageStr = images[index];
            
            NSInteger row = index / 3;
            
            NSInteger col = index % 3;
            
            headBtn.tag = 100 + index;
            
            headBtn.x = (headerImageHW + headViewMargin) * col + headViewMargin;
            
            headBtn.y = (headerImageHW + headViewMargin) * row + headViewMargin;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            [self.imageViews addObject:headBtn.imageView];
            
            if (![NSString isEmpty:imageStr]) {
                
                NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/",JLGHttpRequest_UpLoadPicUrl_center_image, @"media/simages/m", imageStr]];
                
                [headBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
                headBtn.hidden = NO;
                
            }else {
                
                headBtn.hidden = YES;
                
            }
            
            
        }
        
    }

}

+ (CGFloat)nineSquareViewHeight:(NSArray *)images headViewWH:(CGFloat) headViewWH headViewMargin:(CGFloat) headViewMargins; {
    
    CGFloat height = 0;
    
    NSInteger row = images.count / 3 + (images.count % 3 > 0 ? 1 : 0);
    
    if (row > 0) {
        
        height = row * headViewWH + (row + 1) * headViewMargins;
        
    }
    
    return height;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self nineSquareLayout];
}

- (void)nineSquareLayout {

    CGFloat headBtnHW = self.headViewWH;
    
    CGFloat imgMargin = self.headViewMargin;
    
    for (UIButton *headBtn in self.subviews) {
        
        if ([headBtn isKindOfClass:[UIButton class]]) {
            
            NSInteger indx = headBtn.tag - 100;
            
            NSInteger row = indx / 3;
            
            NSInteger col = indx % 3;
            
            headBtn.tag = 100 + indx;
            
            headBtn.x = (headBtnHW + imgMargin) * col + imgMargin;
            
            headBtn.y = (headBtnHW + imgMargin) * row + imgMargin;
            
            [headBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            headBtn.width = headBtnHW;
            
            headBtn.height = headBtnHW;
            
            [self addSubview:headBtn];
            
        }
        
    }

}

#pragma mark - 按钮按下
- (void)buttonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(nineSquareView:squareImages:didSelectedIndex:)]) {
        
        [self.delegate nineSquareView:self squareImages:self.imageViews didSelectedIndex:sender.tag - 100];
    }
}

@end
