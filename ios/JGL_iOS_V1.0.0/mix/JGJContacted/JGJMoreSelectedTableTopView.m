//
//  JGJMoreSelectedTableTopView.m
//  mix
//
//  Created by Tony on 2018/3/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMoreSelectedTableTopView.h"
#import "UILabel+GNUtil.h"

@interface JGJMoreSelectedTableTopView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation JGJMoreSelectedTableTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    _isSelctedAll = YES;
    [self addSubview:self.backView];
    [self.backView addSubview:self.contentLable];
    [self.backView addSubview:self.selectedAll];
    
    [self setUpLayout];
    
    [_selectedAll updateLayout];
    
    _selectedAll.layer.cornerRadius = 3;
}

- (void)setUpLayout {
    
    _backView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    _selectedAll.sd_layout.rightSpaceToView(_backView, 10).centerYEqualToView(self).heightIs(28).widthIs(60);
    _contentLable.sd_layout.leftSpaceToView(_backView, 10).topSpaceToView(_backView, 0).bottomSpaceToView(_backView, 0).rightSpaceToView(_selectedAll, 0);
    
}

- (void)setManNum:(NSString *)manNum {
    
    self.contentLable.text = [NSString stringWithFormat:@"未记工工人(%@人)\n长按头像可修改工资标准",manNum];
    [self.contentLable markLineTextWithLeftTextAlignment:@"长按头像可修改工资标准" withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFontEB4E4EColor lineSpace:5];
    
}

- (void)setIsSelctedAll:(BOOL)isSelctedAll {
    
    _isSelctedAll = isSelctedAll;
    if (!_isSelctedAll) {
        
        _selectedAll.selected = NO;
        
    }else {
        
        _selectedAll.selected = YES;
    }
}

- (void)clickTheAllChoiceBtn:(UIButton *)sender {
    
    
    if ([self respondsToSelector:@selector(choiceAllPerson)]) {
        
        _choiceAllPerson(sender.selected,self.selectedAll);
    }
}

- (UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = AppFontf1f1f1Color;
    }
    return _backView;
}

- (UILabel *)contentLable {
    
    if (!_contentLable) {
        
        _contentLable = [[UILabel alloc] init];
        _contentLable.text = @"长按头像可修改工资标准";
        _contentLable.font = FONT(AppFont26Size);
        _contentLable.numberOfLines = 0;
        _contentLable.textColor = [UIColor blackColor];
        
    }
    return _contentLable;
}

- (UIButton *)selectedAll {
    
    if (!_selectedAll) {
        
        _selectedAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedAll setTitle:@"全选" forState:UIControlStateNormal];
        [_selectedAll setTitle:@"取消全选" forState:UIControlStateSelected];
        _selectedAll.titleLabel.font = FONT(AppFont26Size);
        [_selectedAll setTitleColor:TYColorHex(0XEB4E4E) forState:UIControlStateNormal];
        [_selectedAll addTarget:self action:@selector(clickTheAllChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        _selectedAll.layer.borderWidth = 1;
        _selectedAll.layer.borderColor = AppFontEB4E4EColor.CGColor;
        _selectedAll.clipsToBounds = YES;
    }
    return _selectedAll;
}
@end
