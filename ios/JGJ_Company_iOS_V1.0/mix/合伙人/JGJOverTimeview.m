//
//  JGJOverTimeview.m
//  JGJCompany
//
//  Created by Tony on 2017/8/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOverTimeview.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@implementation JGJOverTimeview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
        [TYNotificationCenter addObserver:self selector:@selector(removeSelfViewAction) name:JLGLoginFail object:nil];
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
    [super awakeFromNib];
    [self initView];

}
- (void)initView
{

    [[[NSBundle mainBundle]loadNibNamed:@"JGJOverTimeview" owner:self options:nil] firstObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelfViewAction)];
    [self.contentView addGestureRecognizer:tap];
    [self.contentView setFrame:self.bounds];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    [self addSubview:self.contentView];
    
    [self.singerButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    

}
- (IBAction)clicktoverTimeViewButton:(id)sender {
    UIButton *button = (UIButton *)sender;

    if (button.tag == 1) {
        self.cancelBlock(@"cancelButton");
    }else{
        self.OKblock(@"okButton");
    }
    [self removeView];


}
- (IBAction)clickSingerButton:(id)sender {
    
    self.OKblock(@"okButton");
    
    [self removeView];
 
}
+ (void)showOverTimeViewWithModel:(JGJOverTimeModel *)timeModel andClickCancelButton:(cancelBlock)cancelBlock andClickOKButton:(OKBlock)okBlock
{
//    NSString *obj = [TYUserDefaults objectForKey:JLGOverTimeShow];
//    if ([NSString isEmpty:obj] || timeModel.showView) {
//    [TYUserDefaults setObject:@"hadShow" forKey:JLGOverTimeShow];
//    }else{
//    return;
//    }
    
    
    JGJOverTimeview *timeView = [[JGJOverTimeview alloc]initWithFrame:[UIScreen mainScreen].bounds];
    timeView.tiplable.text = timeModel.tipStr;
    timeView.pronameLbale.text = timeModel.proNameStr;
//    timeView.contentLable.text = [NSString stringWithFormat:@"%@\n%@",timeModel.proNameStr,timeModel.contentStr];
    timeView.contentLable.text = [NSString stringWithFormat:@"%@",timeModel.contentStr];

    if (timeModel.cloudType) {
        timeView.pronameLbale.text = timeModel.proNameStr;
        timeView.contentLable.text = [NSString stringWithFormat:@"%@\n%@",timeModel.contentStr,timeModel.contentSubStr];
//        [timeView.contentLable markText:timeModel.contentSubStr withColor:AppFontEB4E4EColor];
        [timeView.contentLable markText:timeModel.contentSubStr?:@"" withFont:[UIFont systemFontOfSize:14] color:AppFontEB4E4EColor];
        
        timeView.contentLable.textAlignment = NSTextAlignmentCenter;

    }
    if (timeModel.buttonArr.count == 1) {
        [timeView.singerButton setTitle:timeModel.buttonArr[0] forState:UIControlStateNormal];
    }else{
        timeView.singerButton.hidden = YES;
        [timeView.cancelButton setTitle:timeModel.buttonArr[0] forState:UIControlStateNormal];
        [timeView.OKblock setTitle:timeModel.buttonArr[1] forState:UIControlStateNormal];
    }
    
    timeView.contentLable.textAlignment = NSTextAlignmentCenter;

    timeView.cancelBlock = cancelBlock;
    timeView.OKblock = okBlock;
    [[[UIApplication sharedApplication ]keyWindow ]addSubview:timeView];

}
- (void)removeSelfViewAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [self removeView];

}
- (void)removeView{
    
    [UIView animateWithDuration:.2 animations:^{
    [self removeFromSuperview];
     }];
}
@end
