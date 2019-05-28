//
//  RecordWorkHomeMoneyView.m
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "RecordWorkHomeMoneyView.h"
#import "JLGDashedLine.h"

@interface RecordWorkHomeMoneyView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) IBOutlet UILabel *theMonthLabel;
@property (nonatomic,strong) IBOutlet UILabel *theYearhLabel;

@property (nonatomic,strong) IBOutlet UILabel *theMonthIncomeLabel;
@property (nonatomic,strong) IBOutlet UILabel *theYearhIncomeLabel;
@end

@implementation RecordWorkHomeMoneyView

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
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
//    self.contentView.backgroundColor = JGJMainColor;
    self.theMonthLabel.text = JLGisLeaderBool ? @"本月未结工人工资":@"本月工资";
    self.theYearhLabel.text = JLGisLeaderBool ? @"今年未结工人工资":@"今年工资";
    [self initImageview];
}
- (void)initImageview{
//    if (TYGetUIScreenWidth<=320) {
//        UIImageView *LeftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theMonthLabel.frame) -54, -4, 22, 22)];
//        LeftImageview.image = [UIImage imageNamed:@"形状-17"];
//        [self.theMonthLabel addSubview:LeftImageview];
//        
//        UIImageView *rightImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theYearhLabel.frame) - 53, -4, 22, 22)];
//        rightImageview.image = [UIImage imageNamed:@"形状-16"];
//        [self.theMonthLabel addSubview:rightImageview];
//        
//    }else if (TYGetUIScreenWidth == 375)
//    {
//        UIImageView *LeftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theMonthLabel.frame) -46, -4, 22, 22)];
//        LeftImageview.image = [UIImage imageNamed:@"形状-17"];
//        [self.theMonthLabel addSubview:LeftImageview];
//        
//        UIImageView *rightImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theYearhLabel.frame) - 39, -4, 22, 22)];
//        rightImageview.image = [UIImage imageNamed:@"形状-16"];
//        [self.theMonthLabel addSubview:rightImageview];
//        
//        
//        
//    }else{
//        UIImageView *LeftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theMonthLabel.frame) -32, -4, 22, 22)];
//        LeftImageview.image = [UIImage imageNamed:@"形状-17"];
//        [self.theMonthLabel addSubview:LeftImageview];
//        
//        UIImageView *rightImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_theYearhLabel.frame) + 16, -4, 22, 22)];
//        rightImageview.image = [UIImage imageNamed:@"形状-16"];
//        [self.theMonthLabel addSubview:rightImageview];
//    }
//   
    
//    UIImageView *LeftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 -59, -4, 22, 22)];
//    LeftImageview.image = [UIImage imageNamed:@"形状-17"];
//    [self.theMonthLabel addSubview:LeftImageview];
//
//    
//    UIImageView *rightImageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*3 -58 , -4, 22, 22)];
//    rightImageview.image = [UIImage imageNamed:@"形状-16"];
//    [self.theMonthLabel addSubview:rightImageview];

    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat pointX = TYGetMidX(self.contentView);
    [JLGDashedLine drashVerticalLineInView:self.contentView byPoint:CGPointMake(pointX, TYGetMinY(self.theYearhLabel) + 3) byHeight:TYGetMaxY(self.theYearhIncomeLabel) - TYGetMinY(self.theYearhLabel) - 7 byColor:[UIColor colorWithWhite:1 alpha:0.5]];
}

- (void)setMoneyWithMonth:(NSString *)monthMoney WithYear:(NSString *)yearMoney{
    
    if (monthMoney.length<=1) {
        monthMoney = [NSString stringWithFormat:@"%@.00",monthMoney];
    }
    if (yearMoney.length<=1) {
        yearMoney = [NSString stringWithFormat:@"%@.00",yearMoney];
    }
    
    self.theMonthIncomeLabel.text = monthMoney;
    self.theMonthIncomeLabel.font = [UIFont fontWithName:@"Impact" size:32];
    self.theYearhIncomeLabel.text = yearMoney;
    self.theYearhIncomeLabel.font = [UIFont fontWithName:@"Impact" size:32];

    self.theMonthIncomeLabel.adjustsFontSizeToFitWidth = YES;
    self.theYearhIncomeLabel.adjustsFontSizeToFitWidth = YES;
//    此处是因为接口异常时造成了UI问题

//    if (monthMoney.length>=3) {
//        
//        if ([monthMoney containsString:@"万"] || [monthMoney containsString:@"亿"])  {
//             NSMutableAttributedString *centerattrStrss = [[NSMutableAttributedString alloc] initWithString:monthMoney];
//            [centerattrStrss addAttribute:NSFontAttributeName
//                                    value:[UIFont fontWithName:@"Impact" size:24]
//                                    range:NSMakeRange(centerattrStrss.length-3,3)];
//            self.theMonthIncomeLabel.attributedText = centerattrStrss;
//
//        }else{
//        
//                NSMutableAttributedString *centerattrStrss = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[monthMoney floatValue]]];
//            [centerattrStrss addAttribute:NSFontAttributeName
//                                    value:[UIFont fontWithName:@"Impact" size:24]
//                                    range:NSMakeRange(centerattrStrss.length-2,2)];
//            self.theMonthIncomeLabel.attributedText = centerattrStrss;
//
//        }
//       
//
//        }
    
//    if (yearMoney.length >= 3) {
//        
//    
////    NSMutableAttributedString *centerattrStrsss = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[yearMoney floatValue]]];
//        if ([yearMoney containsString:@"万"] || [yearMoney containsString:@"亿"]) {
//            NSMutableAttributedString *centerattrStrsss = [[NSMutableAttributedString alloc] initWithString:yearMoney];
//            
//            [centerattrStrsss addAttribute:NSFontAttributeName
//                                     value:[UIFont fontWithName:@"Impact" size:24]
//                                     range:NSMakeRange(centerattrStrsss.length-3,3)];
//            self.theYearhIncomeLabel.attributedText = centerattrStrsss;
//
//        }else{
//                NSMutableAttributedString *centerattrStrsss = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[yearMoney floatValue]]];
//            
//            [centerattrStrsss addAttribute:NSFontAttributeName
//                                     value:[UIFont fontWithName:@"Impact" size:24]
//                                     range:NSMakeRange(centerattrStrsss.length-2,2)];
//            self.theYearhIncomeLabel.attributedText = centerattrStrsss;
//
//        }
//       }
    
    


}

@end
