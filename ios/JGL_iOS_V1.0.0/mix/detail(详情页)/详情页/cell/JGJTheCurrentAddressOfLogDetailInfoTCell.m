//
//  JGJTheCurrentAddressOfLogDetailInfoTCell.m
//  mix
//
//  Created by Tony on 2018/3/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTheCurrentAddressOfLogDetailInfoTCell.h"

@interface JGJTheCurrentAddressOfLogDetailInfoTCell ()

@property (nonatomic, strong) UILabel *currentAddressLabel;// 所在位置标题
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressInfo;// 地址详情
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJTheCurrentAddressOfLogDetailInfoTCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [self initializeAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}
- (void)initializeAppearance {
    
    [self.contentView addSubview:self.currentAddressLabel];
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.addressInfo];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _currentAddressLabel.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 15).heightIs(15).widthIs(100);
    _addressInfo.sd_layout.leftSpaceToView(self.contentView, 30).topSpaceToView(_currentAddressLabel, 15).rightSpaceToView(self.contentView, 35).heightIs(20);
    _locationImageView.sd_layout.leftEqualToView(_currentAddressLabel).widthIs(14).heightIs(18).centerYEqualToView(self.addressInfo);
    _bottomLine.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).heightIs(1).bottomSpaceToView(self.contentView, 0);
    
}

- (void)setLocationJsonStr:(NSString *)locationJsonStr {
    
    _locationJsonStr = locationJsonStr;
    NSDictionary *locationDic = (NSDictionary *)[locationJsonStr mj_JSONObject];
    self.addressInfo.text = [NSString stringWithFormat:@"%@%@",locationDic[@"address"]?:@"",locationDic[@"name"]?:@""];
    CGFloat height = [NSString getContentHeightWithString:self.addressInfo.text maxWidth:TYGetUIScreenWidth - 65];
    if (height <= 20) {
        
        self.addressInfo.sd_layout.heightIs(20);
        
    }else {
        
        self.addressInfo.sd_layout.heightIs(height);
    }
    [self.addressInfo updateLayout];
    [self.contentView setupAutoHeightWithBottomView:_addressInfo bottomMargin:15];
}

- (UILabel *)currentAddressLabel {
    
    if (!_currentAddressLabel) {
        
        _currentAddressLabel = [[UILabel alloc] init];
        _currentAddressLabel.font = FONT(AppFont30Size);
        _currentAddressLabel.text = @"所在位置:";
        _currentAddressLabel.textColor = AppFontLight333333Color;
    }
    return _currentAddressLabel;
}

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = IMAGE(@"add_Userlocation");
    }
    return _locationImageView;
}

- (UILabel *)addressInfo {
    
    if (!_addressInfo) {
        
        _addressInfo = [[UILabel alloc] init];
        _addressInfo.textColor = AppFont333333Color;
        _addressInfo.font = FONT(AppFont30Size);
        _addressInfo.numberOfLines = 0;
        _addressInfo.text = @" ";
    }
    return _addressInfo;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = TYColorHex(0XF1F1F1);
    }
    return _bottomLine;
}
@end
