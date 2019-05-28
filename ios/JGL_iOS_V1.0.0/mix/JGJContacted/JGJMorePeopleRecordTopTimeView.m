//
//  JGJMorePeopleRecordTopTimeView.m
//  mix
//
//  Created by Tony on 2018/11/27.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJMorePeopleRecordTopTimeView.h"
#import "SJButton.h"
@interface JGJMorePeopleRecordTopTimeView ()

@property (nonatomic, strong) SJButton *timeSelectedBtn;
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJMorePeopleRecordTopTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}
- (void)initializeAppearance {
    
    [self addSubview:self.timeSelectedBtn];
    [self addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_timeSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_offset(0);
        make.height.mas_equalTo(20);

    }];

    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)choiceSaveTime {
    
    if ([self.topTimeViewDelegate respondsToSelector:@selector(recordTopTimeDidSelected)]) {
        
        [self.topTimeViewDelegate recordTopTimeDidSelected];
    }
}

- (void)setTopShowTime:(NSString *)topShowTime {
    
    _topShowTime = topShowTime;
    [_timeSelectedBtn setTitle:_topShowTime forState:(SJControlStateNormal)];
}

- (SJButton *)timeSelectedBtn {
    
    if (!_timeSelectedBtn) {
        
        _timeSelectedBtn = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        [_timeSelectedBtn setBackgroundColor:[UIColor whiteColor]];
        [_timeSelectedBtn setImage:IMAGE(@"down_arrow_icon") forState:SJControlStateNormal];
        [_timeSelectedBtn setTitleColor:AppFont030303Color forState:SJControlStateHighlighted];
        [_timeSelectedBtn setBackgroundColor:[UIColor whiteColor] forState:SJControlStateHighlighted];
        _timeSelectedBtn.titleLabel.font = FONT(AppFont34Size);
        [_timeSelectedBtn setTitle:@"2018年11月" forState:(SJControlStateNormal)];
        [_timeSelectedBtn addTarget:self action:@selector(choiceSaveTime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeSelectedBtn;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _bottomLine;
}

@end
