//
//  JGJPersonWageListTotalView.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonWageListTotalView.h"

@interface JGJPersonWageListTotalView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@end

@implementation JGJPersonWageListTotalView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setYearStr:(NSString *)yearStr{
    _yearStr = yearStr;
    self.yearLabel.text = yearStr;
}

@end
