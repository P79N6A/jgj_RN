//
//  JGJSynToMyProListCell.m
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynToMyProListCell.h"

@interface JGJSynToMyProListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end

@implementation JGJSynToMyProListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.delButton.titleLabel.font = [UIFont systemFontOfSize:AppFont22Size];
    
    [self.delButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.nameLable.textColor = AppFont333333Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProListModel:(JGJSynedProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.nameLable.text = proListModel.pro_name;
    
}

- (void)setIsDelStatus:(BOOL)isDelStatus {
    
    _isDelStatus = isDelStatus;
    
    self.delButton.userInteractionEnabled = _isDelStatus;
    
    if (_isDelStatus) {
        
        [self.delButton setImage:nil forState:UIControlStateNormal];
        
        [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [self.delButton.layer setLayerBorderWithColor:AppFont333333Color width:0.5 radius:2.5];
        
        self.delButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
    }else {
        
        [self.delButton setTitle:nil forState:UIControlStateNormal];
        
        [self.delButton.layer setLayerBorderWithColor:[UIColor whiteColor] width:CGFLOAT_MIN radius:CGFLOAT_MIN];
        
        [self.delButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        
        self.delButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
    }
}

- (IBAction)delButtonPressed:(UIButton *)sender {
    
    if (self.synToMyProListCellBlock && _isDelStatus) {
        
        self.synToMyProListCellBlock(_proListModel);
    }
    
}

@end
