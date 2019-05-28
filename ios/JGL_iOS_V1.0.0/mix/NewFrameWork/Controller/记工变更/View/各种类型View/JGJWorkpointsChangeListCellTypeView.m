//
//  JGJBillTinyOrBillContractWorkpointsChangeView.m
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWorkpointsChangeListCellTypeView.h"
#import "UILabel+GNUtil.h"
@interface JGJWorkpointsChangeListCellTypeView ()

@property (nonatomic, strong) UILabel *timeLabel;// 时间
@property (nonatomic, strong) UIImageView *typeImage;// 类型图片
@property (nonatomic, strong) UILabel *nameLabel;// 被记账名称
@property (nonatomic, strong) UILabel *typeInfoLabel;// 上班时间
@property (nonatomic, strong) UILabel *moneyLabel;// 工资
@property (nonatomic, strong) UIImageView *moreImg;// 更多表标识
@property (nonatomic, strong) UILabel *projectLabel;// 项目名称
@property (nonatomic, strong) UILabel *groupMonitorLabel;// 班组长
@property (nonatomic, strong) UILabel *editeInfo;// 由谁修改信息
@end
@implementation JGJWorkpointsChangeListCellTypeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    
        [self initializeAppearance];
        
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.typeImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.typeInfoLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.moreImg];
    [self addSubview:self.groupMonitorLabel];
    [self addSubview:self.projectLabel];
    [self addSubview:self.editeInfo];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.height.mas_equalTo(15);
        make.top.mas_equalTo(8);
    }];
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.top.equalTo(_timeLabel.mas_bottom).offset(17);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(14);
    }];
    
    [_typeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_typeImage.mas_centerY).offset(0);
        make.centerX.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_typeImage.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(_typeInfoLabel.mas_left).offset(-5);
        make.centerY.equalTo(_typeImage.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
        
    }];
    
    
    [_moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_typeImage.mas_centerY).offset(0);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(14);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-30);
        make.centerY.equalTo(_moreImg.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [_groupMonitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_moreImg.mas_left).offset(0);
        make.top.equalTo(_typeInfoLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(15);
        
    }];
    
    [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_typeInfoLabel.mas_left).offset(0);
        make.centerY.equalTo(_groupMonitorLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(_groupMonitorLabel.mas_left).offset(-5);
    }];
    
    [_editeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_typeImage.mas_left).offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
}

