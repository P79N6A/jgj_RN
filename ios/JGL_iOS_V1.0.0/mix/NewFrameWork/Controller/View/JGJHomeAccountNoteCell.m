//
//  JGJHomeAccountNoteCell.m
//  mix
//
//  Created by yj on 2018/4/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJHomeAccountNoteCell.h"

#import "UIButton+JGJUIButton.h"

#import "JGJCommonButton.h"

#import "JGJHomeMaskView.h"

#import "UIView+GNUtil.h"

#define HightedAlpha 0.5

#define NormalAlpha 1.0

@interface JGJHomeAccountNoteCell ()

@property (weak, nonatomic) IBOutlet JGJCommonButton *noteButton;

@property (weak, nonatomic) IBOutlet JGJCommonButton *accountButton;

@property (weak, nonatomic) IBOutlet UILabel *acountTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *noteDes;

@property (weak, nonatomic) IBOutlet UILabel *myRecordNote;

@property (weak, nonatomic) IBOutlet UILabel *recordTypeDes;

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *recordDes;

@end

@implementation JGJHomeAccountNoteCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    TYWeakSelf(self);
    
    self.noteButton.buttonBlock = ^(UIButton *button) {
      
        CGFloat alpha = button.highlighted ? HightedAlpha : NormalAlpha;

        weakself.noteDes.alpha = alpha;
        
    };
    
    self.accountButton.buttonBlock = ^(UIButton *button) {
      
        CGFloat alpha = button.highlighted ? HightedAlpha : NormalAlpha;
        
        weakself.recordTypeDes.alpha = button.highlighted ? HightedAlpha : 0.7;
        
        weakself.myRecordNote.alpha = alpha;

    };
    
    self.backgroundColor = AppFontf1f1f1Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    [self.containView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.acountTypeLable.textColor = [UIColor whiteColor];
    
    self.noteDes.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
    self.myRecordNote.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
    self.recordDes.hidden = TYIS_IPHONE_5_OR_LESS;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)noteButtonPressed:(UIButton *)sender {
    
    if (self.cellBlock) {
        
        self.cellBlock(JGJHomeNoteButtonType);
    }

}

- (IBAction)accountButtonPressed:(UIButton *)sender {
    
    if (self.cellBlock) {
        
        self.cellBlock(JGJHomeAccountButtonType);
    }
}

@end
