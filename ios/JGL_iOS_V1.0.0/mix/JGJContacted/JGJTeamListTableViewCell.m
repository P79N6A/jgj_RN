//
//  JGJTeamListTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTeamListTableViewCell.h"
#import "UILabel+GNUtil.h"

#import "UILabel+GNUtil.h"

@implementation JGJTeamListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectImageView.hidden = YES;
}
-(void)setDsec:(NSString *)dsec
{
    _leftLbale.text = dsec;
}
-(void)setModellist:(JgjRecordlistModel *)modellist
{
//    self.selectImageView.hidden = !modellist.isProSelected;

    NSString *proname;
    if (modellist.pro_name) {
        proname = modellist.pro_name;
    }
    self.leftLbale.text = [NSString stringWithFormat:@"%@%@%@%@",modellist.pro_name,@"(",modellist.members_num?:@"0",@"人)"];
    [self.leftLbale markText:[NSString stringWithFormat:@"(%@人)",modellist.members_num?:@""] withColor:AppFont999999Color];
    

    if (proname) {
        modellist.pro_name = proname;
    }
    
    if (modellist.members_head_pic.count > 0) {
        
//        [self.avatarView getRectImgView:modellist.members_head_pic];
    }
    
    if (![NSString isEmpty:self.searchValue]) {
        [self.leftLbale markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.leftLbale.font isGetAllText:YES];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
