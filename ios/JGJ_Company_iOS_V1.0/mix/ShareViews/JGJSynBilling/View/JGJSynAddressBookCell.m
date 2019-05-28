//
//  JGJSynAddressBookCell.m
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynAddressBookCell.h"
#import "UIButton+JGJUIButton.h"
@interface JGJSynAddressBookCell ()
@property (weak, nonatomic) IBOutlet UIButton *showHeadPicBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telphone;
@property (weak, nonatomic) IBOutlet UIButton *addSynModelBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addSynModelBtnTrail;

@end
@implementation JGJSynAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telphone.textColor = AppFont666666Color;
    self.telphone.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.addSynModelBtn.layer setLayerBorderWithColor:AppFont333333Color width:1 radius:2.5];
    self.addSynModelBtn.layer.masksToBounds = YES;
    [self.addSynModelBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    self.addSynModelBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSynAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSynAddressBookCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setAddressBookModel:(JGJSynBillingModel *)addressBookModel {
    _addressBookModel = addressBookModel;
    self.name.text = addressBookModel.name;
    self.telphone.text = addressBookModel.telph;
//    if(addressBookModel.name.length > 0) {
//        NSString *name = [addressBookModel.name substringWithRange:NSMakeRange(addressBookModel.name.length - 1, 1)];
//        [self.showHeadPicBtn setTitle:name forState:UIControlStateNormal];
//    }
//    self.showHeadPicBtn.backgroundColor = addressBookModel.modelBackGroundColor;
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:addressBookModel.head_pic memberName:addressBookModel.real_name memberPicBackColor:addressBookModel.modelBackGroundColor];
    CGFloat trailPadding = addressBookModel.isMoveRightButton ? 45 : 20;
    self.addSynModelBtnTrail.constant = trailPadding;
    if (addressBookModel.isAddedSyn) {
        [self.addSynModelBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.addSynModelBtn setImage:PNGIMAGE(@"GraySelectedIcon") forState:UIControlStateNormal];
         self.addSynModelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.addSynModelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        [self.addSynModelBtn setTitle:@"添加" forState:UIControlStateNormal];
         self.addSynModelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.addSynModelBtn.layer.borderColor = AppFont999999Color.CGColor;
    }
}

- (IBAction)addSynModelBuutonPressed:(UIButton *)sender {
//    没同步的才能点击按钮
    if (self.addSynModelBlock && !self.addressBookModel.isAddedSyn) {
        self.addSynModelBlock(self.addressBookModel);
    }
}

@end
