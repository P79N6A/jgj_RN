//
//  JGJQuaSafeCheckItemCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckItemCell.h"

@interface JGJQuaSafeCheckItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemLable;
@property (weak, nonatomic) IBOutlet UIButton *selButton;

@end

@implementation JGJQuaSafeCheckItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.itemLable.textColor = AppFont333333Color;
}

- (void)setInfoModel:(JGJQuaSafePubCheckInfoModel *)infoModel {

    _infoModel = infoModel;
    
    self.itemLable.text = _infoModel.text;
    
    self.selButton.selected = _infoModel.isSelected;
    
    self.itemLable.text = [NSString stringWithFormat:@"%@ (%@)", _infoModel.text, _infoModel.child_num];
    
    self.selButton.hidden = [_infoModel.child_num isEqualToString:@"0"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
