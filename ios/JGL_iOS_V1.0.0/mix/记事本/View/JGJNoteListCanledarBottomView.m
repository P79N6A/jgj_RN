//
//  JGJNoteListCanledarBottomView.m
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNoteListCanledarBottomView.h"
#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJNoteListCanledarBottomView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJNoteListCanledarBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.topLine];
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftLabel];
    
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightLabel];
    [self addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.top.mas_offset(0);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(40);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(15);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_leftImageView.mas_right).offset(7);
        make.centerY.equalTo(_leftImageView.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-40);
        make.centerY.equalTo(_leftImageView.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_rightLabel.mas_left).offset(-7);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(15);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(10);
        make.bottom.mas_offset(0);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(1);
    }];
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontccccccColor;
    }
    return _topLine;
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = IMAGE(@"notepadCanledarBottomBlue");
    }
    return _leftImageView;
}

- (UILabel *)leftLabel {
    
    if (!_leftLabel) {
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"这一天有记事";
        _leftLabel.textColor = AppFont000000Color;
        _leftLabel.font = FONT(AppFont28Size);
        
    }
    return _leftLabel;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = IMAGE(@"notepadCanledarStar");
    }
    return _rightImageView;
}

- (UILabel *)rightLabel {
    
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = AppFont000000Color;
        _rightLabel.text = @"这一天有重要记事";
                
        [_rightLabel markText:@"重要记事" withColor:AppFontFF6600Color];
        
        _rightLabel.font = FONT(AppFont28Size);
    }
    return _rightLabel;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontccccccColor;
    }
    return _bottomLine;
}
@end
