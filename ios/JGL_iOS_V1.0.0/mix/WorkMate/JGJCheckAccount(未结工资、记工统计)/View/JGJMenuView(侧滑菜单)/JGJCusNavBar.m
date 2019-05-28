//
//  JGJCusNavBar.m
//  mix
//
//  Created by yj on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusNavBar.h"

@interface JGJCusNavBar ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterY;

@end

@implementation JGJCusNavBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJCusNavBar" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.containView.backgroundColor = AppFontfafafaColor;
    
    self.title.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.title.textColor = AppFont333333Color;
    
    self.title.textColor = AppFont333333Color;
    
    if (TYIST_IPHONE_X) {
        
        self.titleCenterY.constant = 0;
        
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    if (self.backBlock) {
        
        self.backBlock();
    }
    
}


@end
