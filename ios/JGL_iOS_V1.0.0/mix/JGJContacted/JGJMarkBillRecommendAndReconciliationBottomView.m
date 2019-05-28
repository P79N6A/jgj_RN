//
//  JGJMarkBillRecommendAndReconciliationBottomView.m
//  mix
//
//  Created by Tony on 2018/6/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillRecommendAndReconciliationBottomView.h"

@interface JGJMarkBillRecommendAndReconciliationBottomView ()

@property (nonatomic, strong) UIView *recommendView;
@property (nonatomic, strong) UIView *recommendTopLine;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UILabel *recommendLabel;
@property (nonatomic, strong) UIImageView *recommendNextImageView;
@property (nonatomic, strong) UIButton *recommendNextBtn;
@property (nonatomic, strong) UIView *recommendBottomLine;

@property (nonatomic, strong) UIView *reconciliationView;
@property (nonatomic, strong) UIView *reconciliationTopLine;
@property (nonatomic, strong) UIImageView *reconciliationImageView;
@property (nonatomic, strong) UILabel *reconciliationLabel;
@property (nonatomic, strong) UIImageView *reconciliationNextImageView;
@property (nonatomic, strong) UIButton *reconciliationNextBtn;
@property (nonatomic, strong) UILabel *wait_confirm_numLabel;
@property (nonatomic, strong) UIView *reconciliationBottomLine;

@property (nonatomic, strong) UIView *setRecordBillTimeView;
@property (nonatomic, strong) UIView *setRecordBillTimeTopLine;
@property (nonatomic, strong) UIImageView *setRecordBillTimeImageView;
@property (nonatomic, strong) UILabel *setRecordBillTimeLabel;
@property (nonatomic, strong) UILabel *setRecordBillTimeDetailLabel;
@property (nonatomic, strong) UIImageView *setRecordBillTimeNextImageView;
@property (nonatomic, strong) UIButton *setRecordBillTimeNextBtn;
@property (nonatomic, strong) UIView *setRecordBillTimeBottomLine;

@end
@implementation JGJMarkBillRecommendAndReconciliationBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = AppFontf1f1f1Color;
        [self initializeAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontf1f1f1Color;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.recommendView];
    [self.recommendView addSubview:self.recommendTopLine];
    [self.recommendView addSubview:self.recommendImageView];
    [self.recommendView addSubview:self.recommendLabel];
    [self.recommendView addSubview:self.recommendNextImageView];
    [self.recommendView addSubview:self.recommendNextBtn];
    [self.recommendView addSubview:self.recommendBottomLine];
    
    [self addSubview:self.reconciliationView];
    [self.reconciliationView addSubview:self.reconciliationTopLine];
    [self.reconciliationView addSubview:self.reconciliationImageView];
    [self.reconciliationView addSubview:self.reconciliationLabel];
    [self.reconciliationView addSubview:self.reconciliationNextImageView];
    [self.reconciliationView addSubview:self.reconciliationNextBtn];
    [self.reconciliationView addSubview:self.wait_confirm_numLabel];
    [self.reconciliationView addSubview:self.reconciliationBottomLine];
    
    
    [self addSubview:self.setRecordBillTimeView];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeTopLine];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeImageView];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeLabel];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeDetailLabel];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeNextImageView];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeNextBtn];
    [self.setRecordBillTimeView addSubview:self.setRecordBillTimeBottomLine];
    
    
    [self setUpLayout];
    
    [_wait_confirm_numLabel updateLayout];
    _wait_confirm_numLabel.layer.cornerRadius = 9;
    _wait_confirm_numLabel.clipsToBounds = YES;
}


