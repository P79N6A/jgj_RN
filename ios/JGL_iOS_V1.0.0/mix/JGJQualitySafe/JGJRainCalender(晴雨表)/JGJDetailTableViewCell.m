//
//  JGJDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDetailTableViewCell.h"

@implementation JGJDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setView];
    // Initialization code
}
- (void)setView{
    self.backgroundColor =[UIColor whiteColor];
    UIView *view;
    view = [UIView new];

    [view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)/5, 40)];
    view.backgroundColor = [UIColor whiteColor];
    self.firstView = view;
    //15
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 - 18, 12, 15, 15)];
    imageview.image = [UIImage imageNamed:@"eg_calendar_weather_Clear"];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 + 3, 12, 40, 16)];
    lable.text = @"晴";
    lable.font = [UIFont systemFontOfSize:11];
    lable.textColor = AppFont999999Color;
    [self.firstView addSubview:imageview];
    
    [self.firstView addSubview:lable];

    
    UIView *secondview;
    secondview = [UIView new];

    [secondview setFrame:CGRectMake(TYGetUIScreenWidth/5,0, CGRectGetWidth(self.frame)/5, 40)];
    secondview.backgroundColor = [UIColor whiteColor];
    
    self.secondView = secondview;
    
    
    UIImageView *Secimageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 - 18, 12, 15, 15)];
    Secimageview.image = [UIImage imageNamed:@"eg_calendar_weather_Overcast"];

    UILabel *seclable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/12 + 5, 12, 40, 16)];
    seclable.text = @"阴";
    seclable.font = [UIFont systemFontOfSize:11];
    seclable.textColor = AppFont999999Color;

    [self.secondView addSubview:Secimageview];
    [self.secondView addSubview:seclable];
    

    
    
    UIView *threview;
    threview = [UIView new];

    [threview setFrame:CGRectMake(TYGetUIScreenWidth/5*2, 0, CGRectGetWidth(self.frame)/5, 40)];
    threview.backgroundColor = [UIColor whiteColor];
    
    self.ThreeView = threview;
    
    
    UIImageView *Threeimageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 - 18, 12, 15, 15)];
    Threeimageview.image = [UIImage imageNamed:@"eg_calendar_weather_cloudy"];

    UILabel *threelable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 + 3, 12, 40, 16)];
    threelable.text = @"多云";
    threelable.font = [UIFont systemFontOfSize:11];
    threelable.textColor = AppFont999999Color;

    [self.ThreeView addSubview:Threeimageview];
    [self.ThreeView addSubview:threelable];
    
    
    
    
    UIView *fourview;
    fourview = [UIView new];
    [fourview setFrame:CGRectMake(TYGetUIScreenWidth/5*3, 0, CGRectGetWidth(self.frame)/5, 40)];
    fourview.backgroundColor = [UIColor whiteColor];
    
    self.Fourthview = fourview;
    
    
    
    UIImageView *fourimageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 - 18, 12, 15, 15)];
    fourimageview.image = [UIImage imageNamed:@"eg_calendar_weather_rain"];

    UILabel *fourlable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 + 3, 12, 30, 16)];
    fourlable.text = @"雨";
    fourlable.font = [UIFont systemFontOfSize:11];
    fourlable.textColor = AppFont999999Color;

    
    [self.Fourthview addSubview:fourimageview];
    [self.Fourthview addSubview:fourlable];
    

    
    
    UIView *fiveView;
    fiveView = [UIView new];
    [fiveView setFrame:CGRectMake(TYGetUIScreenWidth/5*4, 0, CGRectGetWidth(self.frame)/5,40)];
    fiveView.backgroundColor = [UIColor whiteColor];
    
    self.FiveThview = fiveView;
    UIImageView *fiveimageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 - 18, 12, 15, 15)];
    fiveimageview.image = [UIImage imageNamed:@"eg_calendar_weather_wind"];

    UILabel *fivelable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/10 + 3, 12, 40, 16)];
    fivelable.text = @"风";
    fivelable.font = [UIFont systemFontOfSize:11];
    fivelable.textColor = AppFont999999Color;

    [self.FiveThview addSubview:fiveimageview];
    [self.FiveThview addSubview:fivelable];
    

    
    
    [self.contentView addSubview:self.firstView];
    [self.contentView addSubview:self.secondView];
    [self.contentView addSubview:self.ThreeView];
    [self.contentView addSubview:self.Fourthview];
    [self.contentView addSubview:self.FiveThview];

    self.contentView.backgroundColor = [UIColor whiteColor];
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        UIView *view;
//        [view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame))];
//        view.backgroundColor = [UIColor redColor];
//        self.firstView = view;
//        
//        
//        UIView *secondview;
//        [secondview setFrame:CGRectMake(0, CGRectGetMaxX(self.firstView.frame), CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame))];
//        secondview.backgroundColor = [UIColor redColor];
//
//        self.secondView = secondview;
//
//        UIView *threview;
//        [threview setFrame:CGRectMake(0, CGRectGetMaxX(self.secondView.frame), CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame))];
//        threview.backgroundColor = [UIColor redColor];
//
//        self.ThreeView = threview;
//        
//        UIView *fourview;
//        [fourview setFrame:CGRectMake(0, CGRectGetMaxX(self.ThreeView.frame), CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame))];
//        fourview.backgroundColor = [UIColor redColor];
//
//        self.Fourthview = fourview;
//        
//        
//        UIView *fiveView;
//        [fiveView setFrame:CGRectMake(0, CGRectGetMaxX(self.Fourthview.frame), CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame))];
//        fiveView.backgroundColor = [UIColor redColor];
//
//        self.FiveThview = fiveView;
//        
//        [self.contentView addSubview:self.FiveThview];
//        
//        [self.contentView addSubview:self.firstView];
//        [self.contentView addSubview:self.secondView];
//        [self.contentView addSubview:self.ThreeView];
//        [self.contentView addSubview:self.Fourthview];
//
//    }
//    return self;
//
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
