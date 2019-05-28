//
//  JGJImageCollectionViewCell.m
//  九宫格图片
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 test. All rights reserved.
//

#import "JGJLImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation JGJLImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUrlStr:(NSString *)urlStr
{

    [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,urlStr]]];

}
@end
