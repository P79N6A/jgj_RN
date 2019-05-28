//
//  JGJOriginalPhoneNumberTopView.m
//  mix
//
//  Created by Tony on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJOriginalPhoneNumberTopView.h"
#import "UILabel+GNUtil.h"
@interface JGJOriginalPhoneNumberTopView ()

@property (nonatomic, strong) UILabel *phoneNumber;
@end
@implementation JGJOriginalPhoneNumberTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = AppFontEBEBEBColor;
    [self addSubview:self.phoneNumber];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _phoneNumber.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self, 10).centerYEqualToView(self).heightIs(28);
}

- (void)setPhoeNumberStr:(NSString *)phoeNumberStr {
    
    _phoeNumberStr = phoeNumberStr;
    
    self.phoneNumber.text = [NSString stringWithFormat:@"原手机号码 %@",_phoeNumberStr];
    [self.phoneNumber markText:@"原手机号码" withColor:AppFont666666Color];
}

- (UILabel *)phoneNumber {
    
    if (!_phoneNumber) {
        
        _phoneNumber = [[UILabel alloc] init];
        _phoneNumber.font = FONT(AppFont40Size);
        _phoneNumber.textAlignment = NSTextAlignmentCenter;
        _phoneNumber.textColor = AppFont030303Color;
    }
    return _phoneNumber;
}


@end
