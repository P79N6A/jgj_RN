//
//  JGJPlaceEditeView.m
//  JGJCompany
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPlaceEditeView.h"
#import "JGJDetailViewController.h"
@interface JGJPlaceEditeView()
{
    UIView *_holdView;

}
@end
@implementation JGJPlaceEditeView
-(void)awakeFromNib
{
    [super awakeFromNib];

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissmissSelfView) name:@"dissMissplceEditeview" object:nil];
        [self loadPlceView];
    }
    return self;
}
-(void)dissmissSelfView
{

}
-(void)loadPlceView
{
   _XibView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    [_XibView setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 160)];
    [self addSubview:_XibView];
    _holdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    _holdView.backgroundColor = [UIColor blackColor];
    _holdView.alpha = .4;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeselfView)];
    [_holdView addGestureRecognizer:tap];
    [self addSubview:_holdView];


    UIButton *editebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, TYGetUIScreenWidth, 49)];
    [editebutton addTarget:self action:@selector(clickEditeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editebutton];
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 51, TYGetUIScreenWidth, 49)];
    [deleteButton addTarget:self action:@selector(clickDeleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    UIButton *cancelbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 106, TYGetUIScreenWidth, 50)];
    [cancelbutton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelbutton];
}
-(void)clickcancelButtonsss
{
    [self removeFromSuperview];
    [_holdView removeFromSuperview];
    _holdView = nil;

}
-(void)removeselfView
{
    [self removeFromSuperview];
    [_holdView removeFromSuperview];
    _holdView = nil;

}
-(void)ShowviewWithVC
{
    [[[[[UIApplication sharedApplication]keyWindow]subviews ] lastObject]addSubview:_holdView];

    [[[[[UIApplication sharedApplication]keyWindow]subviews ] lastObject]addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -160);
    }];

}
- (IBAction)clickCancelButton:(id)sender {
    [self removeselfView];

}
- (IBAction)clickEditeButton:(id)sender {
    [self reomoveView];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickEditeButton)]) {
        [self.delegate clickEditeButton];
    }
}
- (IBAction)clickDeleButton:(id)sender {
    [self reomoveView];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickdeleteButton)]) {
        [self.delegate clickdeleteButton];
    }
}
-(void)reomoveView
{
    [self removeFromSuperview];
    [_holdView removeFromSuperview];
    _holdView = nil;
}
@end
