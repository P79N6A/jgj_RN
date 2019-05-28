//
//  JGJQuickCreatChatFooterView.m
//  mix
//
//  Created by yj on 2019/3/12.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatFooterView.h"

#import "UIButton+JGJUIButton.h"

@interface JGJQuickCreatChatFooterView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;


@end

@implementation JGJQuickCreatChatFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    [self.actionBtn.layer setLayerBorderWithColor:AppFont000000Color width:1 radius:15];
    
    self.actionBtn.backgroundColor = AppFontf1f1f1Color;
    
    [self.actionBtn setEnlargeEdgeWithTop:50 right:50 bottom:20 left:50];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
}

- (IBAction)compleInfoBtnPressed:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock();
        
    }
    
}


@end
