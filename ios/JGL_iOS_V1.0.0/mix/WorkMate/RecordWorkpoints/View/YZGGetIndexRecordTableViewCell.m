

//
//  YZGGetIndexRecordTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetIndexRecordTableViewCell.h"
#import "Masonry.h"
#import "NSDate+Extend.h"
#import "TYVerticalLabel.h"
#import "YZGRecordWorkpointTool.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@interface YZGGetIndexRecordTableViewCell ()

@property (assign,nonatomic) CGFloat dataViewConstraintR_OldFloat;

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet TYVerticalLabel *amoutDiffLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateChineseLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diffLabelLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteImageLayoutL;
@property (weak, nonatomic) IBOutlet UIImageView *modifyImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteImageLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataViewConstraintR;

@end


@implementation YZGGetIndexRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
#if 0
    self.amoutDiffLabel.text = @"有\n差\n账";
    [self.amoutDiffLabel.layer setLayerBorderWithColor:self.amoutDiffLabel.textColor width:0.5 ration:0.15];
    self.amoutDiffLabel.hidden = YES;
#endif
    
//    [self.dateChineseLabel.layer setLayerCornerRadiusWithRatio:0.05];
    self.dateChineseLabel.layer.masksToBounds = YES;
    self.dateChineseLabel.layer.cornerRadius = 2;
    [self.contentView addSubview:self.roleImageview];

    [self drawLine];
    self.deleteImageView.hidden = YES;
    self.amountsLabel.textColor = JGJMainColor;
    self.dataViewConstraintR_OldFloat = self.dataViewConstraintR.constant;
}
-(void)drawLine{
    CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
    shaplayer.strokeColor = AppFontdbdbdbColor.CGColor;
    shaplayer.fillColor = nil;
    //    shaplayer.path = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:CGPointMake(0, 0)];
    [triangle addLineToPoint:CGPointMake(TYGetUIScreenWidth - 20, 0)];
    shaplayer.path = triangle.CGPath;
    shaplayer.frame = self.lineLbale.bounds;
    shaplayer.lineWidth = 0.5f;
    
    shaplayer.lineCap = @"square";
    //    shaplayer.masksToBounds = YES;
    //    shaplayer.cornerRadius = 5;
    
    shaplayer.lineDashPattern = @[@4, @2];
    
    [self.lineLbale.layer addSublayer:shaplayer];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMateWorkitemsItems:(MateWorkitemsItems *)mateWorkitemsItems{
    _mateWorkitemsItems = mateWorkitemsItems;
    
    self.dateView.hidden = !self.isFirstCell;
    self.deleteImageView.hidden = !self.isDeleting || mateWorkitemsItems.modify_marking;
#if 0
    self.amoutDiffLabel.hidden = !mateWorkitemsItems.amounts_diff;
    if (mateWorkitemsItems.amounts_diff) {
        [self.amoutDiffLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView).multipliedBy(0.8);
        }];
    }else{//没有差账的时候隐藏
        [self.amoutDiffLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(self.contentView).multipliedBy(0.1);
        }];
    }
#endif
    if (mateWorkitemsItems.amounts_diff == 0) {
        self.modifyImage.hidden = YES;
  
    }else{
        self.modifyImage.hidden = NO;
        self.modifyImage.image = [UIImage imageNamed:@"chazhang"];

    }
//    switch (mateWorkitemsItems.modify_marking) {
//        case 0://没有查账,显示叉的图片
//        {
//            self.modifyImage.hidden = YES;
//            break;
//        }
//        case 2:
//        {
//            self.modifyImage.hidden = NO;
//            self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellOther"];
//            break;
//        }
//        case 3:
//        {
//            self.modifyImage.hidden = NO;
//            self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellMine"];
//            break;
//        }
//        default:
//            break;
//    }
    
//    self.bottomLineLayoutL.constant = self.isLastCell?0:self.nameLabelLayoutL.constant;

