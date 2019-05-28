//
//  JGJNewMarkBillProjectListCell.m
//  mix
//
//  Created by Tony on 2018/6/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNewMarkBillProjectListCell.h"
#import "UIView+Extend.h"
#import "NSString+Extend.h"
@interface JGJNewMarkBillProjectListCell ()<UITextFieldDelegate>
{
    BOOL _isEditing;
    BOOL _isEqualProjectName;
    NSString *_projectEditeName;
}

@property (nonatomic, strong) UIImageView *choicedProject;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *isHaveTeamLabel;// 已有班组标签
@end
@implementation JGJNewMarkBillProjectListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.choicedProject];
    [self.contentView addSubview:self.contentField];
    [self.contentView addSubview:self.modifyBtn];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.saveBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.isHaveTeamLabel];
    [self setUpLayout];
    
    
    [_modifyBtn updateLayout];
    [_deleteBtn updateLayout];
    [_saveBtn updateLayout];
    
    _modifyBtn.layer.cornerRadius = 5;
    _deleteBtn.layer.cornerRadius = 5;
    _saveBtn.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.contentField];
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.contentField.maxLength];
    
}

- (void)setUpLayout {
    
    
    _choicedProject.sd_layout.rightSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(15).heightIs(15);
    
    _deleteBtn.sd_layout.widthIs(0).heightIs(26).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 15);
    
    _modifyBtn.sd_layout.widthIs(0).heightIs(26).centerYEqualToView(self.contentView).rightSpaceToView(_deleteBtn, 10);
   
    _saveBtn.sd_layout.widthIs(0).topSpaceToView(self.contentView, 8).bottomSpaceToView(self.contentView, 8).rightSpaceToView(self.contentView, 8);
 
    _contentField.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 8).bottomSpaceToView(self.contentView, 8).rightSpaceToView(_saveBtn, 10);
   
    _line.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).heightIs(1);
   
    CGFloat width = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 10) content:@"已有班组" font:12].width;
    _isHaveTeamLabel.sd_layout.rightSpaceToView(self.contentView, 8).centerYEqualToView(self.contentView).heightIs(10).widthIs(width);
}

- (void)setSelectedProjectName:(NSString *)selectedProjectName {
    
    _selectedProjectName = selectedProjectName;
}

- (void)setProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    _projectModel = projectModel;
    
    if ([_projectModel.pro_id integerValue] == 0) {
        
        _modifyBtn.hidden = YES;
        _deleteBtn.hidden = YES;
    }else {
        
        _modifyBtn.hidden = NO;
        _deleteBtn.hidden = NO;
    }

    _contentField.text = _projectModel.pro_name;
    _isEqualProjectName = YES;
    // 先判断，是否在编辑状态
    if (_isEditing) {
        
        _choicedProject.hidden = YES;
        _isHaveTeamLabel.hidden = YES;
        if (_projectModel.isEditeStating) {
            
            [self startModifyLayout];
            
        }else {
            
            [self nonModifyLayout];
            
        }
    }else {
        
        if (_isMarkSingleBillComeIn) {// 记账界面进入 不显示"已有班组"
            
            _contentField.textColor = AppFont333333Color;
            _isHaveTeamLabel.hidden = YES;
            
        }else {
            
            if ([_projectModel.is_create_group isEqualToString:@"1"]) {// 已有班组
                
                _contentField.textColor = AppFont999999Color;
                _isHaveTeamLabel.hidden = NO;
                
            }else {
                
                _contentField.textColor = AppFont333333Color;
                _isHaveTeamLabel.hidden = YES;
            }
        }
        
        
        if ([_selectedProjectName isEqualToString:_projectModel.pro_name]) {
            
            _choicedProject.hidden = NO;
            _isHaveTeamLabel.hidden = YES;
            
        }else {
            
            _choicedProject.hidden = YES;
        }
        
        
        
        [self endEdite];
    }
    
    if (![NSString isEmpty:self.searchValue]) {
        
        _contentField.attributedText = [UIView markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:_contentField.font isGetAllText:YES textField:_contentField];
    }
    
}


// 修改状态的layout
- (void)startModifyLayout {
    
    _deleteBtn.sd_layout.widthIs(0);
    _modifyBtn.sd_layout.widthIs(0);
    _saveBtn.sd_layout.rightSpaceToView(self.contentView, 10).widthIs(66);
    _contentField.layer.cornerRadius = 5;
    _contentField.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _contentField.layer.borderWidth = 1;
    _contentField.enabled = YES;
    [_contentField becomeFirstResponder];
}

