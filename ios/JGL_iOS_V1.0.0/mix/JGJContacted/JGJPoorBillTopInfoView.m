//
//  JGJPoorBillTopInfoView.m
//  mix
//
//  Created by Tony on 2018/11/26.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJPoorBillTopInfoView.h"

@interface JGJPoorBillTopInfoView ()

@property (nonatomic, strong) UIView *topLine;

@end
@implementation JGJPoorBillTopInfoView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = AppFontf7f7f7Color;
    
    [self addSubview:self.topLine];
    [self addSubview:self.detailInfo];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_offset(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_detailInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(15);
    }];
    
}

- (UILabel *)detailInfo {
    
    if (!_detailInfo) {
        
        _detailInfo = [[UILabel alloc] init];
        _detailInfo.font = [UIFont boldSystemFontOfSize:AppFont26Size];
        _detailInfo.textColor = AppFont1892E7Color;
        _detailInfo.textAlignment = NSTextAlignmentLeft;
    }
    return _detailInfo;
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLine;
}

@end
