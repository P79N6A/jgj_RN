//
//  JGJSendNotificationTopTitleCell.m
//  mix
//
//  Created by Tony on 2018/3/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSendNotificationTopTitleCell.h"

@interface JGJSendNotificationTopTitleCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *currentProjectName;

@end
@implementation JGJSendNotificationTopTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.currentProjectName];
    
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _backView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    _currentProjectName.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 0).heightIs(15);
}

- (void)setModel:(JGJMyWorkCircleProListModel *)model {
    
    _model = model;
    BOOL isTeam = [_model.class_type isEqualToString:@"team"];
    
    NSString *title = isTeam ? @"当前项目:":@"当前班组:";
    _currentProjectName.text = [NSString stringWithFormat:@"%@%@",title,_model.group_name?:@""];
//    self.locationTitleLabel.text = isTeam?@"当前项目:":@"当前班组:";
}

- (UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = TYColorHex(0xf1f1f1);
    }
    return _backView;
}

- (UILabel *)currentProjectName {
    
    if (!_currentProjectName) {
        
        _currentProjectName = [[UILabel alloc] init];
        _currentProjectName.textColor = TYColorHex(0x999999);
        _currentProjectName.font = FONT(12);
        _currentProjectName.textAlignment = NSTextAlignmentLeft;
        _currentProjectName.backgroundColor = [UIColor clearColor];
    }
    return _currentProjectName;
}

@end
