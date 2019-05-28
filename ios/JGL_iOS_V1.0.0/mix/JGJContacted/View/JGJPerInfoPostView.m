//
//  JGJPerInfoPostView.m
//  JGJCompany
//
//  Created by yj on 2017/8/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPerInfoPostView.h"

#import "UIImageView+WebCache.h"

@interface JGJPerInfoPostView ()

@property (nonatomic, strong) NSMutableArray *thumbnails;

@end

@implementation JGJPerInfoPostView

- (void)awakeFromNib {

    [super awakeFromNib];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{

    NSInteger col = TYIS_IPHONE_5 ? 3 : 4;
    
    CGFloat padding = 10;
    CGFloat thumbnailImageViewWH = 1.0 * (TYGetUIScreenWidth - 121 - padding * col) / col;
    
    NSMutableArray *thumbnails = [NSMutableArray new];
    
    self.thumbnails = thumbnails;
    
    for (NSInteger indx = 0; indx < col; indx ++) {
        
        UIImageView *thumbnailImageView = [[UIImageView new] init];
        
        thumbnailImageView.tag = 100 + indx;
        
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        
        [thumbnails addObject:thumbnailImageView];
        
        [self addSubview:thumbnailImageView];
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:10 tailSpacing:0];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(self.mas_top).mas_offset(0);
        
        make.centerY.equalTo(self.mas_centerY).mas_offset(0);
        
        make.width.height.mas_equalTo(thumbnailImageViewWH);
        
    }];
    
}

- (void)perInfoPostViewWithPics:(NSArray *)pics padding:(CGFloat)padding {

    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        
        imageView.hidden = NO;
        
        if (index >= pics.count) {
            
            imageView.hidden = YES;
            
        }else {
        
            thumbnailsurl = pics[index];
            
            NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,@"media/simages/m", thumbnailsurl];

            [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];

        }
        
    }

}


@end
