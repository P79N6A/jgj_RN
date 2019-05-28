//
//  JGJSetAdministratorCell.m
//  JGJCompany
//
//  Created by yj on 16/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSetAdministratorCell.h"
#import "NSString+Extend.h"
#import "UIButton+WebCache.h"
#import "UIView+GNUtil.h"
#import "UIButton+JGJUIButton.h"
#import "CustomView.h"

#import "UILabel+GNUtil.h"

@interface JGJSetAdministratorCell ()
@property (weak, nonatomic) IBOutlet UIButton *showHeadPicBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeMemberBtnW;
@property (weak, nonatomic) IBOutlet UIButton *removeMemberButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end

@implementation JGJSetAdministratorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telephone.textColor = AppFont666666Color;
    self.telephone.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.showHeadPicBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    self.showHeadPicBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSetAdministratorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSetAdministratorCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMemberModel:(JGJSynBillingModel *)memberModel {
    _memberModel = memberModel;
    self.name.text = memberModel.real_name;
    self.telephone.text = memberModel.telephone;
    self.removeMemberButton.hidden = (self.adminCellType == JGJSetAdminiCellAddAdminType);
    self.removeMemberBtnW.constant = (self.adminCellType == JGJSetAdminiCellAddAdminType ? 0 : 70);
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:memberModel.head_pic memberName:memberModel.real_name memberPicBackColor:memberModel.modelBackGroundColor];
    if ([NSString isEmpty:memberModel.telephone]) {
        self.nameTop.constant = 26;
        self.telephone.hidden = YES;
    }else {
        self.nameTop.constant = 12;
        self.telephone.hidden = NO;
    }
    
    [self.name markText:self.searchValue withColor:AppFontEB4E4EColor];
    
    [self.telephone markText:self.searchValue withColor:AppFontEB4E4EColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)handleRemoveButtonPressed:(UIButton *)sender {
    if (self.removeMemberModelBlock) {
        self.removeMemberModelBlock(self.memberModel);
    }
    
}

@end
