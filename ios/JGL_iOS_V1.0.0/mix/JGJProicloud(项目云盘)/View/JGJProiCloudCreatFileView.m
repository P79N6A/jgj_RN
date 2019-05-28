//
//  JGJProiCloudCreatFileView.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudCreatFileView.h"

static JGJProiCloudCreatFileView *_creatFileView;

@interface JGJProiCloudCreatFileView ()
@property (weak, nonatomic) IBOutlet UILabel *fileTypeName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileTypeNameW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileTypeImageViewW;
@property (weak, nonatomic) IBOutlet UIImageView *fileTypeImage;

@property (weak, nonatomic) IBOutlet UIView *containDetailView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewCenterY;

@end

@implementation JGJProiCloudCreatFileView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self commonSet];

}

+ (JGJProiCloudCreatFileView *)proiCloudCreatFileView:(JGJProicloudListModel *)cloudListModel {

    if(_creatFileView && _creatFileView.superview) [_creatFileView removeFromSuperview];
    
    if (!_creatFileView) {
        
        _creatFileView = [[[NSBundle mainBundle] loadNibNamed:@"JGJProiCloudCreatFileView" owner:self options:nil] lastObject];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    _creatFileView.frame = window.bounds;

    [window addSubview:_creatFileView];
  
    [_creatFileView setContentWithcloudListModel:cloudListModel];
    
//    _creatFileView.fileNameTextField.valueDidChange = ^(NSString *changeValue){
//    
//        if (_creatFileView.proiCloudCreatFileViewBlock) {
//            
//            _creatFileView.proiCloudCreatFileViewBlock(_creatFileView, changeValue);
//        }
//        
//    };
    
    [_creatFileView.fileNameTextField becomeFirstResponder];
    
    return _creatFileView;
}

- (void)setContentWithcloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    [self setFileFlagWithCloudListModel:cloudListModel];

    self.fileTypeName.text = [NSString stringWithFormat:@".%@", cloudListModel.file_type];
    
    NSRange range = [cloudListModel.file_name rangeOfString:@"."];
    
    NSString *subIndexStr = cloudListModel.file_name;
    
    if (range.location != NSNotFound) {
        
        subIndexStr = [cloudListModel.file_name substringToIndex:range.location];
    }
    
    self.fileNameTextField.text = subIndexStr;
}

- (void)setFileFlagWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        self.fileTypeImageViewW.constant = 56;
        
        self.fileTypeImage.hidden = NO;
        
        self.fileTypeNameW.constant = 20;
        
        self.fileTypeName.hidden = YES;
        
        self.fileNameTextField.placeholder = @"请输入新文件夹名称";
        
        self.titleLable.text = @"新建文件夹";
    }else {
        
        self.fileTypeImageViewW.constant = 10;
        
        self.fileTypeImage.hidden = YES;
        
        self.fileTypeNameW.constant = 56;
        
        self.fileTypeName.hidden = NO;
        
        self.titleLable.text = @"重命名";
        
        self.fileNameTextField.placeholder = @"请输入新文件名称";
    }

}

- (void)commonSet {

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self.containDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    
    [self.fileNameTextField.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:2.5];
    
    
    self.fileTypeName.textColor = AppFont999999Color;
    
    self.titleLable.textColor = AppFont333333Color;
    
    [self.confirmButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    
     [self.cancelButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    if (TYIS_IPHONE_5) {
        
        self.containViewCenterY.constant -= 55;
    }
    
    UIImageView *searchIcon = [[UIImageView alloc] init];

    searchIcon.width = 10;
    
    searchIcon.height = 10;
    
    self.fileNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.fileNameTextField.leftView = searchIcon;
    
    self.fileNameTextField.maxLength = 13;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    [_creatFileView dismiss];
}

- (IBAction)handleOkButtonAction:(UIButton *)sender {
    
    if ([NSString isEmpty:self.fileNameTextField.text]) {
        
        [TYShowMessage showPlaint:@"必须填写名称"];
        
        return;
    }
    
    if (_creatFileView.onOkBlock) {
        
        _creatFileView.onOkBlock(self);
    }
    
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        _creatFileView.alpha = 0;
    }completion:^(BOOL finished) {
        [_creatFileView removeFromSuperview];
        _creatFileView = nil;
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self) {
        
        [self removeFromSuperview];
        
        [self endEditing:YES];
    }
}

@end
