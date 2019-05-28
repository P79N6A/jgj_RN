//
//  YZGAddContactsTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAddContactsTableViewCell.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@implementation YZGAddForemanModel

- (void)setName:(NSString *)name{
    _name = name;
    _name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //取出所有汉字的首字母
    NSString *insPinyin = [NSString string];
    for (int i = 0; i < name.length; i++) {
        NSString *shor = [name substringWithRange:NSMakeRange(i, 1)];
        NSString *temshor = [[NSString firstCharactor:shor] capitalizedString];
        insPinyin = [insPinyin stringByAppendingString:temshor];
    }
    
    self.name_pinyin_abbr = insPinyin;
    
    if (![NSString isEmpty:name]) {
         self.name_pinyin = [[NSString getCharactor:name] capitalizedString];
    }
}
@end

@interface YZGAddContactsTableViewCell ()
{
    NSArray *_colorArray;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@end

@implementation YZGAddContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _colorArray = @[TYColorHex(0xf4b860),TYColorHex(0xf19937),TYColorHex(0x5ea3f8),TYColorHex(0xc48fe1),TYColorHex(0xeb6e48)];
    [self.deleteButton.layer setLayerBorderWithColor:AppFont333333Color width:0.5 radius:2.5];
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius];
    self.headButton.userInteractionEnabled = NO;
}

- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel{
    _addForemanModel = addForemanModel;
    UIColor *headBackColor = [NSString modelBackGroundColor:addForemanModel.name];
    [self.headButton setMemberPicButtonWithHeadPicStr:addForemanModel.head_pic memberName:addForemanModel.name memberPicBackColor:headBackColor];
    self.nameLabel.text = addForemanModel.name;
    self.phoneLabel.text = addForemanModel.telph;
    
    //搜索改变颜色
    [self.nameLabel markText:self.searchValue withColor:AppFontd7252cColor];
    
    [self.phoneLabel markText:self.searchValue withColor:AppFontd7252cColor];
    
    self.deleteButton.hidden = !addForemanModel.isDelete;
    self.deleteButton.enabled = YES;
    if (addForemanModel.isSelected && addForemanModel.addForemanModelindexPath.section == 0 && addForemanModel.addForemanModelindexPath.row == 0 && !addForemanModel.isDelete) {
        self.deleteButton.hidden = NO;
        self.deleteButton.enabled = NO;
        [self.deleteButton setImage:[UIImage imageNamed:@"RecordWorkpoints_AddFmNoContactsSelected"] forState:UIControlStateNormal];
        
        [self.deleteButton setTitle:@"已选中" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        [self.deleteButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        [self.deleteButton.layer setLayerBorderWithColor:[UIColor whiteColor] width:0 radius:0];
    }
    
//    self.selectedImage.hidden = addForemanModel.isDelete;
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    if (self.deleteForemanModelBlock) {
        self.deleteForemanModelBlock(self.addForemanModel);
    }
}


@end
