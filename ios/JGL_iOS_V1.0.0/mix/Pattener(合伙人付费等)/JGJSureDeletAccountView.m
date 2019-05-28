//
//  JGJSureDeletAccountView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSureDeletAccountView.h"

@implementation JGJSureDeletAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];

    }
    return self;
}
- (void)awakeFromNib
{
    [self initView];
    [super awakeFromNib];
}
- (void)initView{
    [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
}
- (IBAction)clickcancelButton:(id)sender {
    [self removeFromSuperview];
    self.sureBlock(NO);

}
- (IBAction)clickSureButton:(id)sender {
    [self removeFromSuperview];
    self.sureBlock(YES);
}
+(void)showDeleteSureButtonAlerViewandBlock:(sureDleteBlock)deleteButtons
{
    
    JGJSureDeletAccountView *deleteView = [[JGJSureDeletAccountView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication]keyWindow]addSubview:deleteView];
    deleteView.sureBlock = deleteButtons;

}
@end
