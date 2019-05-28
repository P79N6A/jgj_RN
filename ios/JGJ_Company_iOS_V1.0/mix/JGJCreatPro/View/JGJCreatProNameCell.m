//
//  JGJCreatProBottomDecCell.m
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatProNameCell.h"
#import "UILabel+GNUtil.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
#define ProLength 13
#define Omit @"..."
@interface JGJCreatProNameCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *proName;
@property (strong, nonatomic) JGJCreatDiscussTeamRequest *discussTeamRequest;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewH;
@end

@implementation JGJCreatProNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desLable.textColor = AppFont666666Color;
    self.desLable.text = @"1. 方便、实时的获得用工情况\n2. 快速的获得来自他人汇报的安全、质量等报告\n3. 项目信息可以快速的传达给你的上级，工作内容及时汇报";
    [self.desLable setAttributedText:self.desLable.text lineSapcing:3.0 textAlign:NSTextAlignmentLeft];
    [self.confirmButton.layer setLayerCornerRadius:4.0];
    self.proName.maxLength = ProNameLength;
    self.proName.backgroundColor = [UIColor whiteColor];
    self.proName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 0)];
    self.proName.leftViewMode = UITextFieldViewModeAlways;
    self.leftViewH.constant = 0.5;
    self.rightViewH.constant = 0.5;
    self.proName.delegate = self;
    [self.proName becomeFirstResponder];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.confirmButton.backgroundColor = AppFontEB4E4EColor;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.proName];
}

+ (CGFloat)creatProNameCellHeight {
    return 126.0;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJCreatProNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCreatProNameCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
//2.0.2添加
- (void)setNotifyModel:(JGJNewNotifyModel *)notifyModel {
    _notifyModel = notifyModel;
    NSString *maxProNameStr = @"";
    if (![NSString isEmpty:notifyModel.pro_name] && notifyModel.pro_name.length > ProLength) {
        
        maxProNameStr = [notifyModel.pro_name substringToIndex:ProLength];
        
        notifyModel.pro_name = [NSString stringWithFormat:@"%@%@", maxProNameStr,Omit];
    }
    self.proName.text = notifyModel.pro_name;
}

- (IBAction)confirmCreatProButtonPressed:(UIButton *)sender {
    if ([NSString isEmpty:self.proName.text]) {
        [TYShowMessage showPlaint:@"请输入项目名称"];
        return;
    }
    
    self.discussTeamRequest.pro_name = self.proName.text;
    
    if ([self.proName.text containsString:@"."]) {
        
        self.discussTeamRequest.pro_name = [self.discussTeamRequest.pro_name stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    
    if (self.confirmCreatProBlock) {
        self.confirmCreatProBlock(self.discussTeamRequest);
    }
}

- (JGJCreatDiscussTeamRequest *)discussTeamRequest {
    if (!_discussTeamRequest) {
        _discussTeamRequest = [[JGJCreatDiscussTeamRequest alloc] init];
        _discussTeamRequest.ctrl = @"team";
        _discussTeamRequest.action = @"createTeam";
    }
    return _discussTeamRequest;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
   return [theTextField resignFirstResponder];
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.proName.maxLength];
    
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

@end
