//
//  YZGAddContactsTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAddContactsTableViewCell.h"
#import "NSString+Extend.h"

@implementation YZGAddForemanModel

- (void)setName:(NSString *)name{
    _name = name;
    
    //取出所有汉字的首字母
    NSString *insPinyin = [NSString string];
    for (int i = 0; i < name.length; i++) {
        NSString *shor = [name substringWithRange:NSMakeRange(i, 1)];
        NSString *temshor = [[NSString firstCharactor:shor] capitalizedString];
        insPinyin = [insPinyin stringByAppendingString:temshor];
    }
    
    self.name_pinyin_abbr = insPinyin;
    self.name_pinyin = [[NSString getCharactor:name] capitalizedString];
}
@end

@interface YZGAddContactsTableViewCell ()
{
    NSArray *_colorArray;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation YZGAddContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _colorArray = @[TYColorHex(0xf4b860),TYColorHex(0xf19937),TYColorHex(0x5ea3f8),TYColorHex(0xc48fe1),TYColorHex(0xeb6e48)];
    [self.titleLabel.layer setLayerCornerRadius:TYGetViewW(self.titleLabel) / 2.0];
    [self.deleteButton.layer setLayerBorderWithColor:AppFont333333Color width:0.5 radius:2.5];
}

- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel{
    _addForemanModel = addForemanModel;
    
    self.titleLabel.text = [addForemanModel.name substringWithRange:NSMakeRange(addForemanModel.name.length - 1, 1)];
    self.titleLabel.backgroundColor = _colorArray[self.tag%5];
    self.nameLabel.text = addForemanModel.name;
    self.phoneLabel.text = addForemanModel.telph;
    self.deleteButton.hidden = !addForemanModel.isDelete;
//    self.selectedImage.hidden = addForemanModel.isDelete;
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    if (self.deleteForemanModelBlock) {
        self.deleteForemanModelBlock(self.addForemanModel);
    }
}


@end
