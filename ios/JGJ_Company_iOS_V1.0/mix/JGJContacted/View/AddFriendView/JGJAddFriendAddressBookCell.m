//
//  JGJAddFriendAddressBookCell.m
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendAddressBookCell.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJAddFriendAddressBookCell ()
@property (weak, nonatomic  ) IBOutlet UIButton           *showHeadPicBtn;
@property (weak, nonatomic  ) IBOutlet UILabel            *name;
@property (weak, nonatomic  ) IBOutlet UILabel            *telphone;
@property (weak, nonatomic) IBOutlet UIImageView *unRegisterFlagImageView;
@end

@implementation JGJAddFriendAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.showHeadPicBtn.layer setLayerCornerRadius:JGJHeadCornerRadius];
    [self.showHeadPicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showHeadPicBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont46Size];
    self.name.textColor = AppFont333333Color;
    self.name.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telphone.textColor = AppFont999999Color;
    self.telphone.font = [UIFont systemFontOfSize:AppFont30Size];
    self.lineView.backgroundColor = AppFontdbdbdbColor;
}

+ (CGFloat)JGJAddFriendAddressBookCellHeight {
    return 68;
}

- (void)setContactModel:(JGJSynBillingModel *)contactModel {
    _contactModel = contactModel;
    
    [self.showHeadPicBtn  setTitle:@"" forState:UIControlStateNormal];
    [self.showHeadPicBtn  setImage:nil forState:UIControlStateNormal];
    [self.showHeadPicBtn  setBackgroundImage:nil forState:UIControlStateNormal];
    [self.showHeadPicBtn setMemberPicButtonWithHeadPicStr:contactModel.head_pic memberName:contactModel.real_name memberPicBackColor:contactModel.modelBackGroundColor];
    self.telphone.text = contactModel.telephone;
    self.name.text =  contactModel.real_name;
    self.unRegisterFlagImageView.hidden = [contactModel.is_active boolValue];
//    NSString *myTelephone = [TYUserDefaults objectForKey:JLGPhone];
//    self.name.textColor = AppFont333333Color;
//    self.telphone.textColor = AppFont999999Color;
//    if (!contactModel.is_register || [myTelephone isEqualToString:contactModel.telephone]) {
//        self.name.textColor = AppFont999999Color;
//        self.telphone.textColor = AppFont999999Color;
//    }
    if (![NSString isEmpty:self.searchValue]) {
        [self.telphone markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.telphone.font isGetAllText:YES];
        [self.name markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.name.font isGetAllText:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
