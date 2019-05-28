//
//  JGJNewCreatCheckItemAddView.m
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNewCreatCheckItemAddView.h"

@implementation JGJNewCreatCheckItemAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    
    return self;
}
- (void)initView{
    
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"JGJNewCreatCheckItemAddView" owner:self options:nil]firstObject];
    
    [contentView setFrame:self.bounds];
    self.createButton.layer.masksToBounds = YES;
    self.createButton.layer.cornerRadius = 5;
    self.createButton.layer.borderWidth = 1;
    self.createButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    
    [self addSubview:contentView];
    

}
+ (JGJNewCreatCheckItemAddView *)showView:(UIView *)view andBlock:(clickCreatBlock)response
{
    JGJNewCreatCheckItemAddView *newAddview =[[JGJNewCreatCheckItemAddView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 115)];
    
    newAddview.creatBlock = response;
    
    return newAddview;

}
- (IBAction)clickAddBtn:(id)sender {
    self.creatBlock(@"");
}
@end
