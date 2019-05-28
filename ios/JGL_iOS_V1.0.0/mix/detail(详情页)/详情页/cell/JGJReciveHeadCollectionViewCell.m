//
//  JGJReciveHeadCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/1/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJReciveHeadCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
@interface JGJReciveHeadCollectionViewCell ()

@end

@implementation JGJReciveHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
}
//-(void)setUrl_str:(NSString *)url_str
//{
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,url_str]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
//}

- (void)setDetailMemeberModel:(JGJSynBillingModel *)detailMemeberModel {
    
    _detailMemeberModel = detailMemeberModel;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:detailMemeberModel.head_pic memberName:detailMemeberModel.real_name memberPicBackColor:detailMemeberModel.modelBackGroundColor membertelephone:detailMemeberModel.telphone];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    if ([detailMemeberModel.uid isEqualToString:@"0"]) {
        
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"wait_task_member_icon"] forState:UIControlStateNormal];
        
    }


}

@end
