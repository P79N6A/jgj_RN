//
//  JGJTipAccountView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTipAccountView.h"

@implementation JGJTipAccountView

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self initView];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
 
    }
    return self;
}
- (void)initView
{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJTipAccountView" owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    _accountButton.layer.cornerRadius = 5;
    _accountButton.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
}
- (IBAction)clickAccountButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAddaccountButton)]) {
        [self.delegate clickAddaccountButton];
    }
}
@end
