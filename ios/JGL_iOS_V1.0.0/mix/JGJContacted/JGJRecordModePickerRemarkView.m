//
//  JGJRecordModePickerRemarkView.m
//  mix
//
//  Created by Tony on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordModePickerRemarkView.h"
#import "NSString+Extend.h"
@interface JGJRecordModePickerRemarkView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *nextImage;

@property (nonatomic, strong) UIButton *nextBtn;


@end
@implementation JGJRecordModePickerRemarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.title];
    [self addSubview:self.content];
    [self addSubview:self.nextImage];
    [self addSubview:self.nextBtn];
    [self addSubview:self.remarkBottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(15);
        make.top.mas_equalTo(16.5);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(12);
    }];
    
    [_nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(_title.mas_centerY).offset(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_title.mas_right).offset(10);
        make.right.equalTo(_nextImage.mas_left).offset(-5);
        make.centerY.equalTo(_title.mas_centerY).offset(0);
        make.height.mas_equalTo(12);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_title.mas_right).offset(10);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [_remarkBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(50);
    }];

}

- (void)nextBtnClick {
    
    if ([self.remarkViewDelegate respondsToSelector:@selector(didSelectedRecordRemark)]) {
        
        [self.remarkViewDelegate didSelectedRecordRemark];
    }
}

- (void)setRemarkedTxt:(NSString *)remarkedTxt {
    
    _remarkedTxt = remarkedTxt;
    
    if (_remarkedTxt.length == 0) {
        
        _content.text = @"可填写备注信息";
        _content.textColor = AppFont999999Color;
    }else {
        
        _content.text = _remarkedTxt;
        _content.textColor = AppFont333333Color;
    }
}

- (UILabel *)title {
    
    if (!_title) {
        
        _title = [[UILabel alloc] init];
        _title.text = @"批量备注";
        _title.textColor = AppFont333333Color;
        _title.font = FONT(AppFont30Size);
        _title.textAlignment = NSTextAlignmentLeft;
        
    }
    return _title;
}

- (UILabel *)content {
    
    if (!_content) {
        
        _content = [[UILabel alloc] init];
        _content.text = @"可填写备注信息";
        _content.font = FONT(AppFont28Size);
        _content.textColor = AppFont999999Color;
        _content.textAlignment = NSTextAlignmentRight;
    }
    return _content;
}

- (UIImageView *)nextImage {
    
    if (!_nextImage) {
        
        _nextImage = [[UIImageView alloc] init];
        _nextImage.image = IMAGE(@"arrow_right");
        _nextImage.contentMode = UIViewContentModeRight;
    }
    return _nextImage;
}

- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}

- (UILabel *)remarkBottomLine {
    
    if (!_remarkBottomLine) {
        
        _remarkBottomLine = [[UILabel alloc] init];
        _remarkBottomLine.backgroundColor = AppFontEBEBEBColor;
    }
    return _remarkBottomLine;
}
@end
