//
//  SJButton.m
//  SJShareMall
//
//  Created by 金峰 on 2017/8/30.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "SJButton.h"

#define HEX(hex)             [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface SJButton ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
/**
 * 原始的背景色
 */
@property (nonatomic, strong) UIColor *originBackgroundColor;
/**
 * 原始的字体颜色
 */
@property (nonatomic, strong) UIColor *originTitleColor;
/**
 * 原始的title
 */
@property (nonatomic, copy) NSString *originTitle;
/**
 * 原始的图片
 */
@property (nonatomic, strong) UIImage *originImage;
/**
 * 图片的原始颜色
 */
@property (nonatomic, strong) UIColor *originImageTintColor;

@property (nonatomic, strong) NSMutableDictionary *titleDic;
@property (nonatomic, strong) NSMutableDictionary *titleColorDic;
@property (nonatomic, strong) NSMutableDictionary *imageDic;
@property (nonatomic, strong) NSMutableDictionary *backgroundColorDic;

@property (nonatomic, strong) NSLayoutConstraint *spaceConstraint;
@end

@implementation SJButton


- (NSMutableDictionary *)backgroundColorDic {
    if (!_backgroundColorDic) {
        _backgroundColorDic = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _backgroundColorDic;
}

- (NSMutableDictionary *)titleDic {
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _titleDic;
}

- (NSMutableDictionary *)titleColorDic {
    if (!_titleColorDic) {
        _titleColorDic = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _titleColorDic;
}

- (NSMutableDictionary *)imageDic {
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _imageDic;
}

#pragma mark - init

+ (instancetype)button {
    return [[self alloc] init];
}

+ (instancetype)buttonWithType:(SJButtonType)buttonType {
    return [[self alloc] initWithButtonType:buttonType];
}

- (instancetype)init {
    self = [self initWithButtonType:SJButtonTypeVerticalImageTitle];
    return self;
}

- (instancetype)initWithButtonType:(SJButtonType)buttonType {
    self = [super init];
    if (self) {
        _buttonType = buttonType;
        _space = 6;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _notNeedTheTrackingEffect = NO;
    self.contentView = [[UIView alloc] init];
    self.contentView.userInteractionEnabled = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.originTitle = self.titleLabel.text;
    self.originTitleColor = self.titleLabel.textColor;
    self.originImage = self.imageView.image;
    self.originBackgroundColor = self.backgroundColor;
    self.originImageTintColor = self.imageView.tintColor;
    
    [self setupContentConstraints];
}

- (void)setupContentConstraints {
    if (self.buttonType == SJButtonTypeVerticalImageTitle) {
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *imageLeft = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imageRight = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *imageCenterX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraints:@[imageTop, imageLeft, imageRight, imageCenterX]];
        
        NSLayoutConstraint *labelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.space];
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *labelRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *labelBottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[labelTop, labelLeft, labelRight, labelCenterX, labelBottom]];
        
        self.spaceConstraint = labelTop;
    } else if (self.buttonType == SJButtonTypeVerticalTitleImage) {
        NSLayoutConstraint *labelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *labelRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraints:@[labelTop, labelLeft, labelRight, labelCenterX]];
        
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.space];
        NSLayoutConstraint *imageLeft = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imageRight = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *imageCenterX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *imageBottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[imageTop, imageLeft, imageRight, imageCenterX, imageBottom]];
        
        self.spaceConstraint = imageTop;
    } else if (self.buttonType == SJButtonTypeHorizontalImageTitle) {
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *imageLeft = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *imageBottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *imageCenterY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraints:@[imageTop, imageLeft, imageBottom, imageCenterY]];
        
        NSLayoutConstraint *labelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.space];
        NSLayoutConstraint *labelRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *labelBottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[labelTop, labelLeft, labelRight, labelCenterY, labelBottom]];
        
        self.spaceConstraint = labelLeft;
    } else if (self.buttonType == SJButtonTypeHorizontalTitleImage) {
        NSLayoutConstraint *labelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *labelBottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraints:@[labelTop, labelLeft, labelBottom, labelCenterY]];
        
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *imageLeft = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.space];
        NSLayoutConstraint *imageRight = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *imageCenterY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *imageBottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[imageTop, imageLeft, imageRight, imageCenterY, imageBottom]];
        
        self.spaceConstraint = imageLeft;
    }
    
    NSLayoutConstraint *contentCenterX = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *contentCenterY = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *contentTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *contentLeft = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *contentRight = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *contentBottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraints:@[contentCenterX, contentCenterY, contentTop, contentLeft, contentRight, contentBottom]];
}

