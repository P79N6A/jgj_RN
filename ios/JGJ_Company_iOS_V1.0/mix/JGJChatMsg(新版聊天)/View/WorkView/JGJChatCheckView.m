//
//  JGJChatCheckView.m
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatCheckView.h"

@interface JGJChatCheckView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JGJChatCheckView

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
    
}

- (void)setTitle:(NSString *)title {
    
    _titleLabel.text = title;
}

@end
