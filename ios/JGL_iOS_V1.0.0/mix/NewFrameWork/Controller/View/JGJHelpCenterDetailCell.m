//
//  JGJHelpCenterDetailCell.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHelpCenterDetailCell.h"
#import "UILabel+GNUtil.h"
@interface JGJHelpCenterDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet JGJCustomLable *detailContentLable;
@end

@implementation JGJHelpCenterDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailContentLable.textColor = AppFont666666Color;
    self.detailTitle.textColor = AppFont333333Color;
    self.detailContentLable.font = [UIFont systemFontOfSize:AppFont32Size];
    self.detailTitle.font = [UIFont systemFontOfSize:AppFont36Size];
    [self.detailContentLable.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:2.5];
    self.detailContentLable.textInsets      = UIEdgeInsetsMake(5.f, 15.f, 0.f, 15.f); // 设置左内边距
}

- (void)setHelpCenterListModel:(JGJHelpCenterListModel *)helpCenterListModel {
    _helpCenterListModel = helpCenterListModel;
    self.detailTitle.text = helpCenterListModel.title;
    self.detailContentLable.text = helpCenterListModel.content;
    [self.detailContentLable setAttributedText:helpCenterListModel.content lineSapcing:3.0];
    self.detailContentLable.textAlignment = NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
