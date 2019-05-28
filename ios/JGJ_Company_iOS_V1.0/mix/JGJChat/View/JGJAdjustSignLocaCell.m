//
//  JGJAdjustSignLocaCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAdjustSignLocaCell.h"

#import "NSString+Extend.h"

#define preW TYGetUIScreenWidth - 42

@interface JGJAdjustSignLocaCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@property (weak, nonatomic) IBOutlet UIButton *selButton;



@end

@implementation JGJAdjustSignLocaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.addressLable.textColor = AppFont999999Color;
    
    self.nameLable.preferredMaxLayoutWidth = preW;
    
    self.addressLable.preferredMaxLayoutWidth = preW;
}

- (void)setAddSignModel:(JGJAddSignModel *)addSignModel {

    _addSignModel = addSignModel;
    
    self.nameLable.text = _addSignModel.sign_addr2;
    
    self.addressLable.text = _addSignModel.sign_addr;
    
    self.selButton.selected = _addSignModel.isSelected;
    
    CGFloat nameHeight = [NSString stringWithContentWidth:preW content:_addSignModel.sign_addr font:AppFont24Size];
    
    CGFloat detailHeight = [NSString stringWithContentWidth:preW content:_addSignModel.sign_addr2 font:AppFont24Size];
    
    addSignModel.cellHeight = nameHeight + detailHeight + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
