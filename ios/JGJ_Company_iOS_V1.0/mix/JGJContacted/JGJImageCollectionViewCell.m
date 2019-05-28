//
//  JGJImageCollectionViewCell.m
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation JGJImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(JGJChatMsgListModel *)model
{
    _model = [[JGJChatMsgListModel alloc]init];
    _model = model;


}
-(void)setUrl_str:(NSString *)Url_str
{
    /*
    if (_model.msg_src) {
        if (_model.msg_src.count==1) {
            [_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,Url_str]]];
        }else{
            [_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,Url_str]] placeholderImage:nil];
            NSLog(@"url = %@",[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,Url_str]);
        }
    }
    */
    if (_Simageview) {
        [_Simageview removeFromSuperview];
        _Simageview = nil;
    }
    if (_model.msg_src) {
        if (_model.msg_src.count==1) {
            
            [_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,Url_str]]];
            _ImageView.clipsToBounds = YES;
            _ImageView.contentMode = UIViewContentModeScaleAspectFill;
            
        }else{

            _Simageview = [[JGJLinePhotoView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(self.frame) ) andImageArr: _model.msg_src andSize:CGSizeMake(250.00/375*TYGetUIScreenWidth, 250.00/375*TYGetUIScreenWidth) andDepart:5 andViewHeightblock:^(NSString *height) {
            }];
            _Simageview.delegate = self;
            [self.contentView addSubview:_Simageview];
        }
    }

    

}
-(void)tapCollectionViewPhotoWithTag:(NSInteger)currentindex andimgs:(NSMutableArray *)imageArrs
{
    //获取imageView子控件
    NSMutableArray *imageViews = [NSMutableArray array];
    
    for (UIView *nineView in self.contentView.subviews) {
        
        if ([nineView isKindOfClass:NSClassFromString(@"JGJLinePhotoView")]) {
            
            for (UIImageView *imageView in nineView.subviews) {
                
                if ([imageView isKindOfClass:[UIImageView class]]) {
                    
                    [imageViews addObject:imageView];
                }
            }
        }
        
    }
    
    //异常判断
    if (imageViews.count == 0) {
        
        imageViews = imageArrs;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapCollectionViewSectionAndTag: imagArrs:)]) {
        
        [self.delegate tapCollectionViewSectionAndTag:currentindex imagArrs:imageArrs];
        
    }
}

@end
