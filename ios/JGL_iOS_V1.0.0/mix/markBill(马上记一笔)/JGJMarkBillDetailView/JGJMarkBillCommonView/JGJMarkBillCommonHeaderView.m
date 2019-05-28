//
//  JGJMarkBillCommonHeaderView.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillCommonHeaderView.h"

@implementation JGJMarkBillCommonHeaderView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadView];
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}

- (void)loadView{
    
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    [contentView setFrame:self.bounds];
    [self addSubview:contentView];
    [self initupImageButton:self.tinyButton];
    [self initupImageButton:self.contractBtn];
    [self initupImageButton:self.brrowBtn];
    [self initupImageButton:self.closeAccountBt];
    self.backgroundColor = AppFont3A3F4EColor;
    contentView.backgroundColor = AppFont3A3F4EColor;
    [self.tinyButton setImage:[UIImage imageNamed:@"tinyDefult"] forState:UIControlStateNormal];
    [self.tinyButton setImage:[UIImage imageNamed:@"markBilltiny"] forState:UIControlStateSelected];
    [self.tinyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.tinyButton setTitleColor:AppFont9FA1A8Color forState:UIControlStateNormal];
    [self.contractBtn setImage:[UIImage imageNamed:@"contractDefult"] forState:UIControlStateNormal];
    [self.contractBtn setImage:[UIImage imageNamed:@"contractNormal"] forState:UIControlStateSelected];
    [self.contractBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.contractBtn setTitleColor:AppFont9FA1A8Color forState:UIControlStateNormal];
    [self.brrowBtn setImage:[UIImage imageNamed:@"brrowDefult"] forState:UIControlStateNormal];
    [self.brrowBtn setImage:[UIImage imageNamed:@"brrowNormals"] forState:UIControlStateSelected];
    [self.brrowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.brrowBtn setTitleColor:AppFont9FA1A8Color forState:UIControlStateNormal];
    [self.closeAccountBt setImage:[UIImage imageNamed:@"closeAccount"] forState:UIControlStateNormal];
    [self.closeAccountBt setImage:[UIImage imageNamed:@"closeAccountNormal"] forState:UIControlStateSelected];
    [self.closeAccountBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.closeAccountBt setTitleColor:AppFont9FA1A8Color forState:UIControlStateNormal];
    self.tinyButton.selected = YES;
    self.contractBtn.selected = NO;
    self.brrowBtn.selected = NO;
    self.closeAccountBt.selected = NO;
    self.markBillClicKType = JGJMarkSelectTinyBtnType;
    [self addSubview:self.arrowUpImageView];
    
    [self animationArrowWithPage:0];

}

-(void)initupImageButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-30.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
- (IBAction)clickBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self setBtnStateFromBtn:button];

    if (button.tag == 1) {
        
        self.markBillClicKType = JGJMarkSelectTinyBtnType;
        self.tinyButton = sender;
        
    }else if (button.tag == 2){
        
        self.contractBtn = sender;
        self.markBillClicKType = JGJMarkSelectContractBtnType;

    }else if (button.tag == 3){
        
        self.brrowBtn = sender;
        self.markBillClicKType = JGJMarkSelectBrrowBtnType;

    }else{
        self.closeAccountBt = sender;
        self.markBillClicKType = JGJMarkSelectCloseAccountBtnType;

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMarkBillTopBtnWithType:)]) {
        [self.delegate clickMarkBillTopBtnWithType:self.markBillClicKType];
    }
    [self animationArrowWithPage:button.tag - 1];
}
- (void)setBtnStateFromBtn:(UIButton *)btn
{
    if (btn.tag == 1) {
        self.tinyButton.selected = YES;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = NO;
    }else if (btn.tag == 2){
        self.tinyButton.selected = NO;
        self.contractBtn.selected = YES;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = NO;
    }else if (btn.tag == 3){
        self.tinyButton.selected = NO;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = YES;
        self.closeAccountBt.selected = NO;
    }else{
        self.tinyButton.selected = NO;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = YES;
    }
    
}
- (void)setBtnStateFromBtnTag:(NSUInteger)tag
{
    if (tag == 0) {
        self.tinyButton.selected = YES;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = NO;
    }else if (tag == 1){
        self.tinyButton.selected = NO;
        self.contractBtn.selected = YES;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = NO;
    }else if (tag == 2){
        self.tinyButton.selected = NO;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = YES;
        self.closeAccountBt.selected = NO;
    }else{
        self.tinyButton.selected = NO;
        self.contractBtn.selected = NO;
        self.brrowBtn.selected = NO;
        self.closeAccountBt.selected = YES;
    }
    [self animationArrowWithPage:tag];

}

- (UIImageView *)arrowUpImageView
{
    if (!_arrowUpImageView) {
        _arrowUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74.5, 11, 5.5)];
        _arrowUpImageView.image = [UIImage imageNamed:@"switchOver"];
    }
    return _arrowUpImageView;
}
- (void)animationArrowWithPage:(NSUInteger)index
{
    CGRect rect = self.arrowUpImageView.frame;
    rect.origin.x = ((index +1) *2 -1)*(TYGetUIScreenWidth/8) - 5.5;
    [UIView animateWithDuration:0 animations:^{
        [self.arrowUpImageView setFrame:rect];
    }];
    
}
@end
