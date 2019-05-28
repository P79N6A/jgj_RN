//
//  JGJAttendanceTemplateCell.m
//  mix
//
//  Created by Tony on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAttendanceTemplateCell.h"

@interface JGJAttendanceTemplateCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *choiceBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation JGJAttendanceTemplateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.choiceBtn];
    [self.contentView addSubview:self.line];
    
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGSize titleSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) content:@"上班标准" font:15];
    _title.sd_layout.leftSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).heightIs(15).widthIs(titleSize.width);
    _content.sd_layout.leftSpaceToView(_title, 10).centerYEqualToView(self.contentView).heightIs(20);
    _choiceBtn.sd_layout.rightSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).heightIs(13);
    _line.sd_layout.leftSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, 20).bottomSpaceToView(self.contentView, 0).heightIs(1);
}

- (void)setCellTag:(NSInteger)cellTag {
    
    _cellTag = cellTag;
    if (_cellTag == 0) {
        
        _content.sd_layout.rightSpaceToView(self.contentView, 20);
        _choiceBtn.sd_layout.widthIs(0);
        _content.textColor = [UIColor blackColor];
        
    }else {
        
        _content.sd_layout.rightSpaceToView(self.contentView, 35);
        _choiceBtn.sd_layout.widthIs(8);
        _content.textColor = AppFontEB4E4EColor;
        if (_cellTag == 1) {
            
//            _content.text = @"8个小时算个工";
            
        }else if (_cellTag == 2) {
            
//            _content.text = @"6个小时算个工";
            _line.hidden = YES;
            
        }else {
            
//            _content.text = @"";
        }
    }
}

- (void)setTitleArr:(NSArray *)titleArr {
    
    _titleArr = titleArr;
    if (_cellTag == 0) {
        
        _title.text = _titleArr[0];
        
    }else if (_cellTag == 1){
        
        _title.text = _titleArr[1];
        
    }else {
        
        _title.text = _titleArr[2];
        
    }
}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {
    
    _yzgGetBillModel = yzgGetBillModel;
    
    if (_cellTag == 0) {
        
        _content.text = _yzgGetBillModel.name;
        
    }else if (_cellTag == 1) {
        
        if (_yzgGetBillModel.unit_quan_tpl.w_h_tpl > 0) {
            
            _content.text = [[NSString stringWithFormat:@"%.1f小时算1个工",_yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else {
            
            _content.text = @"8小时算个工";
        }
        
    }else {
        
        if (_yzgGetBillModel.unit_quan_tpl.o_h_tpl > 0) {
            
            _content.text = [[NSString stringWithFormat:@"%.1f小时算1个工",_yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else {
            
            _content.text = @"6小时算个工";
        }
    }
}

- (UILabel *)title {
    
    if (!_title) {
        
        _title = [[UILabel alloc] init];
        _title.font = FONT(15);
    }
    return _title;
}

- (UILabel *)content {
    
    if (!_content) {
        
        _content = [[UILabel alloc] init];
        _content.textAlignment = NSTextAlignmentRight;
        _content.font = FONT(15);
    }
    return _content;
}

- (UIButton *)choiceBtn {
    
    if (!_choiceBtn) {
        
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBtn setImage:IMAGE(@"arrow_right") forState:UIControlStateNormal];
        _choiceBtn.userInteractionEnabled = NO;
    }
    return _choiceBtn;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}
@end
