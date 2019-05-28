//
//  JGJSynRecordCell.m
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynRecordCell.h"

#import "UILabel+GNUtil.h"

@interface JGJSynRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end

@implementation JGJSynRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.cancelButton.layer setLayerBorderWithColor:AppFont333333Color width:0.5 radius:3];
    
    [self.cancelButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:AppFont22Size];
    
    self.proNameLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.proNameLable.textColor = AppFont333333Color;

    
}

- (void)setProListModel:(JGJSynedProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    NSString *synType = [NSString stringWithFormat:@"(%@)", proListModel.sync_type];
    
    self.proNameLable.text = [NSString stringWithFormat:@"%@ %@", proListModel.pro_name, synType];
    
    if (![NSString isEmpty:proListModel.sync_type]) {
        
        [self.proNameLable markMoreText:synType withColor:AppFont999999Color];
        
    }
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(synRecordCellCancelButtonPressedWithCell:)]) {
        
        [self.delegate synRecordCellCancelButtonPressedWithCell:self];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
