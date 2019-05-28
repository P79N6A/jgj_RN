//
//  JGJComHeaderView.m
//  mix
//
//  Created by yj on 2018/11/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComHeaderView.h"

#import "UILabel+GNUtil.h"

@interface JGJComHeaderView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selBtnW;

@end

@implementation JGJComHeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderVeiw:)];
    [self addGestureRecognizer:tap];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.titleLable.text = @"全选";
}

- (void)setIsShowAllSelBtn:(BOOL)isShowAllSelBtn {
    
    _isShowAllSelBtn = isShowAllSelBtn;
    
    self.selBtnW.constant = _isShowAllSelBtn ? 40 : 12;
    
    self.selBtn.hidden = !_isShowAllSelBtn;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.titleLable.text = title;
    
}

- (void)setCount:(NSString *)count {
    
    _count = count;
    
    [self.titleLable markText:count withColor:AppFontEB4E4EColor];
}

#pragma mark - 点击选中当前项目全体人员
- (void)handleTapHeaderVeiw:(UIGestureRecognizer *)tap {
    
    self.selBtn.selected = !self.selBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(headerView:isAllSel:)]) {
        
        [self.delegate headerView:self isAllSel:self.selBtn.selected];
        
    }
    
}

@end
