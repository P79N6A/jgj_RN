//
//  JGJSynBillingManageCell.m
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynBillingManageCell.h"
#import "CustomView.h"
#import "UIButton+JGJUIButton.h"
@interface JGJSynBillingManageCell ()
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *multiSelectedButtonH;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *multiSelectedButtonW;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *paddingLead;
@property (weak, nonatomic  ) IBOutlet UIButton           *showHeadPicBtn;
@property (weak, nonatomic  ) IBOutlet UILabel            *name;
@property (weak, nonatomic  ) IBOutlet UILabel            *telphone;
@property (weak, nonatomic  ) IBOutlet UILabel            *descript;
@property (weak, nonatomic  ) IBOutlet UIButton           *synBtn;
@property (weak, nonatomic  ) IBOutlet UIButton           *multiSelectedButon;
@property (weak, nonatomic  ) IBOutlet LineView           *desLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synBtnTrail;
@end
@implementation JGJSynBillingManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJCornerRadius];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telphone.textColor = AppFont666666Color;
    self.telphone.font = [UIFont systemFontOfSize:AppFont30Size];
    self.descript.textColor = AppFont999999Color;
    self.descript.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.synBtn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    [self.multiSelectedButon setImage:PNGIMAGE(@"MultiSelected") forState:UIControlStateSelected];
    self.lineView.backgroundColor = AppFontf1f1f1Color;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSynBillingManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSynBillingManageCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSynBillingModel:(JGJSynBillingModel *)synBillingModel {
    _synBillingModel = synBillingModel;
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:synBillingModel.head_pic memberName:synBillingModel.real_name memberPicBackColor:synBillingModel.modelBackGroundColor];
    
    self.telphone.text = synBillingModel.telephone;
    self.name.text =  synBillingModel.real_name;
    self.descript.text = synBillingModel.descript;
    self.desLineView.hidden = synBillingModel.descript.length == 0;
    NSString *showSynStr = synBillingModel.is_sync == 1 ? @"已同步" : @"";
    NSString *imageIcon = synBillingModel.is_sync == 1 ? @"OldSelected" : @"EllipseIcon";
    CGFloat trailPadding = synBillingModel.isMoveRightButton ? 45 : 20;
    self.synBtnTrail.constant = trailPadding;
//    同步账单管理 ,项目进入同步账单管理
    if (self.synBillingCommonModel.isWageBillingSyn) {

        [self.multiSelectedButon setImage:PNGIMAGE(imageIcon) forState:UIControlStateNormal];
        self.multiSelectedButon.selected = synBillingModel.isSelected;
        self.multiSelectedButtonW.constant = 45;
        self.multiSelectedButon.hidden = NO;
        [self.synBtn setTitle:showSynStr forState:UIControlStateNormal];
        self.synBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        [self.synBtn setImage:PNGIMAGE(@"right") forState:UIControlStateNormal];
         self.synBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
        self.multiSelectedButtonW.constant = 0;
        self.multiSelectedButon.hidden = YES;
        self.paddingLead.constant = 10;
    }
}

- (IBAction)multiSelectedButtonPressed:(UIButton *)sender {
    if (!self.synBillingModel.is_sync) {
        sender.selected = !sender.selected;
        self.synBillingModel.isSelected = sender.selected;
        if (self.synBillingModelBlock) {
            self.synBillingModelBlock(self.synBillingModel);
        }
    }
}

@end
