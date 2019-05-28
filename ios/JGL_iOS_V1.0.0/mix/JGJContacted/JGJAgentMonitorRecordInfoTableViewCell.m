//
//  JGJAgentMonitorRecordInfoTableViewCell.m
//  mix
//
//  Created by Tony on 2018/7/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAgentMonitorRecordInfoTableViewCell.h"
#import "UILabel+GNUtil.h"
@interface JGJAgentMonitorRecordInfoTableViewCell ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *recordPersonName;
@property (nonatomic, strong) UILabel *recordTime;
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJAgentMonitorRecordInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.recordPersonName];
    [self.contentView addSubview:self.recordTime];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 10) content:@"记录人: 李代班" font:AppFont26Size];
    _topLine.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 0).heightIs(.5);
    _bottomLine.sd_layout.leftEqualToView(_topLine).bottomSpaceToView(self.contentView, 0).rightEqualToView(_topLine).heightIs(.5);
    _recordPersonName.sd_layout.leftEqualToView(_topLine).topSpaceToView(_topLine, 9).bottomSpaceToView(_bottomLine, 9).widthIs(size.width);
    _recordTime.sd_layout.leftSpaceToView(_recordPersonName, 20).centerYEqualToView(_recordPersonName).heightIs(10).rightEqualToView(_topLine);
    
}

- (void)setRecordName:(NSString *)recordName recordTime:(NSString *)recordTime {
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 10) content:[NSString stringWithFormat:@"记录人: %@",recordName] font:AppFont26Size];
    _recordPersonName.sd_layout.widthIs(size.width);
    self.recordPersonName.text = [NSString stringWithFormat:@"记录人: %@",recordName];
    _recordPersonName.textColor = AppFont000000Color;
    self.recordTime.text = [NSString stringWithFormat:@"记录时间: %@",recordTime];
    _recordTime.textColor = AppFont000000Color;
    
    if (![NSString isEmpty:recordName]) {
        
        [self.recordPersonName markText:@"记录人:" withColor:AppFont666666Color];
        [self.recordTime markText:@"记录时间:" withColor:AppFont666666Color];
    }
    
    
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
        
    }
    return _topLine;
}
- (UILabel *)recordPersonName {
    
    if (!_recordPersonName) {
        
        _recordPersonName = [[UILabel alloc] init];
        
        _recordPersonName.font = FONT(AppFont26Size);
    }
    return _recordPersonName;
}

- (UILabel *)recordTime {
    
    if (!_recordTime) {
        
        _recordTime = [[UILabel alloc] init];
        
        _recordTime.font = FONT(AppFont26Size);
        _recordTime.textAlignment = NSTextAlignmentRight;
    }
    return _recordTime;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontdbdbdbColor;
        
    }
    return _bottomLine;
}
@end
