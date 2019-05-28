//
//  JGJTabPaddingView.m
//  mix
//
//  Created by yj on 2018/6/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTabPaddingView.h"

@interface JGJTabPaddingView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJTabPaddingView

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

+(instancetype)tabPaddingView {
    
    return [[self alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJTabPaddingView" owner:self options:nil] lastObject];
    
    self.containView.backgroundColor = AppFontf1f1f1Color;
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
}
@end
