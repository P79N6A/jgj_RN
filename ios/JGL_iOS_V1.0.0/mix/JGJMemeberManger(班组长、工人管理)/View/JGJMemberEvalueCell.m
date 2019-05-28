//
//  JGJMemberEvalueCell.m
//  mix
//
//  Created by yj on 2018/6/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberEvalueCell.h"

#import "JGJMemberImpressTagView.h"

#import "JGJStartView.h"

#import "UIButton+JGJUIButton.h"

#import "YYLabel.h"

#import "JGJCoreTextLable.h"

@interface JGJMemberEvalueCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *dateLable;


@property (weak, nonatomic) IBOutlet JGJStartView *startView;

@property (weak, nonatomic) IBOutlet JGJMemberImpressTagView *tagView;

@property (weak, nonatomic) IBOutlet YYLabel *contentLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewH;
@property (weak, nonatomic) IBOutlet UIImageView *evalueFlag;

@end

@implementation JGJMemberEvalueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.contentLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
//    self.contentLable.backgroundColor = AppFontEB4E4EColor;
    
    self.contentLable.numberOfLines = 0;
    
}

- (void)setListModel:(JGJMemberEvaListModel *)listModel {
    
    _listModel = listModel;
    
//    self.startView.listModel = listModel;
    
    self.tagView.backColor = AppFontFEF0D9Color;
    
    self.tagView.layerColor = AppFontF8CB82Color;
    
    self.tagView.textColor = AppFont333333Color;
    
    self.tagView.tagViewType = JGJMemberImpressShowTagViewType;
    
    self.tagView.tags = listModel.tag_list;
    
//    [self.headButton setMemberPicButtonWithHeadPicStr:listModel.user_info.head_pic memberName:listModel.user_info.name memberPicBackColor:listModel.user_info.modelBackGroundColor membertelephone:listModel.user_info.telephone];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.nameLable.text = listModel.user_info.nameDes;
    
    self.dateLable.text = listModel.pub_date;
    
    self.contentLable.attributedText = listModel.attContentStr;
    
    self.tagViewH.constant = listModel.tagHeight;
    
    self.evalueFlag.hidden = !listModel.is_near_eva;
}

@end
