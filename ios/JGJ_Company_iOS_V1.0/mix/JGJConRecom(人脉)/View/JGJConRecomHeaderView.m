//
//  JGJConRecomHeaderView.m
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJConRecomHeaderView.h"

@interface JGJConRecomHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *conRecomButton;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *freshFriendFlagView;

@end

@implementation JGJConRecomHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJConRecomHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;

    [self addSubview:self.containView];

    self.topLineView.backgroundColor = AppFontEBEBEBColor;
    
    [_freshFriendFlagView.layer setLayerCornerRadius:JGJRedFlagWH / 2];
    
    _freshFriendFlagView.backgroundColor = AppFontFF0000Color;
    
    _freshFriendFlagView.hidden = YES;
    
    [self.conRecomButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.conRecomButton.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
}

- (void)setIsCheckFreshFriend:(BOOL)isCheckFreshFriend {
    
    _isCheckFreshFriend = isCheckFreshFriend;
    
    self.freshFriendFlagView.hidden = isCheckFreshFriend;
    
}

- (IBAction)conRecomButtonPressed:(UIButton *)sender {
    
    if (self.conRecomHeaderViewBlock) {
        
        self.conRecomHeaderViewBlock(self);
    }
    
}

@end