//    NSString *currentDate =  [NSDate stringFromDate:[NSDate date] format:@"yyyyMMdd"];
//    if (self.isFirstCell) {
//        NSString *dateStr = [NSString stringWithFormat:@"%@日", [mateWorkitemsItems.date substringWithRange:NSMakeRange(mateWorkitemsItems.date.length - 2, 2)]];
//        self.dateNumLabel.text = [mateWorkitemsItems.date isEqualToString:currentDate] ? @"今  日" : dateStr;
//        self.dateChineseLabel.text = mateWorkitemsItems.date_turn;
//    }else{
//        self.dateNumLabel.text = @"";
//        self.dateChineseLabel.text = @"";
//    }

    //设置中间的label
    if (mateWorkitemsItems.accounts_type.code != 1) {
        self.workTimeLable.text  = mateWorkitemsItems.accounts_type.txt;
    }else{
//        [YZGRecordWorkpointTool setLabel:self.accountTypeLabel manHour:mateWorkitemsItems.manhour overhour:mateWorkitemsItems.overtime];
        NSString *workStr;
        NSString *workManc;
        NSString *overStr;
        NSString *overManc;

        if (mateWorkitemsItems.is_rest) {
            
        workStr = @"上班 休息";
        workManc = @"";

        }/*else if (mateWorkitemsItems.show_line){
        
        workStr = @"-.-";
        workManc = @"";

        }*/else{
            
            if ((int)[mateWorkitemsItems.manhour floatValue] == [mateWorkitemsItems.manhour floatValue]) {
                workStr = [NSString stringWithFormat:@"上班 %d小时%@",(int)[mateWorkitemsItems.manhour floatValue],mateWorkitemsItems.manhour_text];
   
            }else{
                workStr = [NSString stringWithFormat:@"上班 %.1f小时%@",[mateWorkitemsItems.manhour floatValue],mateWorkitemsItems.manhour_text];
                
            
            }
//        workStr = [NSString stringWithFormat:@"上班 %@小时%@",mateWorkitemsItems.manhour,mateWorkitemsItems.manhour_text];
        
        workManc = mateWorkitemsItems.manhour_text ;

        }
        
        
        if ([mateWorkitemsItems.overtime?:@"0" floatValue] <= 0) {
            
        overStr = @"加班 无加班";
        overManc = @"";
            
        }else{
            
            if ((int)[mateWorkitemsItems.overtime floatValue] == [mateWorkitemsItems.overtime floatValue]) {
                overStr = [NSString stringWithFormat:@"加班 %d小时%@",(int)[mateWorkitemsItems.overtime floatValue],mateWorkitemsItems.overtime_text];
            }else{
                overStr = [NSString stringWithFormat:@"加班 %.1f小时%@",[mateWorkitemsItems.overtime floatValue],mateWorkitemsItems.overtime_text];
            }
            
//        overStr = [NSString stringWithFormat:@"加班 %@小时%@",mateWorkitemsItems.overtime,mateWorkitemsItems.overtime_text];
        overManc = mateWorkitemsItems.overtime_text;
            
        }
        
        
        
        
        [YZGRecordWorkpointTool setLabel:self.workTimeLable manHourTexts:workStr overhourTexts:overStr ManColor:workManc OverColor:overManc];

    }
    //2.1.1-yj删除之后形成差账显示--
    if (mateWorkitemsItems.amounts_diff && [mateWorkitemsItems.manhour isEqualToString:@"0"]) {
        self.accountTypeLabel.text = @"-.-";
    }
    BOOL isDayWork = false;
    if (mateWorkitemsItems.accounts_type.code == 3) {
        isDayWork = mateWorkitemsItems.accounts_type.code == 3;
 
    }
    if (mateWorkitemsItems.accounts_type.code == 4) {
        isDayWork = mateWorkitemsItems.accounts_type.code == 4;
    }
    
    _roleImageview.hidden = YES;

    if (mateWorkitemsItems.show_line) {
        
    self.amountsLabel.text = @"-.-";
        
    }else{
    
    CGFloat amounts = mateWorkitemsItems.amounts;
    amounts *= (isDayWork?-1:1);

    
    [YZGRecordWorkpointTool setLabel:self.amountsLabel amount:amounts];
    }
    
    
//    self.nameLabel.text = mateWorkitemsItems.worker_name;
    self.nameLabel.text = [self.nameLabel sublistNameSurplusFour:mateWorkitemsItems.worker_name];
    
    self.proNameLable.text = mateWorkitemsItems.pro_name;
    
    self.recordPeopleLable.text = [@"工头 " stringByAppendingString: [self.recordPeopleLable sublistNameSurplusFour:mateWorkitemsItems.foreman_name]?:@""];

    [self.recordPeopleLable markText:@"工头" withColor:AppFont999999Color];
    if (mateWorkitemsItems.amounts < 0) {
        self.amountsLabel.textColor = AppFont83C76EColor;
    }
    
    
