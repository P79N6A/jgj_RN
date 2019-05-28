//
//  JGJChangeNewlyIncreasedListCell.m
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChangeNewlyIncreasedListCell.h"
@interface JGJChangeNewlyIncreasedListCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *newlyIncreasedLabel;
@property (nonatomic, strong) UIImageView *moreImg;
@property (nonatomic, strong) UIView *line;

@end
@implementation JGJChangeNewlyIncreasedListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.newlyIncreasedLabel];
    [self.contentView addSubview:self.moreImg];
    [self.contentView addSubview:self.line];
    [self setUpLayout];
    
}

- (void)setUpLayout {
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.height.mas_equalTo(15);
        make.top.mas_equalTo(8);
    }];
    
    [_newlyIncreasedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.height.mas_equalTo(15);
        make.top.equalTo(_timeLabel.mas_bottom).offset(8);
    }];
    
    [_moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(14);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(-1);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
}

- (void)setAddInfoModel:(JGJAdd_infoChangeModel *)addInfoModel {
    
    _addInfoModel = addInfoModel;
    _timeLabel.text = [NSString stringWithFormat:@"%@(%@)",_addInfoModel.date,_addInfoModel.nl_date];
    _newlyIncreasedLabel.text = [NSString stringWithFormat:@"新增记工记账%@笔",_addInfoModel.num];
    
    _line.hidden = _hiddenLine;
}

#pragma mark - property
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = AppFont666666Color;
        _timeLabel.font = FONT(AppFont26Size);
    }
    return _timeLabel;
}
- (UILabel *)newlyIncreasedLabel {
    
    if (!_newlyIncreasedLabel) {
        
        _newlyIncreasedLabel = [[UILabel alloc] init];
        _newlyIncreasedLabel.textColor = AppFont333333Color;
        _newlyIncreasedLabel.font = FONT(AppFont28Size);
        
    }
    return _newlyIncreasedLabel;
}

- (UIImageView *)moreImg {
    
    if (!_moreImg) {
        
        _moreImg = [[UIImageView alloc] init];
        _moreImg.image = IMAGE(@"arrow_right");
        _moreImg.contentMode = UIViewContentModeCenter;
    }
    return _moreImg;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}
@end
