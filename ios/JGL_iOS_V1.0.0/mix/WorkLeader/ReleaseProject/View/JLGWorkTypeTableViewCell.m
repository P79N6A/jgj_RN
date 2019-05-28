//
//  JLGWorkTypeTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGWorkTypeTableViewCell.h"

#import "TYFMDB.h"
#import "NSString+JSON.h"
#import "JLGDashedLine.h"
#import "CALayer+SetLayer.h"

#define JLGWorkTypeLineWitdh 0.5//线框的粗细

//定义按钮的类
@interface JLGWorkTypeButton : UIButton
@end
@implementation JLGWorkTypeButton : UIButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.layer setLayerBorderWithColor:TYColorHex(0x8b8b8b) width:JLGWorkTypeLineWitdh radius:4.0];
        [self setTitleColor:TYColorHex(0x8b8b8b) forState:UIControlStateNormal];
        [self setTitleColor:JGJMainColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.backgroundColor = selected?[UIColor whiteColor]:TYColorHex(0xededed);
    UIColor *borderColor = selected?JGJMainColor:TYColorHex(0x8b8b8b);
    [self.layer setLayerBorderWithColor:borderColor width:JLGWorkTypeLineWitdh radius:2.5];
}
@end

//最长的垂直的虚线高度
#define HdrashLineHeight 163

#define experienceBaseNum 32
@interface JLGWorkTypeTableViewCell ()
<
    UITextFieldDelegate
>
{
    NSUInteger _experienceSelectedNum;
    NSUInteger _cooperateSelectedNum;//0是点工 1是包工
    NSUInteger _areaSelectedNum;//0是平方 1是立方 2是米 3是吨
    NSUInteger _settleSelectedNum;//结账方式 0天结 1月结
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *RewardLabel;//显示报酬的label
@property (weak, nonatomic) IBOutlet UIView *rightFirstView;//显示是平方的view
@property (weak, nonatomic) IBOutlet UIView *rightSecondView;//显示是天结的view

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumAndPriceLabel;

@end


@implementation JLGWorkTypeTableViewCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //初始化button
    JLGWorkTypeButton *experienceButton = [self.contentView viewWithTag:11];
    [self topViewBtnClick:experienceButton];
    JLGWorkTypeButton *cooperateButton = [self.contentView viewWithTag:21];
    [self cooperateBtnClick:cooperateButton];
    JLGWorkTypeButton *areaButton = [self.contentView viewWithTag:31];
    [self areaBtnClick:areaButton];
    JLGWorkTypeButton *settleButton = [self.contentView viewWithTag:41];
    [self settleBtnClick:settleButton];
    
    //画线
    [self drawLineDash];
    
    [self.moneyTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.personNumTF addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    self.moneyTF.delegate = self;
    self.personNumTF.delegate = self;
    
    self.moneyTF.textColor = JGJMainColor;
    self.personNumTF.textColor = JGJMainColor;
    self.RewardLabel.textColor = JGJMainColor;
}

- (void)dealloc{
    [self endEditing:YES];
}

- (void) textChangeAction:(UITextField *) textField {
    if (textField.tag == 52) {
        self.RewardLabel.hidden = textField.text.length > 0?NO:YES;
        NSString *appendingString;
        if (_cooperateSelectedNum == 0) {
            appendingString = _settleSelectedNum == 0?@"天":@"月";
        }else if(_cooperateSelectedNum == 1){
            JLGWorkTypeButton *jlgWorkTypeButton = [self.contentView viewWithTag:31+_areaSelectedNum];
            appendingString = jlgWorkTypeButton.titleLabel.text;
        }
        self.RewardLabel.text = [NSString stringWithFormat:@"%@元/%@",textField.text,appendingString];
    }

    if (textField.tag == 51) {
        //personcount
        self.rpBaseClasses.person_count = textField.text;
    }else if(textField.tag == 52){
        //money
        self.rpBaseClasses.money = textField.text;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWorkType:index:)]) {
        [self.delegate selectedWorkType:self.rpBaseClasses index:self.tag];
    }
}

