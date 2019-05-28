//
//  JGJCheckAccountModulesCell.m
//  mix
//
//  Created by yj on 2018/8/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckAccountModulesCell.h"

@interface JGJCheckAccountModulesCell()<JGJCheckAccountModulesViewDelegate>

@property (weak, nonatomic) IBOutlet JGJCheckAccountModulesView *modulesView;
@end

@implementation JGJCheckAccountModulesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.modulesView.layer setLayerCornerRadius:5];
    
    self.contentView.backgroundColor = AppFontEBEBEBColor;
}

- (void)checkAccountModulesView:(JGJCheckAccountModulesView *)modulesView JGJCheckAccountModulesButtontype:(JGJCheckAccountModulesButtontype)buttonType {
    
    if ([self.delegate respondsToSelector:@selector(checkAccountModulesCell:JGJCheckAccountModulesButtontype:)]) {
        
        [self.delegate checkAccountModulesCell:self JGJCheckAccountModulesButtontype:buttonType];
        
    }
    
}

+(CGFloat)checkAccountModulesCellHeight {
    
    return 275.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
