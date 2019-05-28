//
//  JGJSetAgentExplainCell.m
//  mix
//
//  Created by Tony on 2018/7/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSetAgentExplainCell.h"
#import "YYText.h"
@interface JGJSetAgentExplainCell ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@end
@implementation JGJSetAgentExplainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.contentLabel];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _numberLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 7).heightIs(10).widthIs(23);
    _contentLabel.sd_layout.leftSpaceToView(_numberLabel, 0).rightSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).heightIs(0);
    
}

- (void)setContentArr:(NSArray *)contentArr {
    
    _contentArr = contentArr;
    NSInteger row = self.tag % 10;
    
    if (row == 2) {
        
        _contentLabel.sd_layout.heightIs(34);
    }else {
        
        _contentLabel.sd_layout.heightIs(16);
    }
    
    if (row == 0) {
        
        _numberLabel.hidden = YES;
        _numberLabel.sd_layout.widthIs(0);
        _contentLabel.text = _contentArr[0];
        _contentLabel.font = FONT(AppFont30Size);
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        att.yy_color = AppFont666666Color;
        att.yy_font = FONT(AppFont30Size);
        att.yy_lineSpacing = 5;
        _contentLabel.attributedText = att;
    }else {
        
        _numberLabel.hidden = NO;
        _numberLabel.sd_layout.widthIs(23);
        _numberLabel.text = [NSString stringWithFormat:@"%ld、",row];
        _contentLabel.text = _contentArr[row];
        _contentLabel.font = FONT(AppFont26Size);
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        att.yy_color = AppFont666666Color;
        att.yy_font = FONT(AppFont26Size);
        att.yy_lineSpacing = 5;
        _contentLabel.attributedText = att;
    }
    

}

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(AppFont26Size);
        _numberLabel.textColor = AppFont666666Color;
    }
    return _numberLabel;
}

- (YYLabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        
    }
    return _contentLabel;
}
@end