- (void)setUpLayout {
    
    _recommendView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 10).rightSpaceToView(self, 0).heightIs(60);
    _recommendTopLine.sd_layout.leftSpaceToView(_recommendView, 0).topSpaceToView(_recommendView, 0).rightSpaceToView(_recommendView, 0).heightIs(1);
    _recommendImageView.sd_layout.leftSpaceToView(_recommendView, 20).centerYEqualToView(_recommendView).widthIs(20).heightIs(15);
    _recommendNextImageView.sd_layout.rightSpaceToView(_recommendView, 10).centerYEqualToView(_recommendView).widthIs(10).heightIs(10);
    _recommendLabel.sd_layout.leftSpaceToView(_recommendImageView, 10).centerYEqualToView(_recommendView).heightIs(60).rightSpaceToView(_recommendNextImageView, 0);
    _recommendNextBtn.sd_layout.leftSpaceToView(_recommendView, 0).topSpaceToView(_recommendView, 0).rightSpaceToView(_recommendView, 0).bottomSpaceToView(_recommendView, 0);
    _recommendBottomLine.sd_layout.leftSpaceToView(_recommendView, 0).rightSpaceToView(_recommendView, 0).bottomSpaceToView(_recommendView, 0).heightIs(1);
    
    _reconciliationView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_recommendView, 10).rightSpaceToView(self, 0).heightIs(60);
    _reconciliationTopLine.sd_layout.leftSpaceToView(_reconciliationView, 0).topSpaceToView(_reconciliationView, 0).rightSpaceToView(_reconciliationView, 0).heightIs(1);
    _reconciliationImageView.sd_layout.leftSpaceToView(_reconciliationView, 20).centerYEqualToView(_reconciliationView).widthIs(20).heightIs(15);
    _reconciliationNextImageView.sd_layout.rightSpaceToView(_reconciliationView, 10).centerYEqualToView(_reconciliationView).widthIs(10).heightIs(10);
    
    _wait_confirm_numLabel.sd_layout.rightSpaceToView(_reconciliationNextImageView, 10).centerYEqualToView(_reconciliationNextImageView).widthIs(25).heightIs(18);
    _reconciliationLabel.sd_layout.leftSpaceToView(_reconciliationImageView, 10).centerYEqualToView(_reconciliationView).heightIs(60).rightSpaceToView(_wait_confirm_numLabel, 0);
    _reconciliationNextBtn.sd_layout.leftSpaceToView(_reconciliationView, 0).topSpaceToView(_reconciliationView, 0).rightSpaceToView(_reconciliationView, 0).bottomSpaceToView(_reconciliationView, 0);
   
    _reconciliationBottomLine.sd_layout.leftSpaceToView(_reconciliationView, 0).rightSpaceToView(_reconciliationView, 0).bottomSpaceToView(_reconciliationView, 0).heightIs(1);

    _setRecordBillTimeView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_reconciliationView, 10).rightSpaceToView(self, 0).heightIs(60);
    _setRecordBillTimeTopLine.sd_layout.leftSpaceToView(_setRecordBillTimeView, 0).topSpaceToView(_setRecordBillTimeView, 0).rightSpaceToView(_setRecordBillTimeView, 0).heightIs(1);
    _setRecordBillTimeImageView.sd_layout.leftSpaceToView(_setRecordBillTimeView, 20).centerYEqualToView(_setRecordBillTimeView).widthIs(20).heightIs(15);
    _setRecordBillTimeNextImageView.sd_layout.rightSpaceToView(_setRecordBillTimeView, 10).centerYEqualToView(_setRecordBillTimeView).widthIs(10).heightIs(10);
    _setRecordBillTimeLabel.sd_layout.leftSpaceToView(_setRecordBillTimeImageView, 10).centerYEqualToView(_setRecordBillTimeView).heightIs(60).widthIs(150);
    _setRecordBillTimeDetailLabel.sd_layout.leftSpaceToView(_setRecordBillTimeLabel, 0).centerYEqualToView(_setRecordBillTimeView).heightIs(60).rightSpaceToView(_setRecordBillTimeNextImageView, 10);
    
    _setRecordBillTimeNextBtn.sd_layout.leftSpaceToView(_setRecordBillTimeView, 0).topSpaceToView(_setRecordBillTimeView, 0).rightSpaceToView(_setRecordBillTimeView, 0).bottomSpaceToView(_setRecordBillTimeView, 0);
    _setRecordBillTimeBottomLine.sd_layout.leftSpaceToView(_setRecordBillTimeView, 0).rightSpaceToView(_setRecordBillTimeView, 0).bottomSpaceToView(_setRecordBillTimeView, 0).heightIs(1);
    
}

- (void)recommendOrReconciliationClick:(UIButton *)sender {
    
    if ([self.recommendAndReconciliationDelegate respondsToSelector:@selector(didSelectedRecommendToOthersOrReconciliationWithIndex:)]) {
        
        [_recommendAndReconciliationDelegate didSelectedRecommendToOthersOrReconciliationWithIndex:sender.tag - 100];
    }
}

