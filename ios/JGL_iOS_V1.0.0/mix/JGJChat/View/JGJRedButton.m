//
//  JGJRedButton.m
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJRedButton.h"
#import "CALayer+SetLayer.h"

@interface JGJRedButton ()
@property (nonatomic,strong) UIView *redPointView;
@end

@implementation JGJRedButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commomInit];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInit];
    }
    
    return self;
}

- (void)commomInit{
    self.redPointView = [[UIView alloc] initWithFrame:self.bounds];
    self.redPointView.backgroundColor = JGJMainColor;
    [self addSubview:self.redPointView];
    self.redPointView.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateRedPoint];
}

- (void)updateRedPoint{
    CGFloat redPointWH = 6.0;
    CGFloat redPointY = self.titleLabel.frame.origin.y - redPointWH/2.0;
    CGFloat redPointX = self.titleLabel.frame.origin.x  + self.titleLabel.frame.size.width;

    CGRect rect = CGRectMake(redPointX, redPointY, redPointWH, redPointWH);
    self.redPointView.frame = rect;

    [self.redPointView.layer setLayerCornerRadius:redPointWH/2.0];
}

- (void)setIsShowRedPoint:(BOOL)isShowRedPoint{
    _isShowRedPoint = isShowRedPoint;

    self.redPointView.hidden = !_isShowRedPoint;
}
@end
