//
//  JGJChoiceWorkOvertimeCalculateWay.m
//  mix
//
//  Created by ccclear on 2019/4/15.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChoiceWorkOvertimeCalculateWay.h"
#import "JGJCusActiveSheetView.h"
@interface JGJChoiceWorkOvertimeCalculateWay ()

@property (nonatomic, strong) UILabel *calculateTitleLabel;
@property (nonatomic, strong) UILabel *calculateDetail;
@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) UIButton *choiceBtn;
@property (nonatomic, strong) UIView *bottomLine;


@end
@implementation JGJChoiceWorkOvertimeCalculateWay

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
 
    [self addSubview:self.calculateTitleLabel];
    [self addSubview:self.calculateDetail];
    [self addSubview:self.downImageView];
    [self addSubview:self.choiceBtn];
    [self addSubview:self.bottomLine];
    
    [self setUpLayout];
}


- (void)choiceCalculateWay {
    
    TYLog(@"选择加班方式");
    if (self.clickTheOvertimeWageByWay) {
        
        _clickTheOvertimeWageByWay();
    }

    NSArray *buttons = @[@"选择加班计算方式", @"按工天算加班", @"按小时算加班工资", @"取消"];
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewChoiceOvertimeCalculateType chageColors:@[] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (weakSelf.theOvertimeWageByWay) {
            
            weakSelf.theOvertimeWageByWay(buttonIndex);
        }
    }];
    sheetView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
    [sheetView showView];
}
- (void)setUpLayout {
    
    [_calculateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(14);
    }];
    
    [_downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(_calculateTitleLabel.mas_centerY).offset(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(9);
    }];
    
    [_calculateDetail mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_downImageView.mas_left).offset(-8);
        make.centerY.equalTo(_calculateTitleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(14);
    }];
    
    [_choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
}

- (void)setOvertimeWageByTheHour:(BOOL)overtimeWageByTheHour {
    
    _overtimeWageByTheHour = overtimeWageByTheHour;
    if (_overtimeWageByTheHour) {
        
        _calculateDetail.text = @"按小时算加班工资";
    }else {
        
        _calculateDetail.text = @"按工天算加班";
    }
}

- (UILabel *)calculateTitleLabel {
    
    if (!_calculateTitleLabel) {
        
        _calculateTitleLabel = [[UILabel alloc] init];
        _calculateTitleLabel.text = @"加班计算方式";
        _calculateTitleLabel.textColor = AppFont333333Color;
        _calculateTitleLabel.font = FONT(AppFont28Size);
        
    }
    return _calculateTitleLabel;
}

- (UILabel *)calculateDetail {
    
    if (!_calculateDetail) {
        
        _calculateDetail = [[UILabel alloc] init];
        _calculateDetail.textColor = AppFont333333Color;
        _calculateDetail.text = @"按工天算加班";
        _calculateDetail.font = FONT(AppFont28Size);
    }
    return _calculateDetail;
}

- (UIImageView *)downImageView {
    
    if (!_downImageView) {
        
        _downImageView = [[UIImageView alloc] init];
        _downImageView.image = IMAGE(@"calculateWorkWay_triangleImage");
        
    }
    return _downImageView;
}

- (UIButton *)choiceBtn {
    
    if (!_choiceBtn) {
        
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBtn addTarget:self action:@selector(choiceCalculateWay) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _choiceBtn;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

@end
