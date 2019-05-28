//
//  JGJContactsCell.m
//  mix
//
//  Created by celion on 16/4/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactsCell.h"
#import "TYPhone.h"
#import "UIButton+WebCache.h"
@interface JGJContactsCell ()
@property (weak, nonatomic) IBOutlet UIButton *headpicBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *telph;
@property (weak, nonatomic) IBOutlet UIButton *telphoneButton;
@property (strong, nonatomic) NSArray *colorArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telphButtonTrailing;
@end

@implementation JGJContactsCell

- (void)awakeFromNib {
     _colorArray = @[TYColorHex(0xf4b860),TYColorHex(0xf19937),TYColorHex(0x5ea3f8),TYColorHex(0xc48fe1),TYColorHex(0xeb6e48)];
    self.headpicBtn.layer.cornerRadius = JGJCornerRadius;
    [self.headpicBtn.layer setLayerCornerRadius:TYGetViewW(self.headpicBtn) / 2.0];
    self.headpicBtn.clipsToBounds = YES;
    self.friendName.font = [UIFont systemFontOfSize:AppFont30Size];
    self.friendName.textColor = AppFont333333Color;
    self.telph.font = [UIFont systemFontOfSize:AppFont30Size];
    self.telph.textColor = AppFont666666Color;
}

- (void)setFindResultModel:(FindResultModel *)findResultModel {
    NSInteger index = arc4random() % 5;
    _findResultModel = findResultModel;
    NSString *name = [findResultModel.friendname substringWithRange:NSMakeRange(findResultModel.friendname.length - 1, 1)];
    if ((findResultModel.headpic.length > 0 && findResultModel.headpic != nil)  && ![findResultModel.headpic containsString:@"media/images/"]) {
        [self.headpicBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[JLGHttpRequest_Public stringByAppendingString:findResultModel.headpic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
    } else {
        [self.headpicBtn setTitle:name forState:UIControlStateNormal];
        self.headpicBtn.backgroundColor = _colorArray[index];
    }
    self.telphButtonTrailing.constant = findResultModel.isHiddenIndexView ? 10 : 40;
    
    self.friendName.text = findResultModel.friendname;
    self.telph.text = findResultModel.telph;

}

- (IBAction)callContactButtonDidClicked:(UIButton *)sender {
    
    FindResultModel *findResultModel = self.findResultModel;
    [TYPhone callPhoneByNum:findResultModel.telph view:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
