//
//  JGJDetailThumbnailCell.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDetailThumbnailCell.h"

#import "JGJNineSquareView.h"

#import "UIImageView+WebCache.h"

@interface JGJDetailThumbnailCell ()<JGJNineSquareViewDelegate>

@property (weak, nonatomic) IBOutlet JGJNineSquareView *thumbnilVIew;

@property (strong, nonatomic) UIImageView *singleImageView;

@end

@implementation JGJDetailThumbnailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumbnilVIew.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImageView)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.singleImageView addGestureRecognizer:tap];
    
    self.singleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.singleImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.singleImageView];
    
    self.singleImageView.userInteractionEnabled = YES;
}

- (void)setQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {
    
    _qualityDetailModel = qualityDetailModel;
    
    if (qualityDetailModel.msg_src.count == 1) {
        
        self.singleImageView.hidden = NO;
        
        self.singleImageView.frame = CGRectMake(10, 5, qualityDetailModel.imageW, qualityDetailModel.imageH);
        
        [self.singleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,qualityDetailModel.msg_src.firstObject]] placeholderImage:[UIImage imageNamed:@"defaultPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }else {
        
        self.singleImageView.hidden = YES;
        
        [self.thumbnilVIew imageCountLoadHeaderImageView:qualityDetailModel.msg_src headViewWH:80 headViewMargin:5];
    }
    
}

- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(detailThumbnailCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate detailThumbnailCell:self imageViews:squareImages didSelectedIndex:index];
    }
    
}

- (void)checkImageView {

    if ([self.delegate respondsToSelector:@selector(detailThumbnailCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate detailThumbnailCell:self imageViews:@[self.singleImageView] didSelectedIndex:0];
    }
}

- (UIImageView *)singleImageView {
    
    if (!_singleImageView) {
        
        _singleImageView = [UIImageView new];
        
        _singleImageView.hidden = YES;
    }
    
    return _singleImageView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
