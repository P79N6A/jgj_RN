//
//  JGJServiceProNTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJServiceProNTableViewCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@implementation JGJServiceProNTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _pronameLables.text = orderListModel.group_name;
    if ([NSString isEmpty:_pronameLables.text]) {
        _pronameLables.text = @"请选择服务项目";
        _pronameLables.textColor = AppFontccccccColor;
    }


}
-(void)setMyRelationshipProModel:(JGJMyRelationshipProModel *)MyRelationshipProModel
{
//    NSString *numStr = [NSString stringWithFormat:@"(%@)",MyRelationshipProModel.group_id?:@""];
    _pronameLables.text = MyRelationshipProModel.group_name;
//    [_pronameLables markText:numStr withColor:AppFont999999Color];
    if ([NSString isEmpty:_pronameLables.text]) {
        _pronameLables.text = @"请选择服务项目";
        _pronameLables.textColor = AppFontccccccColor;
    }

}

@end
