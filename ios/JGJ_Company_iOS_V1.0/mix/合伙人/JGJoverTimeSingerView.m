//
//  JGJoverTimeSingerView.m
//  JGJCompany
//
//  Created by Tony on 2017/8/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJoverTimeSingerView.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJoverTimeSingerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [TYNotificationCenter addObserver:self selector:@selector(removeSelfViewAction) name:JLGLoginFail object:nil];

    }
    
    return self;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    
}
-(void)initView
{
    
    [[[NSBundle mainBundle]loadNibNamed:@"JGJoverTimeSingerView" owner:self options:nil] firstObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfViewAction)];
    [self.contentView addGestureRecognizer:tap];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    [self.contentView setFrame:self.frame];
    [self addSubview:self.contentView];
}
+(void)showOverTimeViewWithModel:(JGJOverTimeModel *)timeModel andClickIkwonButton:(IkownBlock)cancelBlock
{
    
    JGJoverTimeSingerView *timeView = [[JGJoverTimeSingerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [timeView.IkownButton setTitle:timeModel.buttonArr[0] forState:UIControlStateNormal];
    timeView.cancelBlock = cancelBlock;
    [timeView.contentLable SetLinDepart:6];
    [timeView.contentLable markText:@"[项目设置]" withColor:AppFontEB4E4EColor];
    [[[UIApplication sharedApplication ]keyWindow ]addSubview:timeView];


}

- (IBAction)clickIkownButton:(id)sender {
    self.cancelBlock(@"ikown");
    [self removeView];

}
-(void)removeSelfViewAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [self removeView];
}
- (void)removeView{
    [UIView animateWithDuration:.15 animations:^{
        [self removeFromSuperview];
    }];
    
}
@end
