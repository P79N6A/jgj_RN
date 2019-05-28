//
//  JGJQuestionTitleView.m
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuestionTitleView.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJQuestionTitleView ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *questionTitle;


@end
@implementation JGJQuestionTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.leftLine];
    [self addSubview:self.questionLabel];
    [self addSubview:self.rightLine];
    [self addSubview:self.questionTitle];
    
    [self setUpLayout];
}



- (void)setUpLayout {
    
    _questionLabel.sd_layout.centerYEqualToView(self).centerXEqualToView(self).widthIs(40).heightIs(25);
    _leftLine.sd_layout.rightSpaceToView(_questionLabel, 11).centerYEqualToView(self).heightIs(1).widthIs(46);
    _rightLine.sd_layout.leftSpaceToView(_questionLabel, 11).centerYEqualToView(self).heightIs(1).widthIs(46);
    
    _questionTitle.sd_layout.leftSpaceToView(self, 10).bottomSpaceToView(self, 0).rightSpaceToView(self, 10).heightIs(25);
}

- (void)setQuestionTitleStr:(NSString *)questionTitleStr {
    
    _questionTitleStr = questionTitleStr;
    
    _questionTitle.text = _questionTitleStr;
    [_questionTitle updateLayout];
    CGFloat titleHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:_questionTitle.text font:AppFont36Size];
    _questionTitle.sd_layout.heightIs(titleHeight);
    
}

- (void)setAnswerStr:(NSString *)answerStr {
    
    _answerStr = answerStr;
    
    _questionTitle.text = [NSString stringWithFormat:@"4.请输入[%@]的电话号码",_answerStr];
    [_questionTitle updateLayout];
    CGFloat titleHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:_questionTitle.text font:AppFont36Size];
    _questionTitle.sd_layout.heightIs(titleHeight);
    
    NSString *str = [[NSString alloc] initWithFormat:@"[%@]",_answerStr];
    [self.questionTitle markattributedTextArray:@[str] color:AppFontEF272FColor font:self.questionTitle.font isGetAllText:YES];
    
}

- (UIView *)leftLine {
    
    if (!_leftLine) {
        
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = AppFontD8d8d8Color;
    }
    return _leftLine;
}

- (UILabel *)questionLabel {
    
    if (!_questionLabel) {
        
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.textColor = AppFont000000Color;
        _questionLabel.font = FONT(AppFont36Size);
        _questionLabel.textAlignment = NSTextAlignmentCenter;
        _questionLabel.text = @"问题";
        
    }
    return _questionLabel;
}

- (UIView *)rightLine {
    
    if (!_rightLine) {
        
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = AppFontD8d8d8Color;
    }
    return _rightLine;
}

- (UILabel *)questionTitle {
    
    if (!_questionTitle) {
        
        _questionTitle = [[UILabel alloc] init];
        _questionTitle.textAlignment = NSTextAlignmentCenter;
        _questionTitle.font = FONT(AppFont36Size);
        _questionTitle.textColor = AppFont000000Color;
        _questionTitle.numberOfLines = 0;
        
    }
    return _questionTitle;
}
@end