- (void)setRecordDetaileTitle:(NSString *)recordDetaileTitle {
    
    _recordDetaileTitle = recordDetaileTitle;
    self.setRecordBillTimeDetailLabel.text = _recordDetaileTitle;
}

- (void)setWait_confirm_num:(NSString *)wait_confirm_num {
    
    _wait_confirm_num = wait_confirm_num;
    self.wait_confirm_numLabel.text = _wait_confirm_num;
    if ([_wait_confirm_num isEqualToString:@"0"] || [NSString isEmpty:_wait_confirm_num]) {
        
        self.wait_confirm_numLabel.hidden = YES;
    }else {
        
        self.wait_confirm_numLabel.hidden = NO;
    }
}

- (UIView *)recommendView {
    
    if (!_recommendView) {
        
        _recommendView = [[UIView alloc] init];
        _recommendView.backgroundColor = [UIColor whiteColor];
    }
    return _recommendView;
}

- (UIImageView *)recommendImageView {
    
    if (!_recommendImageView) {
        
        _recommendImageView = [[UIImageView alloc] init];
        _recommendImageView.image = IMAGE(@"recommendIcon");
        _recommendImageView.contentMode = UIViewContentModeCenter;
    }
    return _recommendImageView;
}

- (UILabel *)recommendLabel {
    
    if (!_recommendLabel) {
        
        _recommendLabel = [[UILabel alloc] init];
        _recommendLabel.textColor = AppFont333333Color;
        _recommendLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _recommendLabel.text = @"推荐给他人";
        
    }
    return _recommendLabel;
}

- (UIImageView *)recommendNextImageView {
    
    if (!_recommendNextImageView) {
        
        _recommendNextImageView = [[UIImageView alloc] init];
        
        _recommendNextImageView.image = IMAGE(@"arrow_right");
        _recommendNextImageView.contentMode = UIViewContentModeCenter;
    }
    return _recommendNextImageView;
}

