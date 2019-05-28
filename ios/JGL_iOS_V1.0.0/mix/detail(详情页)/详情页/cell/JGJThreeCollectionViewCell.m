//
//  JGJThreeCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/1/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJThreeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation JGJThreeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUrl_str:(NSString *)Url_str
{

//    [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,Url_str]] placeholderImage:nil];
   // [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,Url_str]] placeholderImage:nil];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,Url_str]] placeholderImage:nil];

}
@end
