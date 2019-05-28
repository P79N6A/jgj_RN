//
//  JGJRecordDetailmageLinTableViewCell.m
//  mix
//
//  Created by Tony on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordDetailmageLinTableViewCell.h"
@implementation JGJRecordDetailmageLinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setImageArr:(NSArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSArray array];
    }
    _imageArr = imageArr;
    JGJLinePhotoView *imageview = [[JGJLinePhotoView alloc]initWithFrame:CGRectMake(5, 0, TYGetUIScreenWidth - 90, CGRectGetHeight(self.frame) ) OlineandImageArr: _imageArr andSize:CGSizeMake(TYGetUIScreenWidth/375*(TYGetUIScreenWidth - 80), TYGetUIScreenWidth/375*(TYGetUIScreenWidth-80)) andDepart:5 andViewHeightblock:^(NSString *height) {

    }];
    
//    JGJLinePhotoView *imageview = [[JGJLinePhotoView alloc]initWithFrame:CGRectMake(0, 15, TYGetUIScreenWidth, CGRectGetHeight(self.frame) ) OlineandImageArr: _imageArr andSize:CGSizeMake(TYGetUIScreenWidth/375*(TYGetUIScreenWidth  - 20), TYGetUIScreenWidth/375*(TYGetUIScreenWidth  - 20)) andDepart:5 andViewHeightblock:^(NSString *height) {
//
//    }];
    imageview.delegate = self;
    
    [self.contentView addSubview:imageview];
}
-(void)tapCollectionViewPhotoWithTag:(NSInteger)currentindex andimgs:(NSMutableArray *)imageArrs
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapCollectionViewSectionAndTag:imagArrs:)]) {
        [self.delegate tapCollectionViewSectionAndTag:currentindex imagArrs:imageArrs];
    }
    
}
@end
