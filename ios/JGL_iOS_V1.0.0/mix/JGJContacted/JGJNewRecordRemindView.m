//
//  JGJNewRecordRemindView.m
//  mix
//
//  Created by Tony on 2018/11/23.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJNewRecordRemindView.h"
#import "NSString+Extend.h"
@interface JGJNewRecordRemindView ()

@property (nonatomic, strong) UILabel *remindLabel;

@end
@implementation JGJNewRecordRemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.remindLabel];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 12) content:_remindLabel.text font:AppFont24Size];
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(size.width + 50);
    }];

}


- (UILabel *)remindLabel {
    
    if (!_remindLabel) {
        
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.font = FONT(AppFont24Size);
        _remindLabel.textColor = AppFont333333Color;
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.text = @"在吉工家记工 数据永远不会丢失";
    }
    return _remindLabel;
}



@end
