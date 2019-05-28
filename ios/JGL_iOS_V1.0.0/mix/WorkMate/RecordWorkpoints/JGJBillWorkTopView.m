//
//  JGJBillWorkTopView.m
//  mix
//
//  Created by Tony on 2017/4/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBillWorkTopView.h"

@implementation JGJBillWorkTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadView];
    }
    return self;
}
- (void)loadView{
    self.backgroundColor = AppFontf1f1f1Color;
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    CGRect rect = self.bounds;
    rect.size.width = TYGetUIScreenWidth;
    self.contentView.frame = rect;
    [self addSubview:self.contentView];

}
-(void)setContentLabletext:(NSString *)content
{
    _contentLable.text = content;

}
@end
