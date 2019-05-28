//
//  JGJManHourPickerHalfOrOneSelectedView.m
//  mix
//
//  Created by Tony on 2018/11/22.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJManHourPickerHalfOrOneSelectedView.h"
#import "NSString+Extend.h"
#import "UIImage+Color.h"
@interface JGJManHourPickerHalfOrOneSelectedView ()

@property (nonatomic, strong) UIButton *restButton;
@property (nonatomic, strong) UIButton *halfButton;
@property (nonatomic, strong) UIButton *oneTimeButton;

@end
@implementation JGJManHourPickerHalfOrOneSelectedView

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.restButton];
    [self addSubview:self.halfButton];
    [self addSubview:self.oneTimeButton];
    
    CGFloat buttonWidth = (TYGetUIScreenWidth - 4 * 10) / 3;
    

    [_restButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(40);
    }];
    
    [_halfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_restButton.mas_right).offset(10);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(40);
    }];
    
    [_oneTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(40);
    }];
}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    CGFloat btnWidth;
    if (self.isManHourTime) {// 当前显示为正常上班时间
        
        [_restButton setTitle:@"休息" forState:(UIControlStateNormal)];
        
        CGFloat w_h_tpl = 0.0;
        if (self.isContractType) {// 为包工记工天
            
            w_h_tpl = _yzgGetBillModel.unit_quan_tpl.w_h_tpl != 0.0 ? _yzgGetBillModel.unit_quan_tpl.w_h_tpl : 8.0;
            
        }else {// 普通上班时间
            
            w_h_tpl = _yzgGetBillModel.set_tpl.w_h_tpl != 0.0 ? _yzgGetBillModel.set_tpl.w_h_tpl : 8.0;
        }
        
        NSInteger intInt = w_h_tpl * 10;
        NSInteger lefInt = intInt % 10;
        // 判断 上班时间标准 是否能被2 整除
        if (lefInt > 0) {// 不能
            
            [_oneTimeButton setTitle:[NSString stringWithFormat:@"1个工(%.1f小时)",w_h_tpl] forState:(UIControlStateNormal)];
            
            CGFloat buttonWidth = (TYGetUIScreenWidth - 3 * 10) / 2;
            btnWidth = buttonWidth;
            [_restButton mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.width.mas_equalTo(buttonWidth);
            }];
            
            [_halfButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
                make.width.mas_equalTo(0);
            }];
            
            _halfButton.hidden = YES;
            
            [_oneTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.width.mas_equalTo(buttonWidth);
            }];
            
        }else {
            
            NSInteger halfInt = w_h_tpl / 2 * 10;
            NSInteger halfLefInt = halfInt % 10;
            
            if (halfLefInt > 0) {// 2.5 3.5  4.5...
                
                [_halfButton setTitle:[NSString stringWithFormat:@"半个工(%.1f小时)",w_h_tpl / 2] forState:(UIControlStateNormal)];
            }else {
                
                [_halfButton setTitle:[NSString stringWithFormat:@"半个工(%.0f小时)",w_h_tpl / 2] forState:(UIControlStateNormal)];
            }
            
            [_oneTimeButton setTitle:[NSString stringWithFormat:@"1个工(%.0f小时)",w_h_tpl] forState:(UIControlStateNormal)];
            
            CGFloat buttonWidth = (TYGetUIScreenWidth - 4 * 10) / 3;
            btnWidth = buttonWidth;
            [_restButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
            [_halfButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
            _halfButton.hidden = NO;
            [_oneTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
        }
        
    }else {// 当前显示加班时间
        
        [_restButton setTitle:@"无加班" forState:(UIControlStateNormal)];
        
        CGFloat o_h_tpl = 0.0;
        if (self.isContractType) {// 为包工记工天
            
            o_h_tpl = _yzgGetBillModel.unit_quan_tpl.o_h_tpl != 0.0 ? _yzgGetBillModel.unit_quan_tpl.o_h_tpl : 6.0;
            
        }else {// 普通上班时间
            
            o_h_tpl = _yzgGetBillModel.set_tpl.o_h_tpl != 0.0 ? _yzgGetBillModel.set_tpl.o_h_tpl : 6.0;
        }
        
        NSInteger intInt = o_h_tpl * 10;
        NSInteger lefInt = intInt % 10;
        // 判断 加班时间标准 是否能被2 整除
        if (lefInt > 0) {// 不能
            
            [_oneTimeButton setTitle:[NSString stringWithFormat:@"1个工(%.1f小时)",o_h_tpl] forState:(UIControlStateNormal)];
            CGFloat buttonWidth = (TYGetUIScreenWidth - 3 * 10) / 2;
            btnWidth = buttonWidth;
            [_restButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
            [_halfButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(0);
            }];
            
            _halfButton.hidden = YES;
            
            [_oneTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
        }else {
            
            
            NSInteger halfInt = o_h_tpl / 2 * 10;
            NSInteger halfLefInt = halfInt % 10;
            if (halfLefInt > 0) {// 2.5 3.5  4.5...
                
                [_halfButton setTitle:[NSString stringWithFormat:@"半个工(%.1f小时)",o_h_tpl / 2] forState:(UIControlStateNormal)];
            }else {
                
                [_halfButton setTitle:[NSString stringWithFormat:@"半个工(%.0f小时)",o_h_tpl / 2] forState:(UIControlStateNormal)];
            }
            
            [_oneTimeButton setTitle:[NSString stringWithFormat:@"1个工(%.0f小时)",o_h_tpl] forState:(UIControlStateNormal)];
            CGFloat buttonWidth = (TYGetUIScreenWidth - 4 * 10) / 3;
            btnWidth = buttonWidth;
            [_restButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
            [_halfButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
            
            _halfButton.hidden = NO;
            [_oneTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(buttonWidth);
            }];
        }
    }
    
}

- (void)timeButtonCLick:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    switch (index) {
        case 0:
        {
            _restButton.backgroundColor = AppFontccccccColor;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.halfOrOneDelegate respondsToSelector:@selector(selectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
                    
                    [_halfOrOneDelegate selectedHalfOrOneTimeWithTimeStr:@"0.0" isManHourTime:_isManHourTime];
                }
            });
            
        }
            break;
            
        case 1:
        {
            _halfButton.backgroundColor = AppFontccccccColor;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_isManHourTime) {
                    
                    if ([self.halfOrOneDelegate respondsToSelector:@selector(selectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
                        
                        NSString *timeStr;
                        if (self.isContractType) {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.unit_quan_tpl.w_h_tpl / 2];
                        }else {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.set_tpl.w_h_tpl / 2];
                        }
                        
                        if ([timeStr isEqualToString:@"0.0"]) {
                            
                            timeStr = @"4.0";
                        }
                        [_halfOrOneDelegate selectedHalfOrOneTimeWithTimeStr:timeStr isManHourTime:_isManHourTime];
                    }
                }else {
                    
                    if ([self.halfOrOneDelegate respondsToSelector:@selector(selectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
                        
                        NSString *timeStr;
                        if (self.isContractType) {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.unit_quan_tpl.o_h_tpl / 2];
                        }else {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.set_tpl.o_h_tpl / 2];
                        }
                        
                        if ([timeStr isEqualToString:@"0.0"]) {
                            
                            timeStr = @"3.0";
                        }
                        [_halfOrOneDelegate selectedHalfOrOneTimeWithTimeStr:timeStr isManHourTime:_isManHourTime];
                    }
                }
            });
            
        }
            break;
            
        case 2:
        {
            _oneTimeButton.backgroundColor = AppFontccccccColor;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_isManHourTime) {
                    
                    if ([self.halfOrOneDelegate respondsToSelector:@selector(selectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
                        
                        NSString *timeStr;
                        if (self.isContractType) {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.unit_quan_tpl.w_h_tpl];
                        }else {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.set_tpl.w_h_tpl];
                        }
                        
                        if ([timeStr isEqualToString:@"0.0"]) {
                            
                            timeStr = @"8.0";
                        }
                        [_halfOrOneDelegate selectedHalfOrOneTimeWithTimeStr:timeStr isManHourTime:_isManHourTime];
                    }
                }else {
                    
                    if ([self.halfOrOneDelegate respondsToSelector:@selector(selectedHalfOrOneTimeWithTimeStr:isManHourTime:)]) {
                        NSString *timeStr;
                        if (self.isContractType) {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.unit_quan_tpl.o_h_tpl];
                        }else {
                            
                            timeStr = [NSString stringWithFormat:@"%.1f",_yzgGetBillModel.set_tpl.o_h_tpl];
                        }
                        
                        if ([timeStr isEqualToString:@"0.0"]) {
                            
                            timeStr = @"6.0";
                        }
                        [_halfOrOneDelegate selectedHalfOrOneTimeWithTimeStr:timeStr isManHourTime:_isManHourTime];
                    }
                }
            });
            
        }
            break;
            
        default:
            break;
    }
}

