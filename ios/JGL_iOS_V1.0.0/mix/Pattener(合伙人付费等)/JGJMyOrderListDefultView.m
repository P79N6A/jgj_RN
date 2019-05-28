//
//  JGJMyOrderListDefultView.m
//  JGJCompany
//
//  Created by Tony on 2017/8/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMyOrderListDefultView.h"

@implementation JGJMyOrderListDefultView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder]) {
        [self initView];
  
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];


}
-(void)initView{
    [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];

}
@end
