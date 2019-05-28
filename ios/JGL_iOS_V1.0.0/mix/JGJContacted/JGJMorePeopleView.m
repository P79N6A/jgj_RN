//
//  JGJMorePeopleView.m
//  mix
//
//  Created by Tony on 2017/10/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMorePeopleView.h"

@implementation JGJMorePeopleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadView];
    }
    return self;
}

- (void)loadView{

    
    _chioceBtn = [[UIButton alloc]initWithFrame:self.frame];
    
    _chioceBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_chioceBtn addTarget:self action:@selector(clickChioceProBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_chioceBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];

    [self addSubview:_chioceBtn];

}
- (void)clickChioceProBtn:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickChioceBtn)]) {
        [self.delegate ClickChioceBtn];
    }
}

-(void)setproTitle:(NSString *)title
{
    [_chioceBtn setTitle:title forState:UIControlStateNormal];
//    [_chioceBtn setImage:[UIImage imageNamed:@"mainBillarrow"] forState:UIControlStateNormal];
     _chioceBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
//     CGFloat imageWidth = _chioceBtn.imageView.bounds.size.width;
//     CGFloat labelWidth = _chioceBtn.titleLabel.bounds.size.width;
//     _chioceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 15, 0, -labelWidth);
//     _chioceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth , 0, imageWidth);
//    _chioceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - _chioceBtn.titleLabel.frame.size.width - 10, 0, 0);
    
}

@end
