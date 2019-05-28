//
//  JLGRegisterSexTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGRegisterSexTableViewCell.h"

@interface JLGRegisterSexTableViewCell ()
{
    SexNum _sexNum;
}
@end

@implementation JLGRegisterSexTableViewCell



-(SexNum )getSexNum{
    return _sexNum?:1;//如果为0，默认返回1
}

- (void)setSexNum:(SexNum)sexNum{
    if (sexNum == _sexNum) {
        
//        return;
        sexNum = 1;
    }
    
    _sexNum = sexNum;

    SexNum sexNumFinal = sexNum == 1?2:1;
    UIButton *sender = [self viewWithTag:sexNum];
    UIButton *finalButton = [self viewWithTag:sexNumFinal];
    sender.selected = YES;
    finalButton.selected = NO;
}

- (IBAction)manBtnClick:(UIButton *)sender {
    if (sender.tag == _sexNum) {
        return;
    }
    
    UIButton *femaleButton = [self viewWithTag:2];
    femaleButton.selected = sender.selected;
    sender.selected = !sender.selected;
    
    [sender setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    _sexNum = SexMan;
    if (self.delegate && [self.delegate respondsToSelector:@selector(setSexNum:)]) {
        [self.delegate setSexNum:_sexNum];
    }
}

- (IBAction)femaleBtnClick:(UIButton *)sender {
    if (sender.tag == _sexNum) {
        return;
    }
    
    UIButton *manButton = [self viewWithTag:1];
    manButton.selected = sender.selected;
    sender.selected = !sender.selected;
    [sender setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];

    _sexNum = SexFemale;
    if (self.delegate && [self.delegate respondsToSelector:@selector(setSexNum:)]) {
        [self.delegate setSexNum:_sexNum];
    }
}

@end
