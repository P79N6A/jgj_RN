//
//  JGJQuickCreatChatHeaderView.m
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatHeaderView.h"

#import "UILabel+GNUtil.h"

@interface JGJQuickCreatChatHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterY;

@end

@implementation JGJQuickCreatChatHeaderView

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
    
    self.des.textColor = AppFont666666Color;
    
    self.title.font = [UIFont boldSystemFontOfSize:AppFont30Size];
}

- (void)setHeaderViewModel:(JGJQuickCreatChatHeaderViewModel *)headerViewModel {
    
    _headerViewModel = headerViewModel;
    
    self.title.textColor = headerViewModel.titleColor;
    
    self.icon.image = [UIImage imageNamed:headerViewModel.icon];
    
    self.title.text = [NSString stringWithFormat:@"%@%@",headerViewModel.title, headerViewModel.remark?:@""];
    
    self.des.text = headerViewModel.des?:@"";
    
    self.titleCenterY.constant = [NSString isEmpty:headerViewModel.des] ? 0 : -10;
    
    if (![NSString isEmpty:headerViewModel.remark]) {
                
        [self.title markText:headerViewModel.remark withFont:[UIFont systemFontOfSize:AppFont24Size] color:AppFontEB4E4EColor];
    }
    
}

@end
