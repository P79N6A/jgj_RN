//
//  JGJContractorBillDetailTopTypeView.m
//  mix
//
//  Created by Tony on 2019/2/21.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJContractorBillDetailTopTypeView.h"

@interface JGJContractorBillDetailTopTypeView ()

@property (nonatomic, strong) UIImageView *contractorTypeImage;
@property (nonatomic, strong) UILabel *contractorTypeLabel;
@property (nonatomic, strong) UIButton *subcontractTypeBtn;// 分包
@property (nonatomic, strong) UILabel *explainInfoLabel;// 说明信息

@end
@implementation JGJContractorBillDetailTopTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.contractorTypeImage];
    [self addSubview:self.contractorTypeLabel];
    [self addSubview:self.subcontractTypeBtn];
    [self addSubview:self.explainInfoLabel];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_contractorTypeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(19);
        make.width.height.mas_equalTo(18);
    }];
    
    CGSize typeLabelSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 14) content:@"包工类型" font:15];
    
    [_contractorTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_contractorTypeImage.mas_centerY).offset(0);
        make.left.equalTo(_contractorTypeImage.mas_right).offset(14);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(typeLabelSize.width + 1);
    }];
    
    [_subcontractTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-19);
        make.centerY.equalTo(_contractorTypeImage.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(50);
    }];
    
    
    [_explainInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_subcontractTypeBtn.mas_right).offset(0);
        make.left.mas_equalTo(19);
        make.top.equalTo(_subcontractTypeBtn.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
    }];
}


- (void)setSubentryType:(NSInteger)subentryType {
    
    _subentryType = subentryType;
    if (_subentryType == 1) {
        
        [_subcontractTypeBtn setTitle:@"承包" forState:(UIControlStateNormal)];
        _explainInfoLabel.text = @"承包：从他人那里接来的工程自己做";
        
    }else if (_subentryType == 2) {
        
        [_subcontractTypeBtn setTitle:@"分包" forState:(UIControlStateNormal)];
        _explainInfoLabel.text = @"分包:自己做不完的工程，将一部分或者某项分给他人做";
    }
}

- (UIImageView *)contractorTypeImage {
    
    if (!_contractorTypeImage) {
        
        _contractorTypeImage = [[UIImageView alloc] init];
        _contractorTypeImage.image = IMAGE(@"contractorTypeImage");
    }
    return _contractorTypeImage;
}

- (UILabel *)contractorTypeLabel {
    
    if (!_contractorTypeLabel) {
        
        _contractorTypeLabel = [[UILabel alloc] init];
        _contractorTypeLabel.text = @"包工类型";
        _contractorTypeLabel.textColor = AppFont333333Color;
        _contractorTypeLabel.font = FONT(AppFont30Size);
    }
    return _contractorTypeLabel;
}

- (UIButton *)subcontractTypeBtn {
    
    if (!_subcontractTypeBtn) {
        
        _subcontractTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subcontractTypeBtn setTitle:@"分包" forState:(UIControlStateNormal)];
        [_subcontractTypeBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        [_subcontractTypeBtn setImage:IMAGE(@"contractTypeSelected") forState:(UIControlStateNormal)];
        _subcontractTypeBtn.titleLabel.font = FONT(AppFont28Size);
        _subcontractTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        
        
    }
    return _subcontractTypeBtn;
}

- (UILabel *)explainInfoLabel {
    
    if (!_explainInfoLabel) {
        
        _explainInfoLabel = [[UILabel alloc] init];
        _explainInfoLabel.text = @"承包：从他人那里接来的工程自己做";
        _explainInfoLabel.textAlignment = NSTextAlignmentRight;
        _explainInfoLabel.textColor = AppFontEB4E4EColor;
        _explainInfoLabel.font = FONT(AppFont24Size);
    }
    return _explainInfoLabel;
}

@end

