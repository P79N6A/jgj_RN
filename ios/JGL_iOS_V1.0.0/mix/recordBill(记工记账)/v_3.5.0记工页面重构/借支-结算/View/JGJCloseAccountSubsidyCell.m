//
//  JGJCloseAccountSubsidyCell.m
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCloseAccountSubsidyCell.h"

@interface JGJCloseAccountSubsidyCell ()

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) UILabel *detailLabel;// 详情标签
@property (nonatomic, strong) UIImageView *arrowImage;// 箭头图片
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation JGJCloseAccountSubsidyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.typeImage];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.arrowImage];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
}


- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    if (![NSString isEmpty:_yzgGetBillModel.totalCalculation]) {
        
        _detailLabel.text = _yzgGetBillModel.totalCalculation;
        
    }else {
        
        _detailLabel.text = @"";
    }
    
    if (_is_unfold_subsidyCell) {
        
        _arrowImage.image = IMAGE(@"new_arrow_up");
        
    }else {
        
        _arrowImage.image = IMAGE(@"arrow_down");
        
    }
    
}

- (void)setUpLayout {
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(19);
        make.width.height.mas_equalTo(18);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.equalTo(_typeImage.mas_right).offset(13);
        make.height.mas_equalTo(15);
    }];
    
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-19);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(8);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(2.5);
        make.bottom.mas_offset(-2.5);
        make.left.equalTo(_typeLabel.mas_right).offset(20);
        make.right.equalTo(_arrowImage.mas_left).offset(-7);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(19);
        make.bottom.mas_equalTo(0);
        make.right.mas_offset(-19);
        make.height.mas_equalTo(1);
    }];
}

- (UIImageView *)typeImage {
    
    if (!_typeImage) {
        
        _typeImage = [[UIImageView alloc] init];
        _typeImage.image = IMAGE(@"fine");
        
    }
    return _typeImage;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = AppFont333333Color;
        _typeLabel.font = FONT(AppFont30Size);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.text = @"补贴、奖励、罚款";
    }
    return _typeLabel;
}


- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = AppFont333333Color;
        _detailLabel.font = FONT(AppFont26Size);
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

- (UIImageView *)arrowImage {
    
    if (!_arrowImage) {
        
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage.image = IMAGE(@"new_arrow_up");
        _arrowImage.contentMode = UIViewContentModeRight;

    }
    return _arrowImage;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}
@end
