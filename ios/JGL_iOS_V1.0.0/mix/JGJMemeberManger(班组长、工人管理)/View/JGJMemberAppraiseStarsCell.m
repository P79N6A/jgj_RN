//
//  JGJMemberAppraiseStarsCell.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberAppraiseStarsCell.h"

#import "XHStarRateView.h"

#define  StarRateViewW 135

#define StarRateViewH 15

@interface JGJMemberAppraiseStarsCell () <XHStarRateViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) XHStarRateView *starRateView;

@end

@implementation JGJMemberAppraiseStarsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(126.0, (TYGetViewH(self) - StarRateViewH) / 2.0, StarRateViewW, StarRateViewH) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
    
    starRateView.delegate = self;
    
    self.starRateView = starRateView;
    
    [self.contentView addSubview:starRateView];
    
}

-(void)setStarsModel:(JGJMemberAppraiseStarsModel *)starsModel {
    
    _starsModel = starsModel;
    
    self.title.text = _starsModel.title;
    
    //是否改变触摸改变分数
    self.starRateView.isForbidTouch = starsModel.isForbidTouch;
    
    self.starRateView.currentScore = [starsModel.score floatValue];
    
    self.starRateView.y = (starsModel.height - StarRateViewH) / 2.0;
    
}

- (void)setMaxStarLead:(CGFloat)maxStarLead {
    
    _maxStarLead = maxStarLead;
    
    if (self.starsCellType == JGJMemberAppraiseStarsCellEvaType) {
        
        self.starRateView.x = TYGetUIScreenWidth - StarRateViewW - 20;
        
    }else {
        
        self.starRateView.x = maxStarLead;
    }

}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    
    _starsModel.score = [NSString stringWithFormat:@"%.f", currentScore];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
