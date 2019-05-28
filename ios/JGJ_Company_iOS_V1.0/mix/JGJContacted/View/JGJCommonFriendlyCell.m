//
//  JGJCommonFriendlyCell.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCommonFriendlyCell.h"

#import "UIButton+JGJUIButton.h"

@interface JGJCommonFriendlyCell ()

@property (weak, nonatomic) IBOutlet UILabel *friendDes;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIView *topLineView;


@end

@implementation JGJCommonFriendlyCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.friendDes.textColor = AppFont999999Color;
    
    for (UIButton *headerBtn in self.contentView.subviews) {
        
        if ([headerBtn isKindOfClass:[UIButton class]]) {
            
            if (headerBtn.tag >= 100 && headerBtn.tag <= 102) {
                
                [headerBtn.layer setLayerCornerRadius:2.5];
                
            }
            
        }
        
    }
    
    self.topLineView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setPerInfoModel:(JGJChatPerInfoModel *)perInfoModel {
    
    _perInfoModel = perInfoModel;
    
    if (_perInfoModel.common_friends.count > 0) {
        
        for (UIButton *headerBtn in self.contentView.subviews) {
            
            headerBtn.hidden = self.isHiddenSubView;
            
            if ([headerBtn isKindOfClass:[UIButton class]]) {
                
                NSInteger btnTag = headerBtn.tag - 100;
                
                if (btnTag >= 0 && btnTag <= 2 && btnTag <= _perInfoModel.common_friends.count - 1) {
                    
                    headerBtn.hidden = NO || self.isHiddenSubView;
                    
                    JGJSynBillingModel *memberModel = _perInfoModel.common_friends[btnTag];
                    
                    [headerBtn setMemberPicButtonWithHeadPicStr:memberModel.head_pic memberName:memberModel.real_name memberPicBackColor:memberModel.modelBackGroundColor membertelephone:memberModel.telephone];
                    
                }else {
                    
                    headerBtn.hidden = YES;
                }
                
            }
            
        }
    }else {
        
        for (UIView *subView in self.contentView.subviews) {
            
            subView.hidden = YES;
        }
        
    }
    
    self.friendDes.text = [NSString stringWithFormat:@"%@个共同的好友", @(_perInfoModel.common_friends.count)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
