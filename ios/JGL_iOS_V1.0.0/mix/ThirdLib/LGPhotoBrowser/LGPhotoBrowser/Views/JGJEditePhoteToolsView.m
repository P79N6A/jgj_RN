//
//  JGJEditePhoteToolsView.m
//  mix
//
//  Created by Tony on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJEditePhoteToolsView.h"

@interface JGJEditePhoteToolsView ()

@property (nonatomic, strong) UIButton *edite;
@end
@implementation JGJEditePhoteToolsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    
    [self addSubview:self.edite];
}

- (UIButton *)edite {
    
    if (!_edite) {
        
        _edite = [UIButton buttonWithType:UIButtonTypeCustom];
        _edite.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
        _edite.frame = CGRectMake(self.size.width / 2 - 30, 10, 60, 20);
        [_edite setTitle:@"编辑" forState:(UIControlStateNormal)];
        [_edite setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _edite.titleLabel.font = FONT(AppFont26Size);
    }
    return _edite;
}


@end
