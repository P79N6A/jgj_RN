//
//  JGJSubentryListCell.m
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSubentryListCell.h"
#import "UILabel+GNUtil.h"
@interface JGJSubentryListCell ()

@property (nonatomic, strong) UILabel *subentryTemplateLabel;


@end
@implementation JGJSubentryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}
- (void)initializeAppearance {
    
    [self.contentView addSubview:self.subentryTemplateLabel];
    [self.contentView addSubview:self.line];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_subentryTemplateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(JGJSubentryListModel *)model {
    
    _model = model;
    _subentryTemplateLabel.text = [NSString stringWithFormat:@"%@ %@/%@",_model.sub_pro_name,_model.set_unitprice,_model.units];
    [_subentryTemplateLabel markattributedTextArray:@[_model.set_unitprice] color:AppFontEB4E4EColor];
}

- (UILabel *)subentryTemplateLabel {
    
    if (!_subentryTemplateLabel) {
        
        _subentryTemplateLabel = [[UILabel alloc] init];
        _subentryTemplateLabel.text = @"包柱子 200.00/平方米";
        _subentryTemplateLabel.font = FONT(AppFont28Size);
        _subentryTemplateLabel.textColor = AppFont333333Color;
        _subentryTemplateLabel.numberOfLines = 0;
        
    }
    return _subentryTemplateLabel;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}
@end
