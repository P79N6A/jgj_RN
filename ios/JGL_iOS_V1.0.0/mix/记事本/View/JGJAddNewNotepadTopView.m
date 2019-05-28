//
//  JGJAddNewNotepadTopView.m
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddNewNotepadTopView.h"
#import "SJButton.h"
#import "NSDate+Extend.h"
@interface JGJAddNewNotepadTopView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *emptyBtn;
@property (nonatomic, strong) SJButton *titleBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSDateComponents *comp;

@end
@implementation JGJAddNewNotepadTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backBtn];
    [self addSubview:self.emptyBtn];
    [self addSubview:self.titleBtn];
    [self addSubview:self.saveBtn];
    [self addSubview:self.line];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _backBtn.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 32 + JGJ_NAV_HEIGHT - 64).widthIs(18).heightIs(18);
    _emptyBtn.sd_layout.centerXEqualToView(_backBtn).centerYEqualToView(_backBtn).widthIs(28).heightIs(28);
    _saveBtn.sd_layout.rightSpaceToView(self, 10).centerYEqualToView(_backBtn).widthIs(36).heightIs(24);
    _titleBtn.sd_layout.leftSpaceToView(_backBtn, 28).centerYEqualToView(_backBtn).rightSpaceToView(_saveBtn, 10).heightIs(24);
    _line.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(1);
}

#pragma mark -
- (void)crateNewNotePad {
    
    if ([self respondsToSelector:@selector(close)]) {
        
        _close();
    }
}

- (void)choiceSaveTime {
    
    if ([self respondsToSelector:@selector(choiceTheSaveTime)]) {
        
        _choiceTheSaveTime();
    }
}

- (void)saveTheNotepad {
    
    if ([self respondsToSelector:@selector(saveNotepad)]) {
        
        _saveNotepad();
    }
}

- (void)setTheTitleWithTimeArray:(NSArray *)timeArray weekIndex:(NSInteger)weekIndex {
    
    
    NSString *timeTitle = [NSString stringWithFormat:@"%@年%@月%@日", timeArray[0],[timeArray[1] stringByReplacingOccurrencesOfString:@"0" withString:@""],timeArray[2]];
    switch (weekIndex) {
        case 1:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期日",timeTitle];
        }
            break;
        case 2:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期一",timeTitle];
        }
            break;
        case 3:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期二",timeTitle];
        }
            break;
        case 4:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期三",timeTitle];
        }
            break;
        case 5:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期四",timeTitle];
        }
            break;
        case 6:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期五",timeTitle];
        }
            break;
        case 7:
        {
            timeTitle = [NSString stringWithFormat:@"%@ 星期六",timeTitle];
        }
            break;
            
        default:
            break;
    }
    
    [_titleBtn setTitle:timeTitle forState:SJControlStateNormal];
}

- (UIButton *)backBtn {
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:IMAGE(@"close_addNewNotepad") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)emptyBtn {
    
    if (!_emptyBtn) {
        
        _emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyBtn addTarget:self action:@selector(crateNewNotePad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyBtn;
}
- (SJButton *)titleBtn {
    
    if (!_titleBtn) {
        
        _titleBtn = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        [_titleBtn setBackgroundColor:[UIColor whiteColor]];
        [_titleBtn setImage:IMAGE(@"addNewNotepad_shape") forState:SJControlStateNormal];
        [_titleBtn setTitleColor:AppFont030303Color forState:SJControlStateHighlighted];
        [_titleBtn setBackgroundColor:[UIColor whiteColor] forState:SJControlStateHighlighted];
        _titleBtn.titleLabel.font = FONT(AppFont34Size);
        
        [_titleBtn addTarget:self action:@selector(choiceSaveTime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        
        _saveBtn.titleLabel.font = FONT(AppFont34Size);
        
        [_saveBtn addTarget:self action:@selector(saveTheNotepad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontf1f1f1Color;
    }
    return _line;
}
@end
