//
//  JGJCusAddMediaView.m
//  mix
//
//  Created by yj on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCusAddMediaView.h"

@interface JGJCusAddMediaView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJCusAddMediaView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (void)setSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    JGJCusAddMediaViewBtnType btnType = sender.tag - 100;
    
    self.btnType = btnType;
    
    if ([self.delegate respondsToSelector:@selector(cusAddMediaView:didSelBtnType:)]) {
        
        [self.delegate cusAddMediaView:self didSelBtnType:btnType];
    }
    
}


+(CGFloat)meidaViewHeight {
    
    return 125.0;
}

@end
