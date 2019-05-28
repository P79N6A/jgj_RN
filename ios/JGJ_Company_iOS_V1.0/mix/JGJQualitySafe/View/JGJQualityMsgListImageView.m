//
//  JGJQualityMsgListImageView.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityMsgListImageView.h"

#import "UIImageView+WebCache.h"

@interface JGJQualityMsgListImageView ()

@property (nonatomic, strong) NSMutableArray *thumbnails;

@end

@implementation JGJQualityMsgListImageView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self initialQualityImageViews];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        
    }
    
    return self;
    
}

- (void)qualityMsgListImageViews:(NSArray *)imageViews {

    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = NO;
        if (imageViews.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = imageViews[index];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_Public stringByAppendingString:thumbnailsurl]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < imageViews.count){
            
            thumbnailsurl = imageViews[index];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_Public stringByAppendingString:thumbnailsurl]] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
        }else {
            
            imageView.hidden = YES;
        }
        
    }
    
}

- (void)initialQualityImageViews {

    CGFloat padding = 10;
    CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 30) / 4.0;
    NSMutableArray *thumbnails = [NSMutableArray new];
    self.thumbnails = thumbnails;
    for (NSInteger indx = 0; indx < 4; indx ++) {
        
        UIImageView *thumbnailImageView = [[UIImageView new] init];
        
        thumbnailImageView.tag = 100 + indx;
        
        thumbnailImageView.backgroundColor = [UIColor orangeColor];
        
        [thumbnails addObject:thumbnailImageView];
        
        [self addSubview:thumbnailImageView];
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:10 tailSpacing:10];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_bottom).mas_offset(10);
        
        make.width.mas_equalTo(thumbnailImageViewWH);
        
        make.bottom.equalTo(self.mas_bottom).mas_offset(-10);
    }];
}

@end
