//
//  JGJSetAgentMonitorCell.m
//  mix
//
//  Created by Tony on 2018/7/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSetAgentMonitorCell.h"
#import "NSString+Extend.h"
@interface JGJSetAgentMonitorCell ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightRow;

@end
@implementation JGJSetAgentMonitorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightRow];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"设置代班长" font:AppFont30Size];
    _topLine.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(.5);
    _leftLabel.sd_layout.leftSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(size.width + 15).heightIs(15);
    _rightRow.sd_layout.rightSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(15).heightIs(15);
    _rightLabel.sd_layout.rightSpaceToView(_rightRow, 5).centerYEqualToView(self.contentView).heightIs(15).leftSpaceToView(_leftLabel, 5);
    _bottomLine.sd_layout.leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(.5);
    
}

- (void)setTitleArr:(NSMutableArray *)titleArr {
    
    _titleArr = titleArr;
    NSInteger section = self.tag / 10;
    NSInteger row = self.tag % 10;
    
    _leftLabel.text = _titleArr[section][row];
    
    if (section == 1 && row == 0) {
        
        _bottomLine.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15);
        
    }else {
        
        _bottomLine.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);
    }
    
    if (section == 1 && row == 1) {
        
        _topLine.hidden = YES;
        
    }else {
        
        _topLine.hidden = NO;
    }
}

- (void)setContentArr:(NSMutableArray *)contentArr {
    
    _contentArr = contentArr;
    NSInteger section = self.tag / 10;
    NSInteger row = self.tag % 10;
    _rightLabel.text = _contentArr[section][row];
    if (section == 1) {
        
        if (row == 0) {
            
            if ([_contentArr[section][row] length] == 0) {
                
                _rightLabel.text = @"请选择代班开始时间";
                _rightLabel.textColor = AppFont999999Color;
            }else {
                
                _rightLabel.textColor = AppFont333333Color;
            }
            
        }else {
            
            if ([_contentArr[section][row] length] == 0) {
                
                _rightLabel.text = @"请选择代班结束时间";
                _rightLabel.textColor = AppFont999999Color;
            }else {
                
                _rightLabel.textColor = AppFont333333Color;
            }
        }
    }
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

- (UILabel *)leftLabel {
    
    if (!_leftLabel) {
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = FONT(AppFont30Size);
        _leftLabel.textColor = AppFont333333Color;
    }
    return _leftLabel;
}

- (UIImageView *)rightRow {
    
    if (!_rightRow) {
        
        _rightRow = [[UIImageView alloc] init];
        _rightRow.image = IMAGE(@"arrow_right");
        _rightRow.contentMode = UIViewContentModeCenter;
    }
    return _rightRow;
}
- (UILabel *)rightLabel {
    
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = FONT(AppFont30Size);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = AppFont333333Color;
    }
    return _rightLabel;
}
@end
