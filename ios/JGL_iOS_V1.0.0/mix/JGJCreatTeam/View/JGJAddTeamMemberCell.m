//
//  JGJAddTeamMemberCell.m
//  mix
//
//  Created by YJ on 16/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAddTeamMemberCell.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
@interface JGJAddTeamMemberCell ()
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *multiSelectedButtonH;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *multiSelectedButtonW;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *paddingLead;
@property (weak, nonatomic  ) IBOutlet UIButton           *showHeadPicBtn;
@property (weak, nonatomic  ) IBOutlet UILabel            *name;
@property (weak, nonatomic  ) IBOutlet UILabel            *telphone;
@property (weak, nonatomic  ) IBOutlet UILabel            *descript;
@property (weak, nonatomic  ) IBOutlet UIButton           *addBtn;
@property (weak, nonatomic  ) IBOutlet UIButton           *multiSelectedButon;
@property (weak, nonatomic  ) IBOutlet LineView           *desLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnTrail;


@end

@implementation JGJAddTeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showHeadPicBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont46Size];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telphone.textColor = AppFont666666Color;
    self.telphone.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.addBtn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    [self.multiSelectedButon setImage:PNGIMAGE(@"MultiSelected") forState:UIControlStateSelected];
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJAddTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJAddTeamMemberCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSynBillingModel:(JGJSynBillingModel *)synBillingModel {
    _synBillingModel = synBillingModel;
//    NSString *name = [synBillingModel.real_name substringWithRange:NSMakeRange(synBillingModel.real_name.length - 1, 1)];
//    [self.showHeadPicBtn setTitle:name forState:UIControlStateNormal];
//    self.showHeadPicBtn.backgroundColor = synBillingModel.modelBackGroundColor;
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:synBillingModel.head_pic memberName:synBillingModel.real_name memberPicBackColor:synBillingModel.modelBackGroundColor];
    self.telphone.text = synBillingModel.telephone;
    self.name.text =  synBillingModel.real_name;
    NSString *showAddStr = synBillingModel.isAddedSyn == 1 ? @"已添加" : @"";
    [self.addBtn setTitle:showAddStr forState:UIControlStateNormal];
    
    if (!synBillingModel.isSelected) {
        
        [self.multiSelectedButon setImage:[UIImage imageNamed:@"EllipseIcon"] forState:UIControlStateNormal];
    }else {
        
        [self.multiSelectedButon setImage:[UIImage imageNamed:@"MultiSelected"] forState:UIControlStateNormal];
    }
    
    if (synBillingModel.isAddedSyn || synBillingModel.is_exist) {
        
        [self.multiSelectedButon setImage:[UIImage imageNamed:@"OldSelected"] forState:UIControlStateNormal];
        
    }
    
    [self.telphone markText:self.searchValue withColor:AppFontEB4E4EColor];
    
    [self.name markText:self.searchValue withColor:AppFontEB4E4EColor];
    
    
}

- (void)setMaxTrail:(CGFloat)maxTrail {
    
    _maxTrail = maxTrail;
    
    [self jgj_updateWithConstraint:self.addBtnTrail constant:maxTrail];
    
}

- (void)jgj_updateWithConstraint:(NSLayoutConstraint *)constraint constant:(CGFloat)constant {
    
    if (constraint.constant == constant) {
        
        return;
        
    }
    
    constraint.constant = constant;
    
}

- (IBAction)multiSelectedButtonPressed:(UIButton *)sender {
    NSString *telephone = [TYUserDefaults objectForKey:JLGPhone];
    
    BOOL isAddGroupMember = self.commonModel.memberType == JGJGroupMemberType  && [self.synBillingModel.telephone isEqualToString:telephone];
    BOOL isAddMyPromember = self.commonModel.memberType == JGJProMemberType && [self.synBillingModel.telephone isEqualToString:telephone];
    if (isAddGroupMember) {
        [TYShowMessage showPlaint:@"尊敬的用户,你已在班组内!"];
        return;
    }
    if (isAddMyPromember) {
        [TYShowMessage showPlaint:@"尊敬的用户,你已是项目成员!"];
        return;
    }
    self.synBillingModel.isSelected = !self.synBillingModel.isSelected;
    if (self.synBillingModelBlock && !self.synBillingModel.isAddedSyn) {
        self.synBillingModelBlock(self.synBillingModel);
    }
}
@end
