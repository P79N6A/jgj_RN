//
//  JGJCalendarFourthCell.m
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarFourthCell.h"
#import "UILabel+GNUtil.h"

@interface JGJCalendarFourthCell ()
@property (weak, nonatomic) IBOutlet UIView *containRecommendView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UILabel *middleTitle;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

@end
@implementation JGJCalendarFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftTitle.font = [UIFont systemFontOfSize:AppFont28Size];
    self.leftTitle.textColor = AppFont333333Color;
    self.middleTitle.font = [UIFont systemFontOfSize:AppFont28Size];
    self.middleTitle.textColor = AppFont333333Color;
    self.rightTitle.font = [UIFont systemFontOfSize:AppFont28Size];
    self.rightTitle.textColor = AppFont333333Color;
}

- (void)setTodayRecoms:(NSArray *)todayRecoms {
    _todayRecoms = todayRecoms;
    JGJTodayRecomModel *todayRecomModel = nil;
    ;
    for (NSUInteger i = 0; i < 3; i ++) {
        todayRecomModel = todayRecoms[i];
        UIButton *recomButton = (UIButton *)[self.contentView viewWithTag:100 + i];
        [recomButton setBackgroundImage:[UIImage imageNamed:todayRecomModel.icon] forState:UIControlStateNormal];
        UILabel *titleLable = (UILabel *)[self.contentView viewWithTag:200 + i];
        titleLable.text = todayRecomModel.title;
        if ([todayRecomModel.title containsString:@"\n"]) {
            [titleLable markLineText:[self lineString:todayRecomModel.title] withLineFont:[UIFont systemFontOfSize:AppFont20Size] withColor:AppFont999999Color lineSpace:6.0];   
        }
    }
}

#pragma mark - 今日推荐

- (IBAction)buttonPressed:(UIButton *)sender {
    
    NSUInteger index = sender.tag - 100;
    JGJTodayRecomModel *recomRecomModel = self.todayRecoms[index];
    if (self.todayRecomBlcok) {
        self.todayRecomBlcok(recomRecomModel);
    }
}

- (NSString *)lineString:(NSString *)lineString {

    if ([lineString containsString:@"\n"]) {
        NSRange range = [lineString rangeOfString:@"\n"];
        lineString = [lineString substringFromIndex:range.location + 1];
    }
    return lineString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
