//
//  JGJCreatTeamCell.m
//  mix
//
//  Created by yj on 16/8/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatTeamCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJCreatTeamCell ()
//@property (weak, nonatomic) IBOutlet UITextField *detailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTitleTrail;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@end

@implementation JGJCreatTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailTitle.textColor = AppFont666666Color;
    self.detailTitle.font = [UIFont systemFontOfSize:AppFont30Size];
    self.title.font = [UIFont systemFontOfSize:AppFont30Size];
    self.detailTitle.preferredMaxLayoutWidth = TYGetUIScreenWidth - 110;
    
    self.title.textColor =  AppFont000000Color;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJCreatTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCreatTeamCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCreatTeamModel:(JGJCreatTeamModel *)creatTeamModel {
    _creatTeamModel = creatTeamModel;
    self.title.text = _creatTeamModel.title;
    
    self.detailTitle.text = _creatTeamModel.detailTitle?:@"";
    
    self.rightImageViewWidth.constant = _creatTeamModel.teamMangerVcType == JGJNormalMemberTeamInfoVcType? 0 : 9.0;
    self.rightImageViewHeight.constant = _creatTeamModel.teamMangerVcType == JGJNormalMemberTeamInfoVcType? 0 : 15.0;
    self.rightImageView.image  = [UIImage imageNamed:@"arrow_right"];
    
    //显示二维码
    if ([_creatTeamModel.placeholderTitle isEqualToString:@"班组二维码"] || _creatTeamModel.isShowQrcode) {
        self.rightImageView.image  = [UIImage imageNamed:@"teamManger_Qrcode"];
        self.rightImageViewWidth.constant = 20.0;
        self.rightImageViewHeight.constant = 20.0;
        //        self.detailTitle.placeholder = nil;
//        self.detailTitle.text = @"";
        
        //隐藏箭头字灰色
    } else if (_creatTeamModel.isHiddenArrow) {
        
        self.rightImageViewWidth.constant = 0;
        self.rightImageViewHeight.constant = 0;
        self.detailTitleTrail.constant = 0;
        self.detailTitle.textColor = AppFont999999Color;
        self.rightImageView.hidden = YES;
        //仅显示文字，隐藏箭头
    } else if (_creatTeamModel.isOnlyContent) {
        
        self.detailTitle.text = _creatTeamModel.placeholderTitle;
        
        self.rightImageViewWidth.constant = 0;
        self.rightImageViewHeight.constant = 0;
        self.detailTitleTrail.constant = 0;
        self.detailTitle.textColor = AppFont999999Color;
        
    }else if (_creatTeamModel.isHiddenSubView) {
        
        self.detailTitle.hidden = self.rightImageView.hidden = self.title.hidden = YES;
        
        //显示箭头灰色文字
    } else if (_creatTeamModel.isShowGrayDetailTitle) {
        
        self.detailTitle.textColor = AppFont999999Color;
        
    } else {
        self.detailTitle.textColor = AppFont333333Color;
        self.detailTitleTrail.constant = _creatTeamModel.teamMangerVcType == JGJNormalMemberTeamInfoVcType? 0 : 6.0;
    }
    
    if (_creatTeamModel.isShowQrcode) {
        
        [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(20);
            
        }];
        
    }else {
        
        BOOL isHidden = (_creatTeamModel.isHiddenArrow || _creatTeamModel.isOnlyContent);
        
        [self.detailTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self).mas_offset(isHidden?-10:-27);
            
        }];
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
