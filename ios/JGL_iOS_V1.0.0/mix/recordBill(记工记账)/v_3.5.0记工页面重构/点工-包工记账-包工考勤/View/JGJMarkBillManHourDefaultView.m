//
//  JGJMarkBillManHourDefaultView.m
//  mix
//
//  Created by ccclear on 2019/3/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMarkBillManHourDefaultView.h"

@interface JGJMarkBillManHourDefaultView ()

@property (nonatomic, strong) UILabel *resetLabel;
@property (nonatomic, strong) UILabel *halfHourLabel;
@property (nonatomic, strong) UILabel *oneHourLabel;

@end
@implementation JGJMarkBillManHourDefaultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
 
    [self addSubview:self.resetLabel];
    [self addSubview:self.halfHourLabel];
    [self addSubview:self.oneHourLabel];
    [self setUpLayout];
    [_resetLabel updateLayout];
    [_halfHourLabel updateLayout];
    [_oneHourLabel updateLayout];
    
    _resetLabel.layer.cornerRadius = 3;
    _halfHourLabel.layer.cornerRadius = 3;
    _oneHourLabel.layer.cornerRadius = 3;
}

- (void)setUpLayout {
    
//    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 28) content:@"一个工" font:14];
    [_oneHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
        make.centerY.mas_offset(0);
    }];
    
    [_halfHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_oneHourLabel.mas_left).offset(-8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
        make.centerY.mas_offset(0);
    }];
    [_resetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_halfHourLabel.mas_left).offset(-8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
        make.centerY.mas_offset(0);
    }];
}

- (UILabel *)resetLabel {
    
    if (!_resetLabel) {
        
        _resetLabel = [[UILabel alloc] init];
        _resetLabel.text = @"休息";
        _resetLabel.textAlignment = NSTextAlignmentCenter;
        _resetLabel.backgroundColor = AppFontEBEBEBColor;
        _resetLabel.layer.borderWidth = 1;
        _resetLabel.layer.borderColor = AppFontccccccColor.CGColor;
        _resetLabel.clipsToBounds = YES;
        _resetLabel.font = FONT(14);
        _resetLabel.textColor = AppFont000000Color;
    }
    return _resetLabel;
}

- (UILabel *)halfHourLabel {
    
    if (!_halfHourLabel) {
        
        _halfHourLabel = [[UILabel alloc] init];
        _halfHourLabel.text = @"半个工";
        _halfHourLabel.textAlignment = NSTextAlignmentCenter;
        _halfHourLabel.backgroundColor = AppFontEBEBEBColor;
        _halfHourLabel.layer.borderWidth = 1;
        _halfHourLabel.layer.borderColor = AppFontccccccColor.CGColor;
        _halfHourLabel.clipsToBounds = YES;
        _halfHourLabel.font = FONT(14);
        _halfHourLabel.textColor = AppFont000000Color;
    }
    return _halfHourLabel;
}

- (UILabel *)oneHourLabel {
    
    if (!_oneHourLabel) {
        
        _oneHourLabel = [[UILabel alloc] init];
        _oneHourLabel.text = @"一个工";
        _oneHourLabel.textAlignment = NSTextAlignmentCenter;
        _oneHourLabel.backgroundColor = AppFontEBEBEBColor;
        _oneHourLabel.layer.borderWidth = 1;
        _oneHourLabel.layer.borderColor = AppFontccccccColor.CGColor;
        _oneHourLabel.clipsToBounds = YES;
        _oneHourLabel.font = FONT(14);
        _oneHourLabel.textColor = AppFont000000Color;
    }
    return _oneHourLabel;
}
@end
