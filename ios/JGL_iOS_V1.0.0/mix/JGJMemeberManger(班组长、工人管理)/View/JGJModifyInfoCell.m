//
//  JGJModifyInfoCell.m
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJModifyInfoCell.h"

@implementation JGJModifyInfoModel



@end

@interface JGJModifyInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *inputText;

@end

@implementation JGJModifyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.textColor = AppFont333333Color;
    
    TYWeakSelf(self);
    
    self.inputText.valueDidChange = ^(NSString *value) {
      
        weakself.desModel.des = value;
    };
}

- (void)setDesModel:(JGJModifyInfoModel *)desModel {
    
    _desModel = desModel;
    
    self.inputText.placeholder = desModel.placeholder;

    if (!desModel.maxLength) {
     
        desModel.maxLength = 30;
    }

    self.inputText.maxLength = desModel.maxLength;
    
    self.titleLable.text = desModel.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
