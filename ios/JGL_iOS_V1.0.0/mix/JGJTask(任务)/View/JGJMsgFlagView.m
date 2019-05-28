//
//  JGJMsgFlagView.m
//  mix
//
//  Created by yj on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMsgFlagView.h"

@interface JGJMsgFlagView ()

@property (weak, nonatomic) IBOutlet UIButton *msgFlagButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJMsgFlagView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    
    UIButton *flagButton = [UIButton new];
    
    flagButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
//    flagButton.backgroundColor = [UIColor blueColor];
    
    [flagButton addTarget:self action:@selector(msgFlagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [flagButton setImage:[UIImage imageNamed:@"quality_msg_icon"] forState:UIControlStateNormal];
    
    [flagButton setImage:[UIImage imageNamed:@"quality_msg_icon"] forState:UIControlStateHighlighted];
    
    self.msgFlagButton = flagButton;
    
    CGFloat flagButtonWH = 50;
    
    CGFloat offsetX = self.width - flagButtonWH - 4;
    
    flagButton.frame = CGRectMake(offsetX, 0, flagButtonWH, flagButtonWH);
    
    [self addSubview:flagButton];
    
    UIView *flagView = [UIView new];
    
    self.flagView = flagView;
    
    flagView.frame = CGRectMake(self.width - JGJRedFlagWH + 2, 9, JGJRedFlagWH, JGJRedFlagWH);
    
    [self addSubview:flagView];
    
//xcode 9 5s上面显示不对
//    [[[NSBundle mainBundle] loadNibNamed:@"JGJMsgFlagView" owner:self options:nil] lastObject];
//
//    self.contentView.frame = self.bounds;
//
//    [self addSubview:self.contentView];
    
    [self.flagView.layer setLayerCornerRadius:JGJRedFlagWH / 2.0];
    
    self.msgFlagButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, -38);
    
    self.flagView.backgroundColor = AppFontEB4E4EColor;
    
}

- (void)setHiddenFlagView:(BOOL)isHidden {
    
    self.flagView.hidden = isHidden;
    
}

- (IBAction)msgFlagButtonPressed:(UIButton *)sender {
    
    if (self.msgFlagViewBlock) {
        
        self.msgFlagViewBlock();
    }
    
}

@end
