//
//  TYView.m
//  mix
//
//  Created by jizhi on 15/12/1.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYView.h"

@interface TYView ()

@property (strong, nonatomic) UIView *contentView;

@end

@implementation TYView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self.addressSortButton.layer setLayerBorderWithColor:self.addressSortButton.titleLabel.textColor width:1.0 radius:12.0];
    [self.priceSortButton.layer setLayerBorderWithColor:self.addressSortButton.titleLabel.textColor width:1.0 radius:12.0];
    
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentView.frame = self.bounds;
}
@end
