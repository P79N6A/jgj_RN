//
//  JGJChoiceTheCurrentAddressCell.m
//  mix
//
//  Created by Tony on 2018/3/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChoiceTheCurrentAddressCell.h"
#import "JGJCustomLable.h"

@interface JGJChoiceTheCurrentAddressCell ()

@property (nonatomic, strong) JGJCustomLable *topLabel;// 所在位置文字label
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *refreshLocationImageView;// 重新定位图标
@property (nonatomic, strong) UIButton *refreshLocationBtn;// 重新定位按钮
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) JGJCoreTextLable *currentLocation;// 显示所在位置
@property (nonatomic, strong) UIButton *choiceCurrentLocationBtn;// 选择所在位置事件
@property (nonatomic, strong) UIButton *touchTheCellToChoiceLocation;

@end
@implementation JGJChoiceTheCurrentAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.refreshLocationBtn];
    [self.backView addSubview:self.refreshLocationImageView];
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.currentLocation];
    [self.contentView addSubview:self.choiceCurrentLocationBtn];
    [self.contentView addSubview:self.touchTheCellToChoiceLocation];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _topLabel.sd_layout.rightSpaceToView(self.contentView, 104).heightIs(37.5).leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0);
    _backView.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).heightIs(37.5).widthIs(104);
    _refreshLocationBtn.sd_layout.rightSpaceToView(_backView, 12).centerYEqualToView(_backView).heightIs(15).widthIs(70);
    _refreshLocationImageView.sd_layout.rightSpaceToView(_refreshLocationBtn, 5).widthIs(14).heightIs(17).centerYEqualToView(_refreshLocationBtn);
    
    _currentLocation.sd_layout.leftSpaceToView(self.contentView, 42).rightSpaceToView(self.contentView, 40).topSpaceToView(_topLabel, 0).bottomSpaceToView(self.contentView, 0);
    _locationImageView.sd_layout.leftSpaceToView(self.contentView, 18).widthIs(14).heightIs(17).centerYEqualToView(_currentLocation);
    _choiceCurrentLocationBtn.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(_locationImageView).widthIs(9).heightIs(15);
    _touchTheCellToChoiceLocation.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(_topLabel, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    
}
#pragma mark - mothod
- (void)touchCellToChoiceLocal {
    
    if ([self respondsToSelector:@selector(theCurrentAddress)]) {
        
        _theCurrentAddress();
    }
}

- (void)setTheCurrentLocationStr:(NSString *)theCurrentLocationStr {
    
    _theCurrentLocationStr = theCurrentLocationStr;
    _currentLocation.text = _theCurrentLocationStr;
}

- (void)setIsEidteBuilderDaily:(BOOL)isEidteBuilderDaily {
    
    _isEidteBuilderDaily = isEidteBuilderDaily;
    if (_isEidteBuilderDaily) {
        
        self.refreshLocationImageView.hidden = YES;
        self.refreshLocationBtn.hidden = YES;
        self.choiceCurrentLocationBtn.hidden = YES;
        self.userInteractionEnabled = NO;
    }else {
        
        self.refreshLocationImageView.hidden = NO;
        self.refreshLocationBtn.hidden = NO;
        self.choiceCurrentLocationBtn.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}
// 重新定位
- (void)refreshLocation {
    
    if ([self respondsToSelector:@selector(refreshCurLocation)]) {
        
        _refreshCurLocation();
    }
}
#pragma mark - setter
- (JGJCustomLable *)topLabel {
    
    if (!_topLabel) {
        
        _topLabel = [[JGJCustomLable alloc] init];
        _topLabel.backgroundColor = AppFontf1f1f1Color;
        _topLabel.textColor = AppFont333333Color;
        _topLabel.text = @"   所在位置";
        _topLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        
    }
    return _topLabel;
}

- (UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = AppFontf1f1f1Color;
    }
    return _backView;
}

- (UIImageView *)refreshLocationImageView {
    
    if (!_refreshLocationImageView) {
        
        _refreshLocationImageView = [[UIImageView alloc] init];
        _refreshLocationImageView.image = IMAGE(@"add_Userlocation_black");
    }
    return _refreshLocationImageView;
}

- (UIButton *)refreshLocationBtn {
    
    if (!_refreshLocationBtn) {
        
        _refreshLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshLocationBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
        [_refreshLocationBtn setTitle:@"重新定位" forState:UIControlStateNormal];
        _refreshLocationBtn.titleLabel.font = FONT(AppFont30Size);
        [_refreshLocationBtn addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshLocationBtn;
}

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = IMAGE(@"add_Userlocation");
    }
    return _locationImageView;
}

- (JGJCoreTextLable *)currentLocation {
    
    if (!_currentLocation) {
        
        _currentLocation = [[JGJCoreTextLable alloc] init];
        _currentLocation.text = @"请选择所在位置";
        _currentLocation.font = FONT(AppFont30Size);
        _currentLocation.backgroundColor = [UIColor clearColor];
        _currentLocation.textColor = TYColorHex(0X333333);
        _currentLocation.numberOfLines = 0;
    }
    return _currentLocation;
}

- (UIButton *)choiceCurrentLocationBtn {
    
    if (!_choiceCurrentLocationBtn) {
        
        _choiceCurrentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_choiceCurrentLocationBtn setImage:IMAGE(@"icon_arrow_right2") forState:UIControlStateNormal];
        [_choiceCurrentLocationBtn setBackgroundImage:IMAGE(@"arrow_right") forState:UIControlStateNormal];
    }
    return _choiceCurrentLocationBtn;
}

- (UIButton *)touchTheCellToChoiceLocation {
    
    if (!_touchTheCellToChoiceLocation) {
        
        _touchTheCellToChoiceLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchTheCellToChoiceLocation.backgroundColor = [UIColor clearColor];
        [_touchTheCellToChoiceLocation addTarget:self action:@selector(touchCellToChoiceLocal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchTheCellToChoiceLocation;
}

@end
