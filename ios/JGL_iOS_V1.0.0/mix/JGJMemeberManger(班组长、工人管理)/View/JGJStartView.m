//
//  JGJStartView.m
//  mix
//
//  Created by yj on 2018/6/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJStartView.h"

#import "XHStarRateView.h"

#define  StarRateViewW 135

#define  StarRateViewH 15

@interface JGJStartView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (strong, nonatomic) XHStarRateView *attRateView;

@property (strong, nonatomic) XHStarRateView *proRateView;

@property (strong, nonatomic) XHStarRateView *relRateView;

//态度
@property (weak, nonatomic) IBOutlet UILabel *attLable;

//专业
@property (weak, nonatomic) IBOutlet UILabel *proLable;

//靠谱
@property (weak, nonatomic) IBOutlet UILabel *relLable;

@end

@implementation JGJStartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [self setSubView];
    
    [self setSubViewColor];
}

- (void)setSubView {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    XHStarRateView *attStarView = [[XHStarRateView alloc] initWithFrame:CGRectMake(126.0, -2, StarRateViewW, StarRateViewH) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
    
    attStarView.centerY = self.attLable.centerY;
    
    attStarView.isForbidTouch = YES;
    
    self.attRateView = attStarView;
    
    [self addSubview:attStarView];
    
    XHStarRateView *proStarView = [[XHStarRateView alloc] initWithFrame:CGRectMake(126.0, (TYGetViewH(self)) / 2.0 - StarRateViewH / 2.0 + 7.5, StarRateViewW, StarRateViewH) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
    
    self.proRateView = proStarView;
    
    proStarView.isForbidTouch = YES;
    
    [self addSubview:proStarView];
    
    XHStarRateView *relStarView = [[XHStarRateView alloc] initWithFrame:CGRectMake(126.0, TYGetViewH(self) - StarRateViewH / 2.0 + 7.5, StarRateViewW, StarRateViewH) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
    
    self.relRateView = relStarView;
    
    relStarView.isForbidTouch = YES;
    
    [self addSubview:relStarView];
}

- (void)setSubViewColor {
    
    self.attLable.textColor = AppFont333333Color;
    
    self.proLable.textColor = AppFont333333Color;
    
    self.relLable.textColor = AppFont333333Color;
    
}

- (void)setListModel:(JGJMemberEvaListModel *)listModel {
    
    _listModel = listModel;
    
    self.relRateView.currentScore = [listModel.professional_or_abuse floatValue];
    
    self.attRateView.currentScore = [listModel.attitude_or_arrears floatValue];
    
    self.proRateView.currentScore = [listModel.professional_or_abuse floatValue];
    
}

@end