// 不在修改状态
- (void)nonModifyLayout {
    
    _deleteBtn.sd_layout.widthIs(62);
    _modifyBtn.sd_layout.widthIs(62);
    _saveBtn.sd_layout.rightSpaceToView(self.contentView, 150).widthIs(0);
    _contentField.layer.borderWidth = 0;
    _contentField.enabled = NO;
//    [_contentField resignFirstResponder];
    
}

#pragma mark - method
- (void)startEdite {
    
    _isEditing = YES;
    _deleteBtn.sd_layout.widthIs(62);
    _modifyBtn.sd_layout.widthIs(62);
    _saveBtn.sd_layout.rightSpaceToView(self.contentView, 150);
    
    _isHaveTeamLabel.hidden = YES;
}

- (void)endEdite {
    
    _isEditing = NO;
    _deleteBtn.sd_layout.widthIs(0);
    _modifyBtn.sd_layout.widthIs(0);
    _saveBtn.sd_layout.rightSpaceToView(self.contentView, 10).widthIs(0);
    _contentField.layer.borderWidth = 0;
    _contentField.enabled = NO;

}

#pragma maek - delegate
// 修改项目
- (void)modifyProject {
    
    if ([self.projectListCellDelegate respondsToSelector:@selector(modifyProjectWithProjectModel:cell:)]) {
        
        [_projectListCellDelegate modifyProjectWithProjectModel:self.projectModel cell:self];
    }
}

// 删除项目
- (void)deleteProject {
    
    if ([self.projectListCellDelegate respondsToSelector:@selector(deleteProjectWithProjectModel:)]) {
        
        [_projectListCellDelegate deleteProjectWithProjectModel:self.projectModel];
    }
}

// 保存项目
- (void)saveProject {
    
    if ([NSString isEmpty:_contentField.text]) {
        
        [TYShowMessage showError:@"请输入项目名称"];
        
    }else {
        
        [self endEditing:YES];
        if ([self.projectListCellDelegate respondsToSelector:@selector(saveProjectWithProjectModel:isEqualProjectName:editeName:)]) {
            
            [_projectListCellDelegate saveProjectWithProjectModel:self.projectModel isEqualProjectName:_isEqualProjectName editeName:_projectEditeName];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:_projectModel.pro_name]) {
        
        _isEqualProjectName = YES;
    }else {
        
        _isEqualProjectName = NO;
    }
//    _projectModel.pro_name = textField.text;
    _projectEditeName = textField.text;
}

#pragma mark - setter/getter
- (UIImageView *)choicedProject {
    
    if (!_choicedProject) {
        
        _choicedProject = [[UIImageView alloc] init];
        _choicedProject.image = IMAGE(@"choicedProject");
        _choicedProject.contentMode = UIViewContentModeCenter;
        _choicedProject.hidden = YES;
    }
    return _choicedProject;
}

- (LengthLimitTextField *)contentField {
    
    if (!_contentField) {
        
        _contentField = [[LengthLimitTextField alloc] init];
        _contentField.textColor = AppFont333333Color;
        _contentField.font = FONT(AppFont30Size);
        _contentField.tintColor = [UIColor blueColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _contentField.leftViewMode = UITextFieldViewModeAlways;
        _contentField.leftView = leftView;
        _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentField.delegate = self;
        _contentField.maxLength = ProNameLength;
    }
    return _contentField;
}

- (UIButton *)modifyBtn {
    
    if (!_modifyBtn) {
        
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBtn.titleLabel.font = FONT(AppFont22Size);
        [_modifyBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        _modifyBtn.layer.borderWidth = 1;
        _modifyBtn.layer.borderColor = AppFont999999Color.CGColor;
        [_modifyBtn setTitle:@"修改" forState:(UIControlStateNormal)];
        
        [_modifyBtn addTarget:self action:@selector(modifyProject) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _modifyBtn;
}

- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.titleLabel.font = FONT(AppFont22Size);
        [_deleteBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.borderColor = AppFont999999Color.CGColor;
        [_deleteBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [_deleteBtn addTarget:self action:@selector(deleteProject) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteBtn;
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.titleLabel.font = FONT(AppFont26Size);
        [_saveBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
        _saveBtn.layer.borderWidth = 1;
        _saveBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_saveBtn addTarget:self action:@selector(saveProject) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _saveBtn;
}
- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}

- (UILabel *)isHaveTeamLabel {
    
    if (!_isHaveTeamLabel) {
        
        _isHaveTeamLabel = [[UILabel alloc] init];
        _isHaveTeamLabel.text = @"已有班组";
        _isHaveTeamLabel.font = FONT(AppFont24Size);
        _isHaveTeamLabel.textAlignment = NSTextAlignmentRight;
        _isHaveTeamLabel.textColor = AppFont999999Color;
        _isHaveTeamLabel.hidden = YES;
    }
    return _isHaveTeamLabel;
}
@end