- (UIButton *)recommendNextBtn {
    
    if (!_recommendNextBtn) {
        
        _recommendNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendNextBtn.tag = 100;
        [_recommendNextBtn addTarget:self action:@selector(recommendOrReconciliationClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _recommendNextBtn;
}
- (UIView *)reconciliationView {
    
    if (!_reconciliationView) {
        
        _reconciliationView = [[UIView alloc] init];
        _reconciliationView.backgroundColor = [UIColor whiteColor];
    }
    return _reconciliationView;
}

- (UIImageView *)reconciliationImageView {
    
    if (!_reconciliationImageView) {
        
        _reconciliationImageView = [[UIImageView alloc] init];
        _reconciliationImageView.image = IMAGE(@"reconciliationIcon");
        _reconciliationImageView.contentMode = UIViewContentModeCenter;
    }
    return _reconciliationImageView;
}

- (UILabel *)reconciliationLabel {
    
    if (!_reconciliationLabel) {
        
        _reconciliationLabel = [[UILabel alloc] init];
        _reconciliationLabel.textColor = AppFont333333Color;
        _reconciliationLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _reconciliationLabel.text = @"我要对账";
        
    }
    return _reconciliationLabel;
}

- (UIImageView *)reconciliationNextImageView {
    
    if (!_reconciliationNextImageView) {
        
        _reconciliationNextImageView = [[UIImageView alloc] init];
        _reconciliationNextImageView.image = IMAGE(@"arrow_right");
        _reconciliationNextImageView.contentMode = UIViewContentModeCenter;
        
    }
    return _reconciliationNextImageView;
}

- (UILabel *)wait_confirm_numLabel {
    
    if (!_wait_confirm_numLabel) {
        
        _wait_confirm_numLabel = [[UILabel alloc] init];
        _wait_confirm_numLabel.text = @"";
        _wait_confirm_numLabel.backgroundColor = AppFontFF0000Color;
        _wait_confirm_numLabel.textAlignment = NSTextAlignmentCenter;
        _wait_confirm_numLabel.textColor = AppFontffffffColor;
        _wait_confirm_numLabel.font = FONT(AppFont24Size);
        _wait_confirm_numLabel.hidden = YES;
    }
    return _wait_confirm_numLabel;
}

- (UIButton *)reconciliationNextBtn {
    
    if (!_reconciliationNextBtn) {
        
        _reconciliationNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reconciliationNextBtn.tag = 101;
        [_reconciliationNextBtn addTarget:self action:@selector(recommendOrReconciliationClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _reconciliationNextBtn;
}


- (UIView *)setRecordBillTimeView {
    
    if (!_setRecordBillTimeView) {
        
        _setRecordBillTimeView = [[UIView alloc] init];
        _setRecordBillTimeView.backgroundColor = [UIColor whiteColor];
    }
    return _setRecordBillTimeView;
}

- (UIImageView *)setRecordBillTimeImageView {
    
    if (!_setRecordBillTimeImageView) {
        
        _setRecordBillTimeImageView = [[UIImageView alloc] init];
        _setRecordBillTimeImageView.image = IMAGE(@"recordBillShowTypeIcon");
        _setRecordBillTimeImageView.contentMode = UIViewContentModeCenter;
    }
    return _setRecordBillTimeImageView;
}

- (UILabel *)setRecordBillTimeLabel {
    
    if (!_setRecordBillTimeLabel) {
        
        _setRecordBillTimeLabel = [[UILabel alloc] init];
        _setRecordBillTimeLabel.textColor = AppFont333333Color;
        _setRecordBillTimeLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _setRecordBillTimeLabel.text = @"设置记工显示方式";
        
    }
    return _setRecordBillTimeLabel;
}

- (UILabel *)setRecordBillTimeDetailLabel {
    
    if (!_setRecordBillTimeDetailLabel) {
        
        _setRecordBillTimeDetailLabel = [[UILabel alloc] init];
        _setRecordBillTimeDetailLabel.textColor = AppFontEB4E4EColor;
        _setRecordBillTimeDetailLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        _setRecordBillTimeDetailLabel.textAlignment = NSTextAlignmentRight;
        _setRecordBillTimeDetailLabel.text = @"上班按工天，加班按小时";
        
    }
    return _setRecordBillTimeDetailLabel;
}
- (UIImageView *)setRecordBillTimeNextImageView {
    
    if (!_setRecordBillTimeNextImageView) {
        
        _setRecordBillTimeNextImageView = [[UIImageView alloc] init];
        _setRecordBillTimeNextImageView.image = IMAGE(@"arrow_right");
        _setRecordBillTimeNextImageView.contentMode = UIViewContentModeCenter;
        
    }
    return _setRecordBillTimeNextImageView;
}

- (UIButton *)setRecordBillTimeNextBtn {
    
    if (!_setRecordBillTimeNextBtn) {
        
        _setRecordBillTimeNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setRecordBillTimeNextBtn.tag = 102;
        [_setRecordBillTimeNextBtn addTarget:self action:@selector(recommendOrReconciliationClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _setRecordBillTimeNextBtn;
}

- (UIView *)recommendTopLine {
    
    if (!_recommendTopLine) {
        
        _recommendTopLine = [[UIView alloc] init];
        _recommendTopLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _recommendTopLine;
}

- (UIView *)recommendBottomLine {
    
    if (!_recommendBottomLine) {
        
        _recommendBottomLine = [[UIView alloc] init];
        _recommendBottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _recommendBottomLine;
}

- (UIView *)reconciliationTopLine {
    
    if (!_reconciliationTopLine) {
        
        _reconciliationTopLine = [[UIView alloc] init];
        _reconciliationTopLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _reconciliationTopLine;
}

- (UIView *)reconciliationBottomLine {
    
    if (!_reconciliationBottomLine) {
        
        _reconciliationBottomLine = [[UIView alloc] init];
        _reconciliationBottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _reconciliationBottomLine;
}

- (UIView *)setRecordBillTimeTopLine {
    
    if (!_setRecordBillTimeTopLine) {
        
        _setRecordBillTimeTopLine = [[UIView alloc] init];
        _setRecordBillTimeTopLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _setRecordBillTimeTopLine;
}

- (UIView *)setRecordBillTimeBottomLine {
    
    if (!_setRecordBillTimeBottomLine) {
        
        _setRecordBillTimeBottomLine = [[UIView alloc] init];
        _setRecordBillTimeBottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _setRecordBillTimeBottomLine;
}

@end