- (UIButton *)restButton {
    
    if (!_restButton) {
        
        _restButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restButton setTitle:@"休息/无加班" forState:(UIControlStateNormal)];
        _restButton.titleLabel.font = TYIS_IPHONE_5 ? FONT(AppFont24Size) :FONT(AppFont26Size);
        [_restButton setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        
        _restButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _restButton.tag = 100;
        _restButton.backgroundColor = AppFontf1f1f1Color;
        _restButton.layer.cornerRadius = 5;
        _restButton.clipsToBounds = YES;
        _restButton.layer.borderWidth = 1;
        _restButton.layer.borderColor = AppFontccccccColor.CGColor;
        [_restButton addTarget:self action:@selector(timeButtonCLick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _restButton;
}

- (UIButton *)halfButton {
    
    if (!_halfButton) {
        
        _halfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_halfButton setTitle:@"4小时(半个工)" forState:(UIControlStateNormal)];
        _halfButton.titleLabel.font = TYIS_IPHONE_5 ? FONT(AppFont24Size) :FONT(AppFont26Size);
        [_halfButton setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _halfButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _halfButton.tag = 101;
        
        _halfButton.backgroundColor = AppFontf1f1f1Color;
        _halfButton.layer.cornerRadius = 5;
        _halfButton.clipsToBounds = YES;
        _halfButton.layer.borderWidth = 1;
        _halfButton.layer.borderColor = AppFontccccccColor.CGColor;
        [_halfButton addTarget:self action:@selector(timeButtonCLick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _halfButton;
}

- (UIButton *)oneTimeButton {
    
    if (!_oneTimeButton) {
        
        _oneTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneTimeButton setTitle:@"8小时(半个工)" forState:(UIControlStateNormal)];
        _oneTimeButton.titleLabel.font = TYIS_IPHONE_5 ? FONT(AppFont24Size) :FONT(AppFont26Size);
        [_oneTimeButton setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _oneTimeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _oneTimeButton.tag = 102;
        
        _oneTimeButton.backgroundColor = AppFontf1f1f1Color;
        _oneTimeButton.layer.cornerRadius = 5;
        _oneTimeButton.clipsToBounds = YES;
        _oneTimeButton.layer.borderWidth = 1;
        _oneTimeButton.layer.borderColor = AppFontccccccColor.CGColor;
        [_oneTimeButton addTarget:self action:@selector(timeButtonCLick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _oneTimeButton;
}
@end
