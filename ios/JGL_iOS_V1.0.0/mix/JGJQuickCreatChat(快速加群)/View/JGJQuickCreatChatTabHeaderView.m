//
//  JGJQuickCreatChatTabHeaderView.m
//  mix
//
//  Created by yj on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatTabHeaderView.h"

@interface JGJQuickCreatChatTabHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation JGJQuickCreatChatTabHeaderView

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

-(void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;

    [self addSubview:self.contentView];
    
    self.contentView.backgroundColor = AppFontFDF1E0Color;

    [self.des.layer setLayerBorderWithColor:AppFontF07400Color width:1.0 radius:3.0];
    
}

- (IBAction)comInfoBtnPressed:(UIButton *)sender {
    
    if (self.tabHeaderViewBlock) {
        
        self.tabHeaderViewBlock();
    }
    
}

+(CGFloat)headerHeight {
    
    return 45.0;
}

@end
