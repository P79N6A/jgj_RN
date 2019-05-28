//
//  JGJRecordWorkpointsChangeListTimeCell.m
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsChangeListTimeCell.h"
#import "NSString+Extend.h"
@interface JGJRecordWorkpointsChangeListTimeCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@end
@implementation JGJRecordWorkpointsChangeListTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = AppFontf1f1f1Color;
        [self initializeAppearance];
    }
    
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.timeLabel];
    [self setUpLayout];
    
    [self.timeLabel layoutSubviews];
    _timeLabel.layer.cornerRadius = 5;
}

- (void)setUpLayout {

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(20);
        make.center.equalTo(self.contentView).offset(0);
    }];
}

- (void)setChangeInfoModel:(JGJRecordWorkpointsChangeModel *)changeInfoModel {
    
    _changeInfoModel = changeInfoModel;
    _timeLabel.text = _changeInfoModel.create_time;
    
    CGSize timeSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 20) content:_timeLabel.text font:AppFont28Size];
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(timeSize.width + 10);
    }];
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = AppFontffffffColor;
        _timeLabel.backgroundColor = AppFontc7c7c7Color;
        _timeLabel.font = FONT(AppFont28Size);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        _timeLabel.clipsToBounds = YES;
    }
    return _timeLabel;
}

@end
