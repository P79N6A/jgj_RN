//
//  JGJProListBottomView.m
//  JGJCompany
//
//  Created by YJ on 2017/8/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProListBottomView.h"

@interface JGJProListBottomView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIView *contentSubView;

@end

@implementation JGJProListBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJProListBottomView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.containView.backgroundColor = AppFontf1f1f1Color;
    
    for (UIButton *subButton in self.containView.subviews) {
        
        if ([subButton isKindOfClass:[UIButton class]]) {
           
            [subButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
            
            subButton.backgroundColor = AppFontf1f1f1Color;
        }
        
    }

}

@end
