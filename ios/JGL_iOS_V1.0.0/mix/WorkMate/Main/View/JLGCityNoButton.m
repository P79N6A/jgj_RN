//
//  JLGCityNoButton.m
//  mix
//
//  Created by jizhi on 15/12/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGCityNoButton.h"

@interface JLGCityNoButton ()

@property (nonatomic,strong) IBOutlet UIView *contentView;
@end

@implementation JLGCityNoButton

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
    self.contentView.backgroundColor = [UIColor clearColor];
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentView.frame = self.bounds;
}

- (void)setLabelString:(NSString *)labelString{
    if (labelString.length > 5) {
        labelString = [labelString substringWithRange:NSMakeRange(0, 4)];
        labelString = [labelString stringByAppendingString:@"..."];
    }
    
    _labelString = labelString;
    [self.cityNoButton setTitle:labelString forState:UIControlStateNormal];
}


@end
