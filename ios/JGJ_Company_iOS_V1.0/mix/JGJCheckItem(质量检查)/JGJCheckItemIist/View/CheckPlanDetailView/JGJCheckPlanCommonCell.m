//
//  JGJCheckPlanCommonCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPlanCommonCell.h"

@implementation JGJCheckPlanCommonCellModel

@end

@interface JGJCheckPlanCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@end

@implementation JGJCheckPlanCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.detailLable.textColor = AppFont333333Color;
    
    self.detailLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.detailLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 69.5;
}

- (void)setCommonModel:(JGJCheckPlanCommonCellModel *)commonModel {
    
    _commonModel = commonModel;
    
    [self setUIFontWithCommonModel:commonModel];
    
    self.titleLable.text = commonModel.title;
    
    self.detailLable.text = commonModel.detailTitle;
}

- (void)setUIFontWithCommonModel:(JGJCheckPlanCommonCellModel *)commonModel {
    
    if (commonModel.titleFont > 0) {
        
        self.titleLable.font = [UIFont systemFontOfSize:commonModel.titleFont];
    }
    
    if (commonModel.detailFont > 0) {
        
        self.detailLable.font = [UIFont systemFontOfSize:commonModel.detailFont];
    }
    
    if (commonModel.titleColor) {
        
        self.titleLable.textColor = commonModel.titleColor;
    }
    
    if (commonModel.detailColor) {
        
        self.detailLable.textColor = commonModel.detailColor;
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (commonModel.contentViewBackColor) {
        
        self.contentView.backgroundColor = commonModel.contentViewBackColor;
    }
    
   CGFloat height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 69.5  content:commonModel.detailTitle font:AppFont30Size lineSpace:1];
    
    if (![NSString isEmpty:commonModel.detailTitle]) {
        
        if (height > 25) {
            
            self.detailLable.textAlignment = NSTextAlignmentLeft;
            
        }else {
            
            self.detailLable.textAlignment = NSTextAlignmentRight;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
