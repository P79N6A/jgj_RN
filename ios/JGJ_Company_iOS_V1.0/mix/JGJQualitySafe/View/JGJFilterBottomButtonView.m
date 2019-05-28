//
//  JGJFilterBottomButtonView.m
//  mix
//
//  Created by yj on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFilterBottomButtonView.h"

@interface JGJFilterBottomButtonView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation JGJFilterBottomButtonView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJFilterBottomButtonView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.leftButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    [self.leftButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius];
    
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.rightButton.layer setLayerCornerRadius:JGJCornerRadius];
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    if (titles.count == 2) {
        
        [self.leftButton setTitle:titles.firstObject forState:UIControlStateNormal];
        
        [self.rightButton setTitle:titles.lastObject forState:UIControlStateNormal];
    }
    
}

- (IBAction)bottomButtonPressed:(UIButton *)sender {
    
    JGJFilterBottomButtonType buttonType = sender.tag - 100;
    
    if (self.bottomButtonBlock) {
        
        self.bottomButtonBlock(buttonType);
    }
    
}


@end