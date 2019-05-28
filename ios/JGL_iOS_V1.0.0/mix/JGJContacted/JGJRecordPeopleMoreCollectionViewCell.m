//
//  JGJRecordPeopleMoreCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/9/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordPeopleMoreCollectionViewCell.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJRecordPeopleMoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headButton.userInteractionEnabled = NO;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)loadView{
    [self.headButton removeFromSuperview];
    
    self.headButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 9, 40, 40)];
    [self.contentView addSubview:self.headButton];
    
    [self.noTPLImageView removeFromSuperview];
    self.noTPLImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 18, 0, 18, 18)];
    self.noTPLImageView.image = [UIImage imageNamed:@"notheadImage"];
    [self.imageview removeFromSuperview];
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 9, 40, 40)];
    self.imageview.backgroundColor = [UIColor whiteColor];
    self.imageview.hidden = YES;
    [self.contentView addSubview:self.imageview];
    
    
    self.slectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 40, 40)];
    self.slectImageView.layer.borderWidth = 1.0;
//    self.slectImageView.layer.borderColor = AppFontEB4E4EColor.CGColor;
    [self.contentView addSubview:self.slectImageView];
    
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headButton.frame)+ 5.5, CGRectGetWidth(self.contentView.frame), 15)];
    self.nameLable.textColor =AppFont333333Color;
    self.nameLable.font = [UIFont systemFontOfSize:12];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLable];
    
    [self.contentView addSubview:self.noTPLImageView];

    
    UILongPressGestureRecognizer *longpressSesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHeadButton:)];
    longpressSesture.minimumPressDuration = .4;
    longpressSesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longpressSesture];
    
}


-(void)longPressHeadButton:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(JGJLongPressMoreCollectionAndIndexPath:)]) {
            [self.delegate JGJLongPressMoreCollectionAndIndexPath:self.indexpath];
        }
    }else {

    }

}

- (void)setListModelAddIsLittleWork:(JgjRecordMorePeoplelistModel *)listModel isLittleWorkOrContractorAttendance:(BOOL)isLittleWorkOrContractorAttendance {
    
    _nameLable.text = [self.nameLable sublistNameSurplusFour:listModel.name];
    
    UIColor *color = [NSString modelBackGroundColor:listModel.name];
    [self.headButton setMemberPicButtonWithHeadPicStr:listModel.head_pic memberName:listModel.name memberPicBackColor:color membertelephone:listModel.telph];
    
    self.headButton.titleLabel.font = FONT(AppFont32Size);
    
    self.headButton.userInteractionEnabled = NO;
    
    self.headButton.layer.masksToBounds = YES;
    
    self.headButton.layer.cornerRadius = 2.5;
    
    self.imageview.layer.masksToBounds = YES;
    
    self.imageview.layer.cornerRadius = 2.5;
    
    self.slectImageView.layer.masksToBounds = YES;
    self.slectImageView.layer.cornerRadius = 2.5;
    if (listModel.makeType == JGJMorePeopleMakeLittleWorkType) {
        
        self.slectImageView.image = [UIImage imageNamed:@"点工"];
    }else {
        
        self.slectImageView.image = [UIImage imageNamed:@"包工"];
    }
    if (listModel.isSelected) {
        
        self.slectImageView.hidden = NO;
        self.imageview.hidden = NO;
        self.imageview.alpha = .9;
        self.slectImageView.alpha = 1;
        self.headButton.layer.borderWidth = 0.5;
        
        if (listModel.makeType == JGJMorePeopleMakeLittleWorkType) {
            
            self.headButton.layer.borderColor = AppFontFF9933Color.CGColor;
            self.slectImageView.layer.borderColor = AppFontFF9933Color.CGColor;
            
        }else {
            
            self.headButton.layer.borderColor = AppFont22A0E8Color.CGColor;
            self.slectImageView.layer.borderColor = AppFont22A0E8Color.CGColor;
        }
        
    }else {
        
        self.slectImageView.hidden = YES;
        self.imageview.hidden = YES;
        self.headButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.headButton.layer.borderWidth = 0.5;
    }
    
    // 只要是选中 就显示选中的类型
    if (listModel.isSelected) {
        
        self.noTPLImageView.hidden = YES;
        self.slectImageView.hidden = NO;
        self.imageview.hidden = NO;
        self.imageview.alpha = .9;
        self.slectImageView.alpha = 1;
        self.headButton.layer.borderWidth = 0.5;
        
        if (listModel.makeType == JGJMorePeopleMakeLittleWorkType) {
            
            self.headButton.layer.borderColor = AppFontFF9933Color.CGColor;
            self.slectImageView.layer.borderColor = AppFontFF9933Color.CGColor;
            
        }else {
            
            self.headButton.layer.borderColor = AppFont22A0E8Color.CGColor;
            self.slectImageView.layer.borderColor = AppFont22A0E8Color.CGColor;
        }
        
    }else {
        
        // 当前选中点工
        if (isLittleWorkOrContractorAttendance) {
            
            if ([listModel.is_salary integerValue]) {
                
                self.noTPLImageView.hidden = YES;
                
            }else {
                
                self.noTPLImageView.hidden = NO;
                
                self.slectImageView.hidden = YES;
                self.imageview.hidden = YES;
                self.headButton.layer.borderColor = [UIColor clearColor].CGColor;
                self.headButton.layer.borderWidth = 0.5;
            }
            
        }
        // 当前选择包工记工天
        else {
            
            if (listModel.unit_quan_tpl == nil || ([listModel.unit_quan_tpl.w_h_tpl integerValue] == 0 && [listModel.unit_quan_tpl.o_h_tpl integerValue] == 0)) {
                
                self.noTPLImageView.hidden = NO;
                
                self.slectImageView.hidden = YES;
                self.imageview.hidden = YES;
                self.headButton.layer.borderColor = [UIColor clearColor].CGColor;
                self.headButton.layer.borderWidth = 0.5;
                
            }else {
                
                self.noTPLImageView.hidden = YES;
            }
        }
    }
}


- (void)setAddButton
{
    [self.headButton setImage:[UIImage imageNamed:@"menber_add_icon"] forState:UIControlStateNormal];
    self.headButton.userInteractionEnabled = NO;
    self.nameLable.text = @"添加";
    self.noTPLImageView.hidden = YES;
}

- (void)setDelButton
{
    [self.headButton setImage:[UIImage imageNamed:@"member_ minus_icon"] forState:UIControlStateNormal];
    self.headButton.userInteractionEnabled = NO;
    self.nameLable.text = @"删除";
    self.noTPLImageView.hidden = YES;
}
@end
