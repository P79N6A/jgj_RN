//
//  PopoverViewCell.m
//  Popover
//
//  Created by StevenLee on 2016/12/10.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "PopoverViewCell.h"

// extern
float const PopoverViewCellHorizontalMargin = 25.f; ///< 水平边距
float const PopoverViewCellVerticalMargin = 3.f; ///< 垂直边距
float const PopoverViewCellTitleLeftEdge = 5.f; ///< 标题左边边距

@interface PopoverViewCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, strong) UIView *redFlagView;//红色标记View
@end

@implementation PopoverViewCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // initialize
    [self initialize];
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = _style == PopoverViewStyleDefault ? [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00] : [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }
}

#pragma mark - Setter
- (void)setStyle:(PopoverViewStyle)style {
    _style = style;
//    _bottomLine.backgroundColor = [self.class bottomLineColorForStyle:style];
    
    _bottomLine.backgroundColor = TYColorHex(0x5E5E5E);
    if (_style == PopoverViewStyleDefault) {
        [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    } else {
        [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}

#pragma mark - Private
// 初始化
- (void)initialize {
    // UI
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.userInteractionEnabled = NO; // has no use for UserInteraction.
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.titleLabel.font = [self.class titleFont];
    _button.backgroundColor = self.contentView.backgroundColor;
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.contentView addSubview:_button];
    
    _redFlagView = [[UIView alloc] init];
    _redFlagView.backgroundColor = TYColorHex(0xFF0000);
    [self.contentView addSubview:_redFlagView];
    
    _redFlagView.hidden = YES;
    
    [_redFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView).mas_offset(10);
        make.leading.mas_equalTo(35);
        make.height.mas_equalTo(8);
        make.width.mas_equalTo(8);
    }];
    
    [_redFlagView.layer setLayerCornerRadius:4.0];
    
    // Constraint
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(PopoverViewCellHorizontalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_button]-margin-|" options:kNilOptions metrics:@{@"margin" : @(PopoverViewCellVerticalMargin)} views:NSDictionaryOfVariableBindings(_button)]];
    // 底部线条
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TYColorHex(0x5E5E5E);
    bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
//    // Constraint
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(lineHeight)]|" options:kNilOptions metrics:@{@"lineHeight" : @(1/[UIScreen mainScreen].scale)} views:NSDictionaryOfVariableBindings(bottomLine)]];
    
    //3.5.2yj添加
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.contentView);
//        make.leading.mas_equalTo(70);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(104);
    }];
    
}

#pragma mark - Public
/*! @brief 标题字体 */
+ (UIFont *)titleFont {
    
    return [UIFont systemFontOfSize:TYIS_IPHONE_6P ? 16.f :15.f];
}

/*! @brief 底部线条颜色 */
+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style {
    return style == PopoverViewStyleDefault ? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.00];
}

- (void)setAction:(PopoverAction *)action {
    [_button setImage:action.image forState:UIControlStateNormal];
    [_button setTitle:action.title forState:UIControlStateNormal];
    _button.titleEdgeInsets = action.image ? UIEdgeInsetsMake(0, PopoverViewCellTitleLeftEdge, 0, -PopoverViewCellTitleLeftEdge) : UIEdgeInsetsZero;
    
    _button.imageEdgeInsets = action.image ? UIEdgeInsetsMake(0, - PopoverViewCellTitleLeftEdge, 0, 0) : UIEdgeInsetsZero;
    
    _redFlagView.hidden = !action.isShowRedFlag;
}

- (void)showBottomLine:(BOOL)show {
    _bottomLine.hidden = !show;
}

@end
