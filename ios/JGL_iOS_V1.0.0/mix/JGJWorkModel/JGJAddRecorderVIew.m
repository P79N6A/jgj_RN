//
//  JGJAddRecorderVIew.m
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddRecorderVIew.h"
#import "UILabel+GNUtil.h"
@implementation JGJAddRecorderVIew

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadViews];
    }
    return self;
}

-(void)loadViews{

    
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecorderView" owner:self options:nil]firstObject];
    [view setFrame:self.bounds];
    [self addSubview:view];
    [view addSubview:self.numlable];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _sureAddButton.layer.masksToBounds = YES;
    _sureAddButton.layer.cornerRadius = 5;
    _sureAddButton.backgroundColor = AppFontd7252cColor;
//    _recordLable.text = @"已选中0人";
//    [_recordLable markText:@"0" withColor:AppFontd7252cColor];
    
    
}
-(UILabel *)numlable
{
    if (!_numlable) {
    _numlable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)/2 - 10, 200, 20)];
    _numlable.font = [UIFont systemFontOfSize:14];
    _numlable.textColor = AppFont666666Color;
    }
    return _numlable;
}
-(void)setSelectPeopleNum:(NSString *)num
{
//    if (!_recordLable) {
//    _recordLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)/2 - 10, 100, 20)];
//    _recordLable.backgroundColor = [UIColor redColor];
//    }
    self.numlable.text = [NSString stringWithFormat:@"本次已选中 %@ 人",num];
    [self.numlable markText:num withColor:AppFontd7252cColor];
}
- (IBAction)ClickAddSureButton:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickAddRecorderButton)]) {
        [self.delegate clickAddRecorderButton];
    }
    [TYNotificationCenter postNotificationName:JLGSetRainer object:nil];
}
@end