- (void)addTarget:(id)target action:(SEL)action {
    [super addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - set

- (void)setTitle:(NSString *)title forState:(SJControlState)state {
    [self.titleDic setObject:title forKey:@(state)];
   
    if (state == SJControlStateNormal) {
        self.titleLabel.text = title;
        self.originTitle = title;
    }
}

- (void)setImage:(UIImage *)image forState:(SJControlState)state {
    [self.imageDic setObject:image forKey:@(state)];
    
    if (state == SJControlStateNormal) {
        self.imageView.image = image;
        self.originImage = image;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(SJControlState)state {
    [self.titleColorDic setObject:color forKey:@(state)];
    
    if (state == SJControlStateNormal) {
        self.titleLabel.textColor = color;
        self.originTitleColor = color;
    }
}

- (void)setBackgroundColor:(UIColor *)color forState:(SJControlState)state {
    [self.backgroundColorDic setObject:color forKey:@(state)];
    
    if (state == SJControlStateNormal) {
        self.backgroundColor = color;
        self.originBackgroundColor = color;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLabel.font = font;
}

- (void)setImageTintColor:(UIColor *)imageTintColor {
    _imageTintColor = imageTintColor;
    
    self.imageView.tintColor = imageTintColor;
    self.originImageTintColor =  imageTintColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected == YES) {
        [self setButtonSelectedDisplay];
    } else {
        [self resetButton];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled == NO) {
        [self setUnenabledButton];
    } else {
        [self resetButton];
    }
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    
    self.spaceConstraint.constant = space;
    [self setNeedsLayout];
}

#pragma mark - tracking
- (void)setNotNeedTheTrackingEffect:(BOOL)notNeedTheTrackingEffect {
    
    _notNeedTheTrackingEffect = notNeedTheTrackingEffect;
}
// tracking 按压
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    [self recordButtonCurrentDisplay];
    if (!_notNeedTheTrackingEffect) {
        
        [self setButtonHighlightedDisplay];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    if (self.isSelected) {
        [self setButtonSelectedDisplay];
    } else {
       [self resetButton];
    }
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    [self resetButton];
}

- (void)recordButtonCurrentDisplay {
    if (!self.selected) {
        self.originBackgroundColor = self.backgroundColor;
        self.originTitleColor = self.titleLabel.textColor;
        self.originImage = self.imageView.image;
        self.originTitle = self.titleLabel.text;
    }
}

- (void)setButtonHighlightedDisplay {
    SJControlState state = SJControlStateHighlighted;
    UIColor *backgroundColor = self.backgroundColorDic[@(state)];
    UIColor *titleColor = self.titleColorDic[@(state)];
    NSString *title = self.titleDic[@(state)];
    UIImage *image = self.imageDic[@(state)];
    self.backgroundColor = backgroundColor? backgroundColor : HEX(0xF5F5F5);
    self.titleLabel.textColor = titleColor? titleColor : [UIColor lightGrayColor];
    if (title) self.titleLabel.text = title;
    if (image) self.imageView.image = image;
}

- (void)setButtonSelectedDisplay {
    SJControlState state = SJControlStateSelected;
    UIColor *backgroundColor = self.backgroundColorDic[@(state)];
    UIColor *titleColor = self.titleColorDic[@(state)];
    NSString *title = self.titleDic[@(state)];
    UIImage *image = self.imageDic[@(state)];
    if (backgroundColor) self.backgroundColor = backgroundColor;
    self.backgroundColor = backgroundColor? backgroundColor : self.originBackgroundColor;
    self.titleLabel.textColor = titleColor? titleColor : self.originTitleColor;
    self.titleLabel.text = title? title : self.originTitle;
    self.imageView.image = image? image : self.originImage;
}

- (void)resetButton {
    self.backgroundColor = self.originBackgroundColor;
    self.titleLabel.textColor = self.originTitleColor;
    self.titleLabel.text = self.originTitle;
    self.imageView.image = self.originImage;
    self.imageView.tintColor = self.originImageTintColor;
}

- (void)setUnenabledButton {
    self.backgroundColor = HEX(0xF5F5F5);
    self.titleLabel.textColor = HEX(0xCCCCCC);
    self.titleLabel.text = self.originTitle;
    self.imageView.image = self.originImage;
    self.imageView.tintColor = HEX(0xCCCCCC);
}

- (void)setImageViewW:(CGFloat)imageViewW {
    
    _imageViewW = imageViewW;
    
    self.imageView.width = imageViewW;
    
}

- (void)setImageViewH:(CGFloat)imageViewH {
    
    _imageViewH = imageViewH;
    self.imageView.height = _imageViewH;
}

@end
