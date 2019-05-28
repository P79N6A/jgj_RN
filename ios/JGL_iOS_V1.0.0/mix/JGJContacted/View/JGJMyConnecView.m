//
//  JGJMyConnecView.m
//  mix
//
//  Created by yj on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyConnecView.h"

@interface JGJMyConnecView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation JGJMyConnecView

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
    
}


- (IBAction)checkBtnPressed:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock();
        
    }
    
}

@end
