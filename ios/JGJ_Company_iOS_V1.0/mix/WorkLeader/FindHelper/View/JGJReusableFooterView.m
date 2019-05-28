//
//  JGJReusableFooterView.m
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReusableFooterView.h"

@implementation JGJReusableFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect rect  = CGRectMake(0, 5, TYGetViewW(self), TYGetViewH(self) - 5);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:rect];
        [cancelButton addTarget:self action:@selector(cancelButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)cancelButtonDidClicked:(UIButton *)sender {

    if (self.blockCancel) {
        self.blockCancel();
    }
}

@end
