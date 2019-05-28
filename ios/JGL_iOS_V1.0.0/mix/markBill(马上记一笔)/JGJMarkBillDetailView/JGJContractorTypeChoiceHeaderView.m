//
//  JGJContractorTypeChoiceHeaderView.m
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContractorTypeChoiceHeaderView.h"

#import "UIView+GNUtil.h"

@interface JGJContractorTypeChoiceHeaderView ()
{
    
    BOOL _isChangeImage;
}

@property (nonatomic, strong) JGJNoHighlightedBtn *attendanceType;
@property (nonatomic, strong) JGJNoHighlightedBtn *accountType;

@end
@implementation JGJContractorTypeChoiceHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self initializeAppearance];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_isChangeImage) {
        
        if (self.frame.size.width != 0) {
            
//            _attendanceType.sd_layout.widthIs(self.frame.size.width / 2);
//            _accountType.sd_layout.widthIs(self.frame.size.width / 2);
            
            _attendanceType.frame = CGRectMake(0, 0, self.frame.size.width/ 2, 35);
            _accountType.frame = CGRectMake(self.frame.size.width/ 2, 0, self.frame.size.width/ 2, 35);
            //_attendanceType 单边圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attendanceType.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5,5)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _attendanceType.bounds;
            maskLayer.path = maskPath.CGPath;
            _attendanceType.layer.mask = maskLayer;
            
            //_accountType 单边圆角
            UIBezierPath *accountTypeMaskPath = [UIBezierPath bezierPathWithRoundedRect:_accountType.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
            CAShapeLayer *accountTypeMaskLayer = [[CAShapeLayer alloc] init];
            accountTypeMaskLayer.frame = _accountType.bounds;
            accountTypeMaskLayer.path = accountTypeMaskPath.CGPath;
            _accountType.layer.mask = accountTypeMaskLayer;
            
        }
    }else {
        
        if (self.frame.size.width != 0) {
            
//            _attendanceType.sd_layout.widthIs(self.frame.size.width / 2);
//            _accountType.sd_layout.widthIs(self.frame.size.width / 2);

            _attendanceType.frame = CGRectMake(0, 0, self.frame.size.width/ 2, 35);
            _accountType.frame = CGRectMake(self.frame.size.width/ 2, 0, self.frame.size.width/ 2, 35);
            //_attendanceType 单边圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attendanceType.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(37.5,37.5)];//圆角大小
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _attendanceType.bounds;
            maskLayer.path = maskPath.CGPath;
            _attendanceType.layer.mask = maskLayer;
            
            //_accountType 单边圆角
            UIBezierPath *accountTypeMaskPath = [UIBezierPath bezierPathWithRoundedRect:_accountType.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(37.5,37.5)];//圆角大小
            CAShapeLayer *accountTypeMaskLayer = [[CAShapeLayer alloc] init];
            accountTypeMaskLayer.frame = _accountType.bounds;
            accountTypeMaskLayer.path = accountTypeMaskPath.CGPath;
            _accountType.layer.mask = accountTypeMaskLayer;
            
        }
    }
    
    
}

- (void)setCornerRad:(CGFloat)cornerRad {
    
    _cornerRad = cornerRad;

    
}

- (void)initializeAppearance {
    
    [self addSubview:self.attendanceType];
    [self addSubview:self.accountType];
//    [self setUpLayout];
    
    
}

- (void)setUpLayout {
    
//    _attendanceType.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0);
//    _accountType.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0);
    
}

- (void)setBtTileArr:(NSArray *)btTileArr {
    
    _btTileArr = btTileArr;
    [_attendanceType setTitle:_btTileArr[0] forState:UIControlStateNormal];
    [_accountType setTitle:_btTileArr[1] forState:UIControlStateNormal];
}

- (void)changeleftBtnWithNormalImage:(NSString *)leftNormalStr leftSelectedImage:(NSString *)leftSelectedImage rightNormalImage:(NSString *)rightNormalImage rightSelectedImage:(NSString *)rightSelectedImage {
    
    
    [_attendanceType setBackgroundImage:IMAGE(leftNormalStr) forState:UIControlStateNormal];
    [_attendanceType setBackgroundImage:IMAGE(leftSelectedImage) forState:UIControlStateSelected];
    
    
    [_accountType setBackgroundImage:IMAGE(rightNormalImage) forState:UIControlStateNormal];
    [_accountType setBackgroundImage:IMAGE(rightSelectedImage) forState:UIControlStateSelected];
    
    
    
    _isChangeImage = YES;
}


- (JGJNoHighlightedBtn *)attendanceType {
    
    if (!_attendanceType) {
        
        _attendanceType = [JGJNoHighlightedBtn buttonWithType:UIButtonTypeCustom];
        [_attendanceType setBackgroundImage:IMAGE(@"attendanceTypeUnSelected") forState:UIControlStateNormal];
        [_attendanceType setBackgroundImage:IMAGE(@"attendanceTypeSelected") forState:UIControlStateSelected];

        [_attendanceType setTitle:@"包工记工天" forState:UIControlStateNormal];
        [_attendanceType setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        [_attendanceType setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _attendanceType.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _attendanceType.clipsToBounds = YES;
        _attendanceType.tag = 100;
        _attendanceType.selected = YES;
        [_attendanceType setAdjustsImageWhenHighlighted:NO];
        [_attendanceType addTarget:self action:@selector(contractorTypeChoice:) forControlEvents:UIControlEventTouchUpInside];
   
    }
    return _attendanceType;
}

- (JGJNoHighlightedBtn *)accountType {
    
    if (!_accountType) {
        
        _accountType = [JGJNoHighlightedBtn buttonWithType:UIButtonTypeCustom];
        
        [_accountType setBackgroundImage:IMAGE(@"accountsTypeUnSelected") forState:UIControlStateNormal];
        [_accountType setBackgroundImage:IMAGE(@"accountsTypeSelected") forState:UIControlStateSelected];

        [_accountType setTitle:@"包工记账" forState:UIControlStateNormal];
        [_accountType setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        [_accountType setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _accountType.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _accountType.clipsToBounds = YES;
        _accountType.tag = 101;
        [_accountType setAdjustsImageWhenHighlighted:NO];
        [_accountType addTarget:self action:@selector(contractorTypeChoice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountType;
}


- (void)contractorTypeChoice:(UIButton *)sender {
    
    if (sender.tag == 100) {
        
        _accountType.selected = NO;
        
        if (_attendanceType.selected == YES) {
            
            return;
            
        }else {
            
            _attendanceType.selected = YES;
        }
    }else {
        
        _attendanceType.selected = NO;
        
        if (_accountType.selected == YES) {
            
            return;
            
        }else {
            
            _accountType.selected = YES;
        }
    }

    if ([self.delegate respondsToSelector:@selector(contractorHeaderSelectedWithType:)]) {
        
        [_delegate contractorHeaderSelectedWithType:sender.tag - 100];
    }
    
    if (self.contractorHeaderBlcok) {

        _contractorHeaderBlcok(sender.tag - 100);
    }
    
}

- (void)setSelType:(JGJRecordSelBtnType)selType {
    
    _selType = selType;
    
    if (_selType == JGJRecordSelLeftBtnType) {
        
        self.attendanceType.selected = YES;
        self.accountType.selected = NO;
        
    }else if (_selType == JGJRecordSelRightBtnType) {
        
        self.attendanceType.selected = NO;
        self.accountType.selected = YES;
    }
    
}

@end