- (void)drawLineDash{
    //水平线
    CGPoint firstHPoit = CGPointMake(CGRectGetMinX(self.experienceLabel.frame), CGRectGetMinY(self.experienceLabel.frame));
    [JLGDashedLine drashHorizontalLineInView:self.contentView byPoint:firstHPoit byWith:TYGetUIScreenWidth];
    
    CGPoint secondHPoit = CGPointMake(CGRectGetMinX(self.experienceLabel.frame), CGRectGetMaxY(self.experienceLabel.frame));
    [JLGDashedLine drashHorizontalLineInView:self.contentView byPoint:secondHPoit byWith:TYGetUIScreenWidth];
    
    CGPoint thirdHPoit = CGPointMake(CGRectGetMinX(self.personNumAndPriceLabel.frame), CGRectGetMinY(self.personNumAndPriceLabel.frame));
    [JLGDashedLine drashHorizontalLineInView:self.contentView byPoint:thirdHPoit byWith:TYGetUIScreenWidth];
    
    CGPoint fourthHPoit = CGPointMake(CGRectGetMinX(self.personNumAndPriceLabel.frame), CGRectGetMaxY(self.personNumAndPriceLabel.frame));
    [JLGDashedLine drashHorizontalLineInView:self.contentView byPoint:fourthHPoit byWith:TYGetUIScreenWidth];
    
    //垂直线
    CGPoint firstVPoit = CGPointMake(CGRectGetMaxX(self.experienceLabel.frame), CGRectGetMinY(self.experienceLabel.frame));
    [JLGDashedLine drashVerticalLineInView:self.contentView byPoint:firstVPoit byHeight:HdrashLineHeight];
    
    CGPoint secondVPoit = CGPointMake(CGRectGetMidX(self.middleView.frame), CGRectGetMinY(self.middleView.frame));
    [JLGDashedLine drashVerticalLineInView:self.contentView byPoint:secondVPoit byHeight:TYGetViewH(self.middleView)];
}


- (void)setRpBaseClasses:(RPBaseClasses *)rpBaseClasses{
    _rpBaseClasses = rpBaseClasses;
    //没有数据的情况
    if (rpBaseClasses.money == nil || [rpBaseClasses.money isEqualToString:@""]) {
        self.moneyTF.text = @"";
        self.personNumTF.text = @"";
        self.RewardLabel.hidden = YES;
    }

    //设置标题
    self.titleLabel.text = rpBaseClasses.worktypeName;
    
    _experienceSelectedNum = (rpBaseClasses.worklevel - experienceBaseNum);//原因是学徒工是从32开始的
    //设置经验状态
    JLGWorkTypeButton *experienceButton = [self.contentView viewWithTag:_experienceSelectedNum + 11];
    [self topViewBtnClick:experienceButton];
    
    _cooperateSelectedNum = (rpBaseClasses.cooperate_range - 1);//:1是点工，2是包工
    //设置计价方式状态
    JLGWorkTypeButton *cooperateButton = [self.contentView viewWithTag:_cooperateSelectedNum + 21];
    [self cooperateBtnClick:cooperateButton];

    if ([rpBaseClasses.balanceway isEqualToString:@"平方"]) {
        _areaSelectedNum = 0;
    }else if([rpBaseClasses.balanceway isEqualToString:@"立方"]){
        _areaSelectedNum = 1;
    }else if([rpBaseClasses.balanceway isEqualToString:@"米"]){
        _areaSelectedNum = 2;
    }else if([rpBaseClasses.balanceway isEqualToString:@"吨"]){
        _areaSelectedNum = 3;
    }
    
    //设置面积状态
    JLGWorkTypeButton *areaButton = [self.contentView viewWithTag:_areaSelectedNum + 31];
    [self areaBtnClick:areaButton];
    
    //设置日结月结
    if ([rpBaseClasses.balanceway isEqualToString:@"日"]) {
        _settleSelectedNum = 0;
    }else if([rpBaseClasses.balanceway isEqualToString:@"月"]){
        _settleSelectedNum = 1;
    }
    
    JLGWorkTypeButton *settleButton = [self.contentView viewWithTag:_settleSelectedNum +41];
    [self settleBtnClick:settleButton];


    self.moneyTF.text = rpBaseClasses.money;
    self.personNumTF.text = rpBaseClasses.person_count;

    [self textChangeAction:self.moneyTF];
}