- (void)setChangeInfoModel:(JGJRecordWorkpointsChangeModel *)changeInfoModel {
    
    _changeInfoModel = changeInfoModel;
    _timeLabel.text = [NSString stringWithFormat:@"%@(%@)",_changeInfoModel.record_time,_changeInfoModel.nl_date];
    
    // 图标
    if ([_changeInfoModel.record_info.accounts_type integerValue] == 1) {
        
        [_typeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(14);
        }];
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_typeImage.mas_right).offset(5);
        }];
        
        _typeImage.image = IMAGE(@"work_type_icon");
        
    }else if ([_changeInfoModel.record_info.accounts_type integerValue] == 5) {
        
        [_typeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(14);
        }];
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_typeImage.mas_right).offset(5);
        }];
        
        _typeImage.image = IMAGE(@"contract_type_icon");
        
    }else {
        
        [_typeImage mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_equalTo(0);
        }];
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_typeImage.mas_right).offset(0);
        }];
    }
    
    // 名字
    _nameLabel.text = _changeInfoModel.record_info.worker_name;
    
    // 记账类型
    NSString *title = @"";
    if ([_changeInfoModel.record_info.accounts_type integerValue] == 1 || [_changeInfoModel.record_info.accounts_type integerValue] == 5) {// 点工 或 包工考勤
        
        NSString *working_hours = [_changeInfoModel.record_info.working_hours floatValue] > 0.0 ?[NSString stringWithFormat:@"%@个工",_changeInfoModel.record_info.working_hours] :@"休息";
        NSString *overtime_hours = [_changeInfoModel.record_info.overtime_hours floatValue] > 0.0 ? [NSString stringWithFormat:@"%@个工",_changeInfoModel.record_info.overtime_hours] : @"无加班";
        NSString *manhour = [_changeInfoModel.record_info.manhour floatValue] > 0.0 ? [NSString stringWithFormat:@"%@小时",_changeInfoModel.record_info.manhour] : @"休息";
        NSString *overtime = [_changeInfoModel.record_info.overtime floatValue] > 0 ? [NSString stringWithFormat:@"%@小时",_changeInfoModel.record_info.overtime] : @"无加班";
        if (self.selTypeModel.type == 0) {// 上班按工天、加班按小时
            
            title = [NSString stringWithFormat:@"上班: %@\n加班: %@",working_hours,overtime];
            
        }else if (self.selTypeModel.type == 1) {// 上班、加班按工天
            
            title = [NSString stringWithFormat:@"上班: %@\n加班: %@",working_hours,overtime_hours];
            
        }else if (self.selTypeModel.type == 2) {// 上班、加班按小时
            
            title = [NSString stringWithFormat:@"上班: %@\n加班: %@",manhour,overtime];
        }
        
        
        
        _moneyLabel.textColor = AppFontEB4E4EColor;
        
        
    }else if ([_changeInfoModel.record_info.accounts_type integerValue] == 2) {// 包工记账
        
        title = @"包工记账";
        _moneyLabel.textColor = AppFontEB4E4EColor;
        
    }else if ([_changeInfoModel.record_info.accounts_type integerValue] == 3) {// 借支
        
        title = @"借支";
        _moneyLabel.textColor = AppFont27B441Color;
        
    }else if ([_changeInfoModel.record_info.accounts_type integerValue] == 4) {// 结算
        
        title = @"结算";
        _moneyLabel.textColor = AppFont27B441Color;
    }
    
    _typeInfoLabel.text = title;
    // 金额
    _moneyLabel.text = _changeInfoModel.record_info.amounts;
    
    // 项目
    _projectLabel.text = _changeInfoModel.record_info.proname;
    
    // 是否是删除类型账
    if ([_changeInfoModel.record_type integerValue] == 3) {// 是删除类型
        
        _moreImg.hidden = YES;
        _editeInfo.hidden = NO;
        _editeInfo.text = _changeInfoModel.last_operate_msg;
        
    }else {
        
        _moreImg.hidden = NO;
        _editeInfo.hidden = YES;
        
    }
    
    // 班组长
    _groupMonitorLabel.text = [NSString stringWithFormat:@"班组长：%@",_changeInfoModel.record_info.foreman_name];
}

#pragma mark - property
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = AppFont666666Color;
        _timeLabel.font = FONT(AppFont26Size);
    }
    return _timeLabel;
}

- (UIImageView *)typeImage {
    
    if (!_typeImage) {

        _typeImage = [[UIImageView alloc] init];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
        _nameLabel.textColor = AppFont333333Color;
    }
    return _nameLabel;
}

- (UILabel *)typeInfoLabel {
    
    if (!_typeInfoLabel) {
        
        _typeInfoLabel = [[UILabel alloc] init];
        _typeInfoLabel.textColor = AppFont333333Color;
        _typeInfoLabel.font = FONT(AppFont24Size);
        _typeInfoLabel.numberOfLines = 0;
        [_typeInfoLabel setAttributedText:_typeInfoLabel.text lineSapcing:4];
        
    }
    return _typeInfoLabel;
}

- (UILabel *)moneyLabel {
    
    if (!_moneyLabel) {
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UIImageView *)moreImg {
    
    if (!_moreImg) {
        
        _moreImg = [[UIImageView alloc] init];
        _moreImg.image = IMAGE(@"arrow_right");
        _moreImg.contentMode = UIViewContentModeCenter;
    }
    return _moreImg;
}

- (UILabel *)projectLabel {
    
    if (!_projectLabel) {
        
        _projectLabel = [[UILabel alloc] init];
        _projectLabel.textColor = AppFont999999Color;
        _projectLabel.font = FONT(AppFont24Size);
    }
    return _projectLabel;
}

- (UILabel *)groupMonitorLabel {
    
    if (!_groupMonitorLabel) {
        
        _groupMonitorLabel = [[UILabel alloc] init];
        _groupMonitorLabel.textColor = AppFont999999Color;
        _groupMonitorLabel.font = FONT(AppFont24Size);
        _groupMonitorLabel.textAlignment = NSTextAlignmentRight;
    }
    return _groupMonitorLabel;
}

- (UILabel *)editeInfo {
    
    if (!_editeInfo) {
        
        _editeInfo = [[UILabel alloc] init];
        _editeInfo.font = FONT(AppFont24Size);
        _editeInfo.textColor = AppFontFF9900Color;
    }
    return _editeInfo;
}
@end