//    if ([NSString isEmpty: mateWorkitemsItems.overtime]) {
//        self.workTimeLable.text = [[mateWorkitemsItems.manhour stringByAppendingString:mateWorkitemsItems.unit?:@""] stringByAppendingString:mateWorkitemsItems.manhour_text?:@""];
//        [self.workTimeLable markText:mateWorkitemsItems.manhour_text withColor:AppFont999999Color];
//
//    }else{
//        if ([mateWorkitemsItems.overtime intValue] == 0) {
//        self.workTimeLable.text = [[mateWorkitemsItems.manhour stringByAppendingString:mateWorkitemsItems.unit?:@""] stringByAppendingString:mateWorkitemsItems.manhour_text?:@""];
//            [self.workTimeLable markText:mateWorkitemsItems.manhour_text withColor:AppFont999999Color];
//        }else{
//        self.workTimeLable.text = [NSString stringWithFormat:@"%@%@%@\n加班%@%@%@",mateWorkitemsItems.manhour,mateWorkitemsItems.unit,mateWorkitemsItems.manhour_text?:@"",mateWorkitemsItems.overtime,mateWorkitemsItems.unit?:@"",mateWorkitemsItems.overtime_text?:@""];
//            [self.workTimeLable markText:mateWorkitemsItems.manhour_text withColor:AppFont999999Color];
//
//        }
//    }
    
    
//
//    if (mateWorkitemsItems.is_rest) {
//     self.workTimeLable.text = @"休息";
//        self.workTimeLable.textColor = AppFonte73bf5cColor;
//    }else{
////        self.workTimeLable.textColor = AppFont333333Color;
//    }
    
//    [YZGRecordWorkpointTool setLabel:self.workTimeLable manHourTexts:[NSString stringWithFormat:@"%@小时%@",mateWorkitemsItems.manhour,mateWorkitemsItems.manhour_text] overhourTexts:[NSString stringWithFormat:@"%@小时%@",mateWorkitemsItems.overtime,mateWorkitemsItems.overtime_text] ManColor:mateWorkitemsItems.manhour_text OverColor:mateWorkitemsItems.overtime_text];
//
    
    if (mateWorkitemsItems.accounts_type.code == 2) {
        self.workTimeLable.text =@"包工";

    }else if (mateWorkitemsItems.accounts_type.code == 3){
        self.workTimeLable.text =@"借支";

    }else if (mateWorkitemsItems.accounts_type.code == 4){
        self.workTimeLable.text =@"工资结算";

    }
//    [self.workTimeLable markText:@"(1个工)" withColor:AppFont999999Color];
    //删除编辑状态
    if (_isDeleting) {
        _nameConstance.constant = 38;

    }else{
        _nameConstance.constant = 3;
    }
    
    if (self.modifyImage.hidden) {
        _amoutConstance.constant = 12;
    }else{
        _amoutConstance.constant = 32;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isDeleting && self.mateWorkitemsItems.modify_marking == 0 && self.deleteImageLayoutL.constant != 10) {
        if (self.needAnimate) {
            [UIView animateWithDuration:0.5 animations:^{
                self.deleteImageLayoutL.constant = 15;
                self.dataViewConstraintR.constant = self.dataViewConstraintR_OldFloat/2;
                self.peoleftConstance.constant = self.nameConstance.constant + 85;
                self.lineLeftConstance.constant = self.nameConstance.constant + 10;
                [self.deleteImageView layoutIfNeeded];
            }];
        }else{
            self.deleteImageLayoutL.constant = 15;
            self.dataViewConstraintR.constant = self.dataViewConstraintR_OldFloat/2;
            self.peoleftConstance.constant = self.nameConstance.constant + 85;
            self.lineLeftConstance.constant = self.nameConstance.constant + 10;

            [self.deleteImageView layoutIfNeeded];
        }
    }else if(self.deleteImageLayoutL.constant != 0 ){
        self.deleteImageLayoutL.constant = 0;//这样就可以隐藏起来
        self.dataViewConstraintR.constant = self.dataViewConstraintR_OldFloat;
        self.peoleftConstance.constant = 90;
        self.lineLeftConstance.constant =  10;


    }
}

#pragma mark - 是否将删除的imageView设置为高亮显示,高亮就是删除
- (void)setDeleteImageViewHighlighted:(BOOL )highlighted{
    self.deleteImageView.highlighted = highlighted;
}
- (UIImageView *)roleImageview
{
    if (!_roleImageview) {
//        _roleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 - 10 - CGRectGetWidth(_accountTypeLabel.frame)/2 - CGRectGetWidth(_nameLabel.frame) - 10  , 0, 31, 14)];
        _roleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(35 + CGRectGetMaxX(_dateView.frame)- 4, 0, 31, 14)];

        _roleImageview.backgroundColor = [UIColor clearColor];
    }
    return _roleImageview;


}
@end