//经验
- (IBAction)topViewBtnClick:(JLGWorkTypeButton *)sender {
    NSInteger baseTag = 11;
    NSInteger tag = sender.tag - baseTag;
    for (NSInteger i = 0; i < 4 ; i++) {
        JLGWorkTypeButton *button = [ self.contentView viewWithTag:i + baseTag];
        if (i == tag) {
            button.selected = YES;
            _experienceSelectedNum = i;
        }else{
            button.selected = NO;
        }
    }
    
    self.rpBaseClasses.worklevel = _experienceSelectedNum + experienceBaseNum;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWorkType:index:)]) {
        [self.delegate selectedWorkType:self.rpBaseClasses index:self.tag];
    }
}

//包工，点工
- (IBAction)cooperateBtnClick:(JLGWorkTypeButton *)sender {
    NSInteger baseTag = 21;
    NSInteger tag = sender.tag - baseTag;
    for (NSInteger i = 0; i < 2 ; i++) {
        JLGWorkTypeButton *button = [ self.contentView viewWithTag:i + baseTag];
        if (i == tag) {
            button.selected = YES;
            _cooperateSelectedNum = i;
        }else{
            button.selected = NO;
        }
    }
    
    if (tag == 1) {
        self.rightSecondView.hidden = YES;
        self.rightFirstView.hidden = NO;
    }else{
        self.rightSecondView.hidden = NO;
        self.rightFirstView.hidden = YES;
    }
    
    self.rpBaseClasses.cooperate_range = sender.tag - 20;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWorkType:index:)]) {
        [self.delegate selectedWorkType:self.rpBaseClasses index:self.tag];
    }
}

//平方，立方
- (IBAction)areaBtnClick:(JLGWorkTypeButton *)sender {
    NSInteger baseTag = 31;
    NSInteger tag = sender.tag - baseTag;
    for (NSInteger i = 0; i < 4 ; i++) {
        JLGWorkTypeButton *button = [ self.contentView viewWithTag:i + baseTag];
        if (i == tag) {
            button.selected = YES;
            _areaSelectedNum = i;
        }else{
            button.selected = NO;
        }
    }
    
    self.rpBaseClasses.balanceway = sender.titleLabel.text;
    if([self.RewardLabel.text rangeOfString:@"/"].location != NSNotFound)
    {
        NSRange range = [self.RewardLabel.text rangeOfString:@"/"];
        NSString *subString = [self.RewardLabel.text substringWithRange:NSMakeRange(0, range.location)];
        self.RewardLabel.text = [NSString stringWithFormat:@"%@/%@",subString,self.rpBaseClasses.balanceway];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWorkType:index:)]) {
        [self.delegate selectedWorkType:self.rpBaseClasses index:self.tag];
    }
}

//日结，月结
- (IBAction)settleBtnClick:(JLGWorkTypeButton *)sender {
    NSInteger baseTag = 41;
    NSInteger tag = sender.tag - baseTag;
    for (NSInteger i = 0; i < 2 ; i++) {
        JLGWorkTypeButton *button = [ self.contentView viewWithTag:i + baseTag];
        if (i == tag) {
            button.selected = YES;
            _settleSelectedNum = i;
        }else{
            button.selected = NO;
        }
    }
    

    //balanceway
    NSString *balancewayString = [sender.titleLabel.text substringWithRange:NSMakeRange(0, 1)];
    if (_cooperateSelectedNum == 0) {//点包
        self.rpBaseClasses.balanceway = [balancewayString isEqualToString:@"日"]?@"天":balancewayString;
    }else{
        self.rpBaseClasses.balanceway = balancewayString;
    }
    
    if([self.RewardLabel.text rangeOfString:@"/"].location != NSNotFound)
    {
        NSRange range = [self.RewardLabel.text rangeOfString:@"/"];
        NSString *subString = [self.RewardLabel.text substringWithRange:NSMakeRange(0, range.location)];
        self.RewardLabel.text = [NSString stringWithFormat:@"%@/%@",subString,self.rpBaseClasses.balanceway];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedWorkType:index:)]) {
        [self.delegate selectedWorkType:self.rpBaseClasses index:self.tag];
    }
}

- (IBAction)deleteCell:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteWorkTypeCell:)]) {
        [self.delegate deleteWorkTypeCell:self.tag];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 51 || textField.tag == 52) {
        NSInteger selectedIndex = textField.tag - 51;
        if (self.delegate && [self.delegate respondsToSelector:@selector(textReturnCell:CellIndex:selectedIndex:)]) {
            [self.delegate textReturnCell:self CellIndex:self.tag selectedIndex:selectedIndex];
        }
        [textField resignFirstResponder];
    }
    return YES;
}
@end
