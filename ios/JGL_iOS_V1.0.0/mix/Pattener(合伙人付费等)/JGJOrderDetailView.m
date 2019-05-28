//
//  JGJOrderDetailView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOrderDetailView.h"

@implementation JGJOrderDetailView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadView];

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self loadView];
    }
    return self;
}
- (void)loadView{
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJOrderDetailView" owner:nil options:nil]firstObject];
    [view setFrame:self.bounds];
    [self addSubview:view];

}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{

}
@end
