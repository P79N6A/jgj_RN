//
//  JGJCheckStaFooterView.m
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckStaFooterView.h"

@interface JGJCheckStaFooterView()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnH;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;


@end

@implementation JGJCheckStaFooterView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJCheckStaFooterView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.containView.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)setIs_hidden_checkBtn:(BOOL)is_hidden_checkBtn {
    
    _is_hidden_checkBtn = is_hidden_checkBtn;
    
    self.checkBtnH.constant = is_hidden_checkBtn ? 42 : 10;

    self.checkBtn.hidden = is_hidden_checkBtn;
}

- (IBAction)checkMoreStaPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(checkStaFooterView:)]) {
        
        [self.delegate checkStaFooterView:self];
    }
    
}


@end
