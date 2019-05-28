//
//  JGJChoiceproTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJChoiceproTableViewCell.h"
#import "UILabel+GNUtil.h"
@implementation JGJChoiceproTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected) {
        _imageview.hidden = NO;
    }else{
        _imageview.hidden = YES;
    }
}

-(void)setMyRelationshipProModel:(JGJMyRelationshipProModel *)MyRelationshipProModel
{
//    NSString *numStr = [NSString stringWithFormat:@"(%@)",MyRelationshipProModel.group_id?:@""];
    _proLable.text = MyRelationshipProModel.group_name ;
//    [_proLable markText:numStr withColor:AppFont999999Color];
    if ([MyRelationshipProModel.is_closed intValue]) {
        
        _closeLable.hidden = NO;
    }

}
@end
