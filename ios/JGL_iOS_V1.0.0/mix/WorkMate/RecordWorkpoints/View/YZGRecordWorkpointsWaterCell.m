//
//  YZGRecordWorkpointsWaterCell.m
//  mix
//
//  Created by celion on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkpointsWaterCell.h"

#import "NSString+Extend.h"
#import "CALayer+SetLayer.h"

@implementation YZGRecordWorkpointsWaterCell

- (void)awakeFromNib {
    // Initialization code
    
    _selectImageView_leading.constant = HorizontalSpace(30);
    _view1_leading.constant = HorizontalSpace(30);
    _dateLabel_top.constant = VerticalSpace(31);
    _date_turnLabel_top.constant = VerticalSpace(8);
    _date_turnLabel_bottom.constant = VerticalSpace(31);
    _nameLabel_top.constant = VerticalSpace(30);
    _pro_nameLabel_top.constant = VerticalSpace(10);
    _amounts_diffLabel_trailing.constant = HorizontalSpace(30);
    _amountsLabel_trailing.constant = HorizontalSpace(30);
    _accounts_typeLabel_top.constant = VerticalSpace(30);
    _overtimeLabel_top.constant = VerticalSpace(10);
    _view3_trailing.constant = HorizontalSpace(0);
    _separator_height.constant = VerticalSpace(1);
    
    _dateLabel.font = [UIFont systemFontOfSize:FONT_SIZE(24)];
    _date_turnLabel.font = [UIFont systemFontOfSize:FONT_SIZE(18)];
    _nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE(30)];
    _pro_nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE(18)];
    _amounts_diffLabel.font = [UIFont systemFontOfSize:FONT_SIZE(18)];
    _amountsLabel.font = [UIFont systemFontOfSize:FONT_SIZE(30)];
    _accounts_typeLabel.font = [UIFont systemFontOfSize:FONT_SIZE(30)];
    _overtimeLabel.font = [UIFont systemFontOfSize:FONT_SIZE(18)];
    
    _amounts_diffLabel.text = @"有\n差\n账";
    [_amounts_diffLabel.layer setLayerBorderWithColor:_amounts_diffLabel.textColor width:1.0 / 2.0 radius:4.0 / 2.0];
    
    _isEditing = NO;
//    _isSelected = NO;
    _selectState = [NSNumber numberWithBool:NO];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    _date_turnLabel.layer.cornerRadius = 4.0 / 2.0;
    _date_turnLabel.layer.masksToBounds = YES;
}

- (void)setCellData:(id)data atIndexPath:(NSIndexPath *)indexPath count:(NSUInteger)count isEditing:(BOOL)isEditing selectState:(NSNumber *)selectState
{
//    if (!data)
//    {
//        return;
//    }
    
    WorkdayModel *model = (WorkdayModel *)data;
    
    _model = model;
    
    _todayFlagView.hidden = !(model.date == [[NSString stringFromDate:[NSDate date] withDateFormat:@"yyyyMMdd"] integerValue]);
    
    if (model.date == [[NSString stringFromDate:[NSDate date] withDateFormat:@"yyyyMMdd"] integerValue])
    {
        _dateLabel.text = @"今天";
    }
    else
    {
        _dateLabel.text = [NSString stringWithDateFormat:@"d日" fromString:[NSString stringWithFormat:@"%ld",model.date] withDateFormat:@"yyyyMMdd"];
    }
    
    _date_turnLabel.text = model.date_turn;
    
    _nameLabel.text = model.name;
    
    _pro_nameLabel.text = model.pro_name;
    
    _amounts_diffLabel.hidden = !(model.amounts_diff);
    
    if (model.accounts_type.code == 3)//借支
    {
        _amountsLabel.textColor = ColorHex(0x83c76e);
        _amountsLabel.text = [NSString stringWithFormat:@"¥-%.2f",model.amounts];
    }
    else
    {
        _amountsLabel.textColor = ColorHex(0xf75a23);
        _amountsLabel.text = [NSString stringWithFormat:@"¥%.2f",model.amounts];
    }
    
    if (model.accounts_type.code == 1)//点工
    {
        _accounts_typeLabel.text = model.manhour;
        _overtimeLabel.hidden = NO;
        _overtimeLabel.text = model.overtime;
    }
    else if (model.accounts_type.code == 2)//包工
    {
        if ([NSString isEmpty:model.sub_pro_name])
        {
            _accounts_typeLabel.text = model.accounts_type.txt;
        }
        else
        {
            _accounts_typeLabel.text = model.sub_pro_name;
        }
        _overtimeLabel.hidden = YES;
        _overtimeLabel.text = @"";
    }
    else
    {
        _accounts_typeLabel.text = model.accounts_type.txt;//借支
        _overtimeLabel.hidden = YES;
        _overtimeLabel.text = @"";
    }
    
    if (indexPath.row == 0)
    {
        _view1.hidden = NO;
    }
    else
    {
        _view1.hidden = YES;
    }
    
    _selectState = selectState;
    
    if (isEditing)
    {
        _selectImageView.hidden = NO;
        
        if ([selectState boolValue])
        {
            _selectImageView.image = [UIImage imageNamed:@"selected"];
        }
        else
        {
            _selectImageView.image = [UIImage imageNamed:@"not_selected"];
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            _view1_leading.constant = HorizontalSpace(110);
            
            if (indexPath.row == count - 1)
            {
                _separator_leading.constant = 0;
            }
            else
            {
                _separator_leading.constant = HorizontalSpace(224);
            }
            
            if (_isEditing != isEditing)
            {
                _isEditing = isEditing;
                
                [_view1 layoutIfNeeded];
                [_separator layoutIfNeeded];
            }
            else
            {
                
            }
        }];
    }
    else
    {
        _selectImageView.hidden = YES;
        
        _selectImageView.image = [UIImage imageNamed:@"not_selected"];
        
        [UIView animateWithDuration:0.1 animations:^{
            _view1_leading.constant = HorizontalSpace(30);
            
            if (indexPath.row == count - 1)
            {
                _separator_leading.constant = 0;
            }
            else
            {
                _separator_leading.constant = HorizontalSpace(144);
            }
            
            if (_isEditing != isEditing)
            {
                _isEditing = isEditing;
                
                [_view1 layoutIfNeeded];
                [_separator layoutIfNeeded];
            }
            else
            {
                
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
