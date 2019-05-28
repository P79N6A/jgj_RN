//
//  JGJRecordBillDetailContractorHeaderTypeView.m
//  mix
//
//  Created by Tony on 2019/2/21.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRecordBillDetailContractorHeaderTypeView.h"

@interface JGJRecordBillDetailContractorHeaderTypeView ()

@property (nonatomic, strong) UILabel *contractorTypeLabel;
@property (nonatomic, strong) UIView *line;

@end
@implementation JGJRecordBillDetailContractorHeaderTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.contractorTypeLabel];
    [self addSubview:self.line];
}

- (void)setContractorType:(NSInteger)contractorType {
    
    _contractorType = contractorType;
    
    _contractorTypeLabel.frame = CGRectMake(15, 16, CGRectGetWidth(self.frame) - 30, 15);
    _line.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 30, 0.5);
    
    if (_contractorType == 1) {
        
        _contractorTypeLabel.text = @"记工类型：承包";
        
    }else if (_contractorType == 2){
        
        _contractorTypeLabel.text = @"记工类型：分包";
    }
}

- (UILabel *)contractorTypeLabel {
    
    if (!_contractorTypeLabel) {
        
        _contractorTypeLabel = [[UILabel alloc] init];
        _contractorTypeLabel.textColor = [AppFont333333Color colorWithAlphaComponent:0.8];
        _contractorTypeLabel.font = FONT(AppFont28Size);
    }
    return _contractorTypeLabel;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}
@end
