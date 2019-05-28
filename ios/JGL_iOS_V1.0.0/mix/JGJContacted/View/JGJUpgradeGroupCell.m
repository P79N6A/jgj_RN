//
//  JGJUpgradeGroupCell.m
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUpgradeGroupCell.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
@interface JGJUpgradeGroupCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *nameTF;
@end

@implementation JGJUpgradeGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameTF.maxLength = ProNameLength;
    self.nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    __weak typeof(self) weakself = self;
    self.nameTF.valueDidChange = ^(NSString *value){
        [weakself handleNameTFValueChange];
    };
}

+ (CGFloat)upgradeGroupCellHeight {
    return 45.0;
}

- (void)setUpgradeGroupModel:(JGJCreatTeamModel *)upgradeGroupModel {
    _upgradeGroupModel = upgradeGroupModel;
    self.titleLable.text = _upgradeGroupModel.title;
    if (![NSString isEmpty:_upgradeGroupModel.detailTitle]) {
        self.nameTF.text = _upgradeGroupModel.detailTitle;
        [self handleNameTFValueChange];
    }else {
        self.nameTF.placeholder = _upgradeGroupModel.placeholderTitle;
    }
}

- (void)handleNameTFValueChange {
    if (!self.upgradeGroupModel) {
        self.upgradeGroupModel = [JGJCreatTeamModel new];
    }
    if (self.upgradeGroupModel.indexPath.row == 0) {
        self.upgradeGroupModel.pro_name = self.nameTF.text;
    }
    if (self.upgradeGroupModel.indexPath.row == 1) {
        self.upgradeGroupModel.group_name = self.nameTF.text;
    }
    if ([self.delegate respondsToSelector:@selector(upgradeGroupCell:upgradeGroupModel:)]) {
        [self.delegate upgradeGroupCell:self upgradeGroupModel:self.upgradeGroupModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
