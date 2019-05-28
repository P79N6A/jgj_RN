//
//  JGJSynBillEditContactsTableViewCell.m
//  mix
//
//  Created by jizhi on 16/5/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynBillEditContactsTableViewCell.h"

@interface JGJSynBillEditContactsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (copy, nonatomic) SynBillEditContactsSaveBlock saveBlock;

@end
@implementation JGJSynBillEditContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.saveButton.backgroundColor = JGJMainColor;
    [self.saveButton.layer setLayerCornerRadius:5.0];
    self.descriptionTF.maxLength = 8;
}

- (void)setSynBillingModel:(JGJSynBillingModel *)synBillingModel{
    _synBillingModel = synBillingModel;
    self.nameTF.text = self.synBillingModel.real_name;
    self.phoneTF.text = self.synBillingModel.telephone;
    self.descriptionTF.text = self.synBillingModel.descript;
}

- (void)SynBillEditContactsSaveBlock:(SynBillEditContactsSaveBlock)saveBlock{
    self.saveBlock = [saveBlock copy];
}


- (IBAction)saveBtnClick:(id)sender {
    if (self.saveBlock) {
        self.saveBlock(self);
    }
}
@end
