//
//  JGJPepleInfoTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPepleInfoTableViewCell.h"

@implementation JGJPepleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setJlgGetBillModel:(YZGGetBillModel *)JlgGetBillModel
{
    _projectLable.text = _JlgGetBillModel.proname;
    if (!_JlgGetBillModel.phone_num) {
        _nameLable.text    = _JlgGetBillModel.name;
    }else{
        _nameLable.text = [_JlgGetBillModel.name stringByAppendingString:_JlgGetBillModel.phone_num];
    }



}

@end
