//
//  JGJChatSignAddressCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignAddressCell.h"

@interface JGJChatSignAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;

@end

@implementation JGJChatSignAddressCell

-(void)awakeFromNib {

    [super awakeFromNib];
    
    self.addressLabel.preferredMaxLayoutWidth = TYGetUIScreenWidth - 100;
}

- (void)setAddSignModel:(JGJAddSignModel *)addSignModel{
    _addSignModel = addSignModel;
    self.addressLabel.text = addSignModel.sign_addr;
    self.addressDetailLabel.text = addSignModel.sign_addr2;
}

@end
