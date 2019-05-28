//
//  YZGAddFmNoContactsView.m
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAddFmNoContactsView.h"
#import "UILabel+GNUtil.h"

@interface YZGAddFmNoContactsView ()
{
    NSArray *_addButtonContentArray;
    NSArray *_tipLabelContentArray;
}

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation YZGAddFmNoContactsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    
    _addButtonContentArray = @[@"添加工人",@"添加班组长/工头"];
    NSArray *remarks = @[@"赶紧添加工人", @"赶紧添加班组长/工头"];
    _tipLabelContentArray = @[@"联系表中暂时没有工人的信息\n赶紧添加工人",@"联系表中暂时没有班组长/工头的信息\n赶紧添加班组长/工头"];
    self.tipLabel.text = _tipLabelContentArray[!JLGisLeaderBool];
    [self.tipLabel markLineText:remarks[!JLGisLeaderBool] withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFont999999Color lineSpace:5];
    [self.addButton setTitle:_addButtonContentArray[!JLGisLeaderBool] forState:UIControlStateNormal];
    self.addButton.backgroundColor = AppFontd7252cColor;
    [self addSubview:self.contentView];
    
//    [self InitbottomButton];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.addButton.layer setLayerCornerRadius:4];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(YZGAddFmNoViewBtnClick:)]) {
        [self.delegate YZGAddFmNoViewBtnClick:self];
    }
}

- (void)showAddFmNoContactsView{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
}

- (void)hiddenAddFmNocontactsView{
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self removeFromSuperview];
    }
}
//一天几多人按钮

@end
