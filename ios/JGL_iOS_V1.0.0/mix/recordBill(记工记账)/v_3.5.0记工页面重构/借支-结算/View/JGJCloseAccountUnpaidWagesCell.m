//
//  JGJCloseAccountUnpaidWagesCell.m
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCloseAccountUnpaidWagesCell.h"

@interface JGJCloseAccountUnpaidWagesCell ()

@property (nonatomic, strong) UIImageView *typeImage;// 类型图标
@property (nonatomic, strong) UILabel *typeLabel;// 类型标签
@property (nonatomic, strong) UIButton *unpaidWagesExplainBtn;// 未结工资说明按钮
@property (nonatomic, strong) UILabel *detailLabel;// 详情标签
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation JGJCloseAccountUnpaidWagesCell

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
    [self.contentView addSubview:self.unpaidWagesExplainBtn];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    
}


- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    _detailLabel.text = self.yzgGetBillModel.balance_amount?:@"";

}


- (void)setUpLayout {
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(19);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat width = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"未结工资" font:15].width;
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.equalTo(_typeImage.mas_right).offset(13);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(ceil(width) + 1);
    }];
    
    [_unpaidWagesExplainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.left.equalTo(_typeLabel.mas_right).offset(8);
        make.height.width.mas_equalTo(15);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(2.5);
        make.bottom.mas_offset(-2.5);
        make.left.equalTo(_unpaidWagesExplainBtn.mas_right).offset(20);
        make.right.mas_offset(-34);
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
        _typeImage.image = IMAGE(@"openSalary");
    }
    return _typeImage;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = AppFont333333Color;
        _typeLabel.font = FONT(AppFont30Size);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.text = @"未结工资";
    }
    return _typeLabel;
}

- (UIButton *)unpaidWagesExplainBtn {
    
    if (!_unpaidWagesExplainBtn) {
        
        _unpaidWagesExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unpaidWagesExplainBtn setImage:IMAGE(@"bubble") forState:(UIControlStateNormal)];
    }
    return _unpaidWagesExplainBtn;
}


- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = AppFont333333Color;
        _detailLabel.font = FONT(AppFont26Size);
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
}
@end
