//
//  JGJWorkerRemarkCell.m
//  mix
//
//  Created by yj on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJWorkerRemarkCell.h"

@interface JGJWorkerRemarkCell()<JGJRemarkAvatarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentSubView;

@property (weak, nonatomic) IBOutlet JGJRemarkAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarViewBottom;

@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSubViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkH;

@property (weak, nonatomic) IBOutlet UILabel *title;



@end

@implementation JGJWorkerRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentSubView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:5.0];
    
    self.avatarView.delegate = self;

    self.remark.preferredMaxLayoutWidth = TYGetUIScreenWidth - 40;
    
    self.remark.backgroundColor = AppFontF5F5F5Color;
    
    self.avatarView.backgroundColor = AppFontF5F5F5Color;
    
    self.remark.textColor = AppFont666666Color;
    
    self.title.textColor = AppFont333333Color;
}

- (void)setMangerModel:(JGJMemberMangerModel *)mangerModel {
    
    _mangerModel = mangerModel;
    
    self.remark.text = mangerModel.notes_txt;
    
    self.avatarView.images = mangerModel.notes_img;
    
    if ([NSString isEmpty:mangerModel.notes_txt]) {
        
        self.remarkH.constant = 6;
        
    }else {
        
         CGFloat remarkH = mangerModel.notes_txt_H + 8;
        
         self.contentSubViewH.constant = mangerModel.notes_txt_H + mangerModel.notes_img_H + 10 + 8 + 8;
        
        if (![NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count > 0) {
            
            CGFloat offset = 5;//图片到文字的间距偏移
            
            remarkH += offset;
            
        }else if (![NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count == 0) {
            
            self.avatarViewBottom.constant = 0;
            
        }
        
        self.remarkH.constant = remarkH;
    }
    
    if ([NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count == 0) {
        
        self.contentView.hidden = YES;
        
        self.title.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
