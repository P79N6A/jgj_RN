//
//  JGJFindJobAndProTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFindJobAndProTableViewCell.h"
#import "TYDistance.h"

static const NSInteger JGJFindJobProMaxTitleLength = 15;

@interface JGJFindJobAndProTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *protitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firendLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDistanceLabel;

@property (weak, nonatomic) IBOutlet JGJLabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutH;
@end

@implementation JGJFindJobAndProTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.excludeContentH = 84;
    self.prepayLabel.textColor = JGJMainColor;
    self.prepayLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.timeDistanceLabel.textColor = AppFont999999Color; 
    [self.prepayLabel.layer setLayerBorderWithColor:JGJMainColor width:0.5 ration:0.05];
    self.protitleLabel.font = [UIFont boldSystemFontOfSize:self.protitleLabel.font.pointSize];
}

- (void)setJlgFindProjectModel:(JLGFindProjectModel *)jlgFindProjectModel{
    _jlgFindProjectModel = jlgFindProjectModel;
    //设置标题
    [self setProtitle:jlgFindProjectModel.protitle];
    
    self.contentLayoutH.constant = jlgFindProjectModel.strViewH;
    
    //设置富文本
    self.contentLabel.attributedText = jlgFindProjectModel.attributedStr;
    
    [self setSubViewBy:jlgFindProjectModel];
}

- (void)setSubViewBy:(JLGFindProjectModel *)jlgFindProjectModel{
    //是否需要垫资
    self.prepayLabel.hidden = YES; // 垫支1.4.5隐藏不显示
    
    //设置认识的朋友
    [self setFirendsLabelText:jlgFindProjectModel.friendcount];
    
    //设置距离
    [self setTimeDistanceLabel:jlgFindProjectModel.prolocation ctimeTxt:jlgFindProjectModel.ctime_txt];
}

- (void)setTimeDistanceLabel:(NSArray  *)prolocation ctimeTxt:(NSString *)ctime_txt{
    NSString *distancelStr = [NSString string];
    if (prolocation.count < 1) {
        distancelStr = @"未定位";
    }else{
        //公里
        NSArray *locationArray = prolocation;
        CGFloat distance = [TYDistance getDistanceBylat1:[[locationArray lastObject] floatValue] lng1:[[locationArray firstObject] floatValue] lat2:[[TYUserDefaults objectForKey:JLGLatitude] floatValue] lng2:[[TYUserDefaults objectForKey:JLGLongitude] floatValue]];
        distancelStr = [NSString stringWithFormat:@"%.1f公里",distance/1000];
    }
    if (prolocation.count == 2) {
        if (![prolocation[0] integerValue] || ![prolocation[1] integerValue]) {
            distancelStr = @"未定位";
        }
    }
    self.timeDistanceLabel.text = [NSString stringWithFormat:@"%@发布/%@",ctime_txt,distancelStr];
}

- (void)setProtitle:(NSString *)protitle{
    if (protitle.length >= JGJFindJobProMaxTitleLength) {
        protitle = [NSString stringWithFormat:@"%@...",[protitle substringWithRange:NSMakeRange(0, JGJFindJobProMaxTitleLength)]];
    }
    self.protitleLabel.text = protitle;
}

- (void)setFirendsLabelText:(NSInteger )friednsCount{
    self.firendLabel.hidden = friednsCount == 0;
    if (friednsCount == 0) {
        self.firendLabel.attributedText = nil;
        return;
    }
    
    NSString *selectedNumStr = [NSString stringWithFormat:@"%@",@(friednsCount)];//主要用于富文本的计算
    static NSString *frontString = @"你有 ";
    NSString * behindString = @" 个朋友认识他";
    
    NSString *selectedStr = [NSString stringWithFormat:@"%@%@%@",frontString,selectedNumStr,behindString];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:selectedStr];
    
    [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(frontString.length, selectedNumStr.length)];

    self.firendLabel.attributedText = contentStr;
}
@end
