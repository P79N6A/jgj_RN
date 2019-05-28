//
//  JGJChoiceSubentryTypeHeaderView.m
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChoiceSubentryTypeHeaderView.h"

@interface JGJChoiceSubentryTypeHeaderView ()

@property (nonatomic, strong) UIImageView *contractorTypeImage;
@property (nonatomic, strong) UILabel *contractorTypeLabel;
@property (nonatomic, strong) UIButton *contractTypeBtn;// 承包
@property (nonatomic, strong) UIButton *subcontractTypeBtn;// 分包
@property (nonatomic, strong) UILabel *explainInfoLabel;// 说明信息

@end
@implementation JGJChoiceSubentryTypeHeaderView

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
    [self addSubview:self.contractTypeBtn];
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
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(50);
    }];
    
    [_contractTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_subcontractTypeBtn.mas_left).offset(-58);
        make.centerY.equalTo(_contractorTypeImage.mas_centerY).offset(0);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(50);
    }];
    
    [_explainInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_subcontractTypeBtn.mas_right).offset(0);
        make.left.mas_equalTo(19);
        make.top.equalTo(_subcontractTypeBtn.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
    }];
}

// 选择承包
- (void)choiceContractType:(UIButton *)sender {
    
    if (!sender.selected) {
        
        _subcontractTypeBtn.selected = NO;
        _explainInfoLabel.text = @"承包：从他人那里接来的工程自己做";
        sender.selected = YES;
        
        if (self.choiceSubentryType) {
            
            _choiceSubentryType(0);
        }
    }
    
}

// 选择分包
- (void)choiceSubcontractType:(UIButton *)sender {
    
    if (!sender.selected) {
        
        _contractTypeBtn.selected = NO;
        _explainInfoLabel.text = @"分包:自己做不完的工程，将一部分或者某项分给他人做";
        sender.selected = YES;
        
        if (_choiceSubentryType) {
            
            _choiceSubentryType(1);
        }
    }
}

- (void)setSubentryType:(NSInteger)subentryType {

    _subentryType = subentryType;
    if (_subentryType == 0) {
        
        _contractTypeBtn.selected = YES;
        _subcontractTypeBtn.selected = NO;
        _explainInfoLabel.text = @"承包：从他人那里接来的工程自己做";
        
    }else if (_subentryType == 1) {
        
        _contractTypeBtn.selected = NO;
        _subcontractTypeBtn.selected = YES;
        _explainInfoLabel.text = @"分包:自己做不完的工程，将一部分或者某项分给他人做";
    }
}

- (void)setMarkBillMore:(BOOL)markBillMore {
    
    _markBillMore = markBillMore;
    if (_markBillMore) {
        
        _contractTypeBtn.hidden = YES;
        _subcontractTypeBtn.selected = YES;
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

- (UIButton *)contractTypeBtn {
    
    if (!_contractTypeBtn) {
        
        _contractTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contractTypeBtn setTitle:@"承包" forState:(UIControlStateNormal)];
        [_contractTypeBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        [_contractTypeBtn setImage:IMAGE(@"contractTypeUnSelected") forState:(UIControlStateNormal)];
        [_contractTypeBtn setImage:IMAGE(@"contractTypeSelected") forState:(UIControlStateSelected)];
        _contractTypeBtn.titleLabel.font = FONT(AppFont28Size);
        _contractTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
//        _contractTypeBtn.contentMode = UIViewContentModeCenter;
        [_contractTypeBtn addTarget:self action:@selector(choiceContractType:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _contractTypeBtn;
}

- (UIButton *)subcontractTypeBtn {
    
    if (!_subcontractTypeBtn) {
        
        _subcontractTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subcontractTypeBtn setTitle:@"分包" forState:(UIControlStateNormal)];
        [_subcontractTypeBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        [_subcontractTypeBtn setImage:IMAGE(@"contractTypeUnSelected") forState:(UIControlStateNormal)];
        [_subcontractTypeBtn setImage:IMAGE(@"contractTypeSelected") forState:(UIControlStateSelected)];
        _subcontractTypeBtn.titleLabel.font = FONT(AppFont28Size);
        _subcontractTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
//        _subcontractTypeBtn.contentMode = UIViewContentModeCenter;
        [_subcontractTypeBtn addTarget:self action:@selector(choiceSubcontractType:) forControlEvents:(UIControlEventTouchUpInside)];
        
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
