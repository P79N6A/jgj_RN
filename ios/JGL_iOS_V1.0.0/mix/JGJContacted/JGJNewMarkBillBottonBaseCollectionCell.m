//
//  JGJNewMarkBillBottonBaseCollectionCell.m
//  mix
//
//  Created by Tony on 2018/5/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNewMarkBillBottonBaseCollectionCell.h"
#import "NSString+Extend.h"
@interface JGJNewMarkBillBottonBaseCollectionCell ()

@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *typeName;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *detailLabel;// 未结工资
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UILabel *wait_confirm_Label;// 待确认对账数量

@property (nonatomic, strong) UIView *redPoint;// 红点
@end
@implementation JGJNewMarkBillBottonBaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.typeImage];
    [self addSubview:self.typeName];
    [self addSubview:self.rightLine];
    [self addSubview:self.detailLabel];
    [self addSubview:self.bottomLine];
    [self addSubview:self.wait_confirm_Label];
    [self addSubview:self.redPoint];
    [self setUpLayout];
    
    [_wait_confirm_Label updateLayout];
    _wait_confirm_Label.layer.cornerRadius = 9;
    _wait_confirm_Label.clipsToBounds = YES;
    
    [_redPoint updateLayout];
    _redPoint.layer.cornerRadius = 4;
    
}

- (void)setUpLayout {
    
    
    [_typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(_typeName.mas_top).offset(-14);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_typeImage.mas_right).offset(5);
        make.centerY.equalTo(_typeImage.mas_centerY).offset(-9);
        make.width.height.mas_equalTo(8);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(_typeName.mas_bottom).offset(4);
        make.height.mas_equalTo(12);
    }];
    
    [_wait_confirm_Label mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(_typeImage.mas_right).offset(5);
        make.centerY.equalTo(_typeImage.mas_centerY).offset(-10);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(18);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.top.bottom.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(0.5);
        
    }];
    
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(JGJRecordMonthBillModel *)model
{
    _model = model;
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",_model.b_total.pre_unit?:@"",_model.b_total.total?:@"0.00",_model.b_total.unit?:@""];
    if ([_typeName.text isEqualToString:@"工人管理"] || [_typeName.text isEqualToString:@"班组长"]) {

        self.detailLabel.text = JLGisLeaderBool ? @"管理及评价工人"  : @"管理及评价班组长";
    }
//上面的评价提示因为下面的布局重用问题有时没有显示上面文字yj
//    if ([_typeName.text isEqualToString:@"记工设置"]) {
//        
//        _detailLabel.text = @"";
//        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(0);
//        }];
//        
//
//    }else if ([_typeName.text isEqualToString:@"未结工资"]) {
//        
//        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.height.mas_equalTo(0);
//        }];
//    }
    
    if (_model.is_red_flag == 1) {
        
        if ([_typeName.text isEqualToString:@"同步记工"]) {
            
            // 设置红点
            _redPoint.hidden = NO;

        }else {
            
            _redPoint.hidden = YES;
        }
        
    }else {
        
        _redPoint.hidden = YES;
    }
    
    
    if (_model.confirm_off) {
        
        if ([_typeName.text isEqualToString:@"我要对账"]) {
            
            _wait_confirm_Label.hidden = YES;
            
        }else {
            
            _wait_confirm_Label.hidden = YES;
        }
        
    }else {
        
        if ([_typeName.text isEqualToString:@"我要对账"]) {
            
            if ([_typeName.text isEqualToString:@"我要对账"]) {
                
                _wait_confirm_Label.hidden = NO;
                if ([_wait_confirm_num isEqualToString:@"0"] || [NSString isEmpty:_wait_confirm_num]) {
                    
                    _wait_confirm_Label.hidden = YES;
                    
                }else {
                    
                    _wait_confirm_Label.text = _wait_confirm_num;
                    
                }
            }else {
                
                _wait_confirm_Label.hidden = YES;
            }
            
        }else {
            
            _wait_confirm_Label.hidden = YES;
        }
        
        
    }
}

- (void)setDicInfo:(NSDictionary *)dicInfo {
    
    _dicInfo = dicInfo;
    _typeImage.image = IMAGE(_dicInfo[@"image"]);
    _typeName.text = _dicInfo[@"title"];
    
    if ([_dicInfo[@"isShowDetail"] integerValue] == 1) {
        
        _detailLabel.hidden = NO;
        
        if ([_typeName.text isEqualToString:@"工人管理"] || [_typeName.text isEqualToString:@"班组长"]) {
            
            _detailLabel.textColor = AppFont666666Color;
            _detailLabel.font = FONT(12);
            
        }
        
    }else {
        
        _detailLabel.hidden = YES;
       
    }
    
    if (self.tag == 2) {
        
        [_rightLine mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
        }];
    }else {
        
        [_rightLine mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0.5);
        }];
    }
    
}

- (UIImageView *)typeImage {
    
    if (!_typeImage) {
        
        _typeImage = [[UIImageView alloc] init];
        _typeImage.contentMode = UIViewContentModeCenter;
    }
    return _typeImage;
}

- (UILabel *)typeName {
    
    if (!_typeName) {
        
        _typeName = [[UILabel alloc] init];
        _typeName.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _typeName.textColor = AppFont333333Color;
        _typeName.textAlignment = NSTextAlignmentCenter;
    }
    return _typeName;
}


- (UIView *)rightLine {
    
    if (!_rightLine) {
        
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _rightLine;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = FONT(AppFont24Size);
        _detailLabel.textColor = AppFont5BA0EDColor;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.hidden = YES;
        _detailLabel.text = @"";
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

- (UILabel *)wait_confirm_Label {
    
    if (!_wait_confirm_Label) {
        
        _wait_confirm_Label = [[UILabel alloc] init];
        _wait_confirm_Label.text = @"";
        _wait_confirm_Label.backgroundColor = AppFontFF0000Color;
        _wait_confirm_Label.textAlignment = NSTextAlignmentCenter;
        _wait_confirm_Label.textColor = AppFontffffffColor;
        _wait_confirm_Label.font = FONT(AppFont24Size);
        _wait_confirm_Label.hidden = YES;
    }
    return _wait_confirm_Label;
}

- (UIView *)redPoint {
    
    if (!_redPoint) {
        
        _redPoint = [[UIView alloc] init];
        _redPoint.backgroundColor = [UIColor redColor];
        _redPoint.clipsToBounds = YES;
        _redPoint.hidden = YES;
    }
    return _redPoint;
}
@end
