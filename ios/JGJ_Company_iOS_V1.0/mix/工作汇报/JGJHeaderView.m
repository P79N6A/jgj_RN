//
//  JGJHeaderView.m
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHeaderView.h"

@implementation JGJHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}

- (void)loadView{
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJHeaderView" owner:nil options:nil]firstObject];
    [view setFrame:self.frame];
    [self addSubview:view];

}
@end
