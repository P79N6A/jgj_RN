//
//  JGJShareImageMenuView.m
//  mix
//
//  Created by yj on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJShareImageMenuView.h"

@interface JGJShareImageMenuView ()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveImageBtn;

@property (weak, nonatomic) IBOutlet UIView *contentShareBtnView;


@end

@implementation JGJShareImageMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    
}

- (IBAction)shareButtonPressed:(UIButton *)sender {
    
    
}

@end
