//
//  JGJQuaSafeCheckCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckCell.h"

#import "UIButton+JGJUIButton.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJQuaSafeCheckCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *prinLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UILabel *passingRateLable;

@property (weak, nonatomic) IBOutlet UILabel *comRateLable;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;


@end

@implementation JGJQuaSafeCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.passingRateLable.textColor = AppFont333333Color;
    
    self.comRateLable.textColor = AppFont999999Color;
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.timeLable.textColor = AppFont999999Color;
    
    self.contentLable.backgroundColor = [UIColor whiteColor];
    
    [self.headButton.layer setLayerCornerRadius:2.5];
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.contentLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
    self.contentLable.textColor = AppFont333333Color;

}

- (void)setListModel:(JGJQuaSafeCheckListModel *)listModel {

    _listModel = listModel;
    
    NSString *pubName = listModel.send_user_info.real_name;
    
    pubName = [NSString cutWithContent:listModel.send_user_info.real_name maxLength:4];
    
    UIColor *memberColor = [NSString modelBackGroundColor:pubName];
    
    [self.headButton setMemberPicButtonWithHeadPicStr:listModel.send_user_info.head_pic memberName:pubName memberPicBackColor:memberColor membertelephone:nil];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.nameLable.text = pubName;
    
    self.timeLable.text = listModel.create_time;
    
    self.contentLable.text = listModel.inspect_name;
    
    if (![NSString isEmpty:listModel.child_inspect_name]) {
     
        self.contentLable.text = [NSString stringWithFormat:@"%@ | %@", listModel.inspect_name, listModel.child_inspect_name];
        
        [self.contentLable markText:@"|" withColor:AppFont999999Color];
        
    }

    NSString *prinName = listModel.user_info.real_name;
    
    prinName = [NSString cutWithContent:listModel.user_info.real_name maxLength:4];
    
    if (![NSString isEmpty:prinName] ) {
        
        self.prinLable.text = [NSString stringWithFormat:@"由%@执行",prinName];
        
        [self.prinLable markText:prinName withColor:AppFont4990e2Color];
        
    }else {
        
        self.prinLable.text = @"";
    }
    
    self.passingRateLable.text = [NSString stringWithFormat:@"通过率%@%%", listModel.pass];
    
    self.comRateLable.text = [NSString stringWithFormat:@"完成率%@%%", listModel.finish];
    
    if (![listModel.finish isEqualToString:@"100"]) {
        
        self.comRateLable.textColor = AppFontFF0000Color;
    }else {
    
        self.comRateLable.textColor = AppFont999999Color;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
