//
//  JGJRecordRemindView.m
//  mix
//
//  Created by Tony on 2017/6/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordRemindView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@implementation JGJRecordRemindView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    
    return self;
}

- (void)loadView{
    
    self.backgroundColor = AppFontf1f1f1Color;
    
//    _workTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, TYGetUIScreenWidth/4+4, 21)];
//    _workTimeLable.textColor = AppFont333333Color;
//    _workTimeLable.font = [UIFont systemFontOfSize:12];
//    _workTimeLable.text = @"  1d=上班1个工";
//    [_workTimeLable markText:@"1d" withColor:AppFontd7252cColor];
    
    _hourWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, TYGetUIScreenWidth/3, 21)];
    _hourWorkLable.textColor = AppFont333333Color;
    _hourWorkLable.text = @"1d=上班1个工";
    _hourWorkLable.font = [UIFont systemFontOfSize:12];
    _hourWorkLable.textAlignment = NSTextAlignmentCenter;

    [_hourWorkLable markText:@"1d" withColor:AppFontd7252cColor];

    _overWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/3, 7, TYGetUIScreenWidth/3, 21)];
    _overWorkLable.textAlignment = NSTextAlignmentRight;
    _overWorkLable.textColor = AppFont333333Color;
    
    if (JLGisLeaderBool) {
        
        _overWorkLable.text = @"1d=加班1个工";
        [_overWorkLable markText:@"1d" withColor:AppFont6487e0Color];
        
    }else {
        
        _overWorkLable.text = @"1h=加班1小时";
        [_overWorkLable markText:@"1h" withColor:AppFont6487e0Color];
    }
    
    _overWorkLable.font = [UIFont systemFontOfSize:12];
    _overWorkLable.textAlignment = NSTextAlignmentCenter;

    _billLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/3*2, 7, TYGetUIScreenWidth/3, 21)];
    _billLable.textAlignment = NSTextAlignmentCenter;
    _billLable.font = [UIFont systemFontOfSize:12];
    _billLable.textColor = AppFont333333Color;
    _billLable.text = @"=有备注";
    [_billLable markText:@"1h" withColor:AppFont6487e0Color];
    _billLable.attributedText = [NSString setLabelImageWithLabel:_billLable type:@"6"];

    [self addSubview:_hourWorkLable];
    [self addSubview:_overWorkLable];
    [self addSubview:_billLable];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    /*
    if (!_oneLine) {
        [self initNewTip];
        
    }else{
    
    self.backgroundColor = [UIColor whiteColor];
//    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordRemindView" owner:nil options:nil]firstObject];
//    [view setFrame:self.bounds];
//    [self addSubview:view];
//    _workTimeLable.hidden = YES;
//    _overWorkLable.hidden = YES;
//    _hourWorkLable.hidden = YES;
//    _billLable.hidden     = YES;
    
    _workTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth/4-20, 21)];
    _workTimeLable.textColor = AppFont333333Color;

    _hourWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4-15, 0, TYGetUIScreenWidth/4+30, 21)];
    _hourWorkLable.textColor = AppFont333333Color;

    _overWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 +4, 0, TYGetUIScreenWidth/4, 21)];
    _overWorkLable.textAlignment = NSTextAlignmentRight;
    _overWorkLable.textColor = AppFont333333Color;

    _billLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*3, 0, TYGetUIScreenWidth/4-10, 21)];
    _billLable.textAlignment = NSTextAlignmentRight;
    _billLable.font = [UIFont systemFontOfSize:12];
    _billLable.textColor = AppFont333333Color;
    _billLable.text = @"=有差账   ";
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 5 - 11 - 50, 5, 10, 11)];
    imageview.image = [UIImage imageNamed:@"-warning"];
    [_billLable addSubview:imageview];
    [self addSubview:_workTimeLable];
    [self addSubview:_hourWorkLable];
    [self addSubview:_overWorkLable];
    [self addSubview:_billLable];

    [self initFrame];
    }
*/
    
}
- (void)initFrame
{
    _workTimeLable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStr = [[NSMutableAttributedString alloc] initWithString:@" 1d=1个工"];
    
    [centerattrStr addAttribute:NSForegroundColorAttributeName
                          value:AppFontd7252cColor
                          range:NSMakeRange(1,2)];
    _workTimeLable.attributedText = centerattrStr;
    
    
    _hourWorkLable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrs = [[NSMutableAttributedString alloc] initWithString:@"1h=正常上班1小时"];
    [centerattrStrs addAttribute:NSForegroundColorAttributeName
                           value:AppFontd7252cColor
                           range:NSMakeRange(0,2)];
    _hourWorkLable.attributedText = centerattrStrs;
    
    _overWorkLable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrss = [[NSMutableAttributedString alloc] initWithString:@"1h=加班1小时"];
    
    [centerattrStrss addAttribute:NSForegroundColorAttributeName
                            value:AppFont6487e0Color
                            range:NSMakeRange(0,2)];
    _overWorkLable.attributedText = centerattrStrss;
    
    

}
-(void)setOneLine:(BOOL)oneLine
{
    if (oneLine) {
        _firstView.hidden = YES;
        _secondView.hidden = YES;
        _thridView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordRemindView" owner:nil options:nil]firstObject];
        [view setFrame:self.bounds];
        [self addSubview:view];
        _workTimeLable.hidden = YES;
        _overWorkLable.hidden = YES;
        _hourWorkLable.hidden = YES;
        _billLable.hidden     = YES;
        
        _workTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, TYGetUIScreenWidth/4-20, 21)];
        _workTimeLable.textColor = AppFont333333Color;
        
        _hourWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4-15, 7, TYGetUIScreenWidth/4+30, 21)];
        _hourWorkLable.textColor = AppFont333333Color;
        
        _overWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 +4, 7, TYGetUIScreenWidth/4, 21)];
        _overWorkLable.textAlignment = NSTextAlignmentRight;
        _overWorkLable.textColor = AppFont333333Color;
        
        _billLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4*3, 7, TYGetUIScreenWidth/4-10, 21)];
        _billLable.textAlignment = NSTextAlignmentRight;
        _billLable.font = [UIFont systemFontOfSize:12];
        _billLable.textColor = AppFont333333Color;
        _billLable.text = @"=有差账   ";
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 5 - 11 - 50, 5, 10, 11)];
        imageview.image = [UIImage imageNamed:@"-warning"];
        [_billLable addSubview:imageview];
        [self addSubview:_workTimeLable];
        [self addSubview:_hourWorkLable];
        [self addSubview:_overWorkLable];
        [self addSubview:_billLable];
        
        [self initFrame];
  
    }

}
- (void)initNewTip
{
    
//    _workTimeLable.hidden = YES;
//    _overWorkLable.hidden = YES;
//    _hourWorkLable.hidden = YES;
//    _billLable.hidden     = YES;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/6 -67, 2, 10, 11)];
    
    imageview.image = [UIImage imageNamed:@"-warning"];
    
    [_third_lable addSubview:imageview];
    
    

    

    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 43, 8.5, 6, 6)];
    leftImage.backgroundColor = AppFontccccccColor;
    
    leftImage.layer.masksToBounds = YES;
    
    leftImage.layer.cornerRadius = 3;
    

    [_firstView addSubview:leftImage];
    
    
    
    
    UIImageView *down_leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 43, 30.5, 6, 6)];
    down_leftImage.backgroundColor = AppFontccccccColor;
    
    down_leftImage.layer.masksToBounds = YES;
    
    down_leftImage.layer.cornerRadius = 3;
    
    
    [_firstView addSubview:down_leftImage];
    
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 43, 9.5, 6, 6)];
    centerImage.backgroundColor = AppFontccccccColor;
    
    centerImage.layer.masksToBounds = YES;

    centerImage.layer.cornerRadius = 3;
    
    [_secondView addSubview:centerImage];
    
    
    UIImageView *down_centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 43, 30.5, 6, 6)];
    down_centerImage.backgroundColor = AppFontccccccColor;
    
    down_centerImage.layer.masksToBounds = YES;
    
    down_centerImage.layer.cornerRadius = 3;
    
    
    [_secondView addSubview:down_centerImage];
    
    _first_up_lable.text    = @"1d = 上班1个工";
    _first_up_lable.textAlignment = NSTextAlignmentCenter;
    [_first_up_lable markText:@"1d" withColor:AppFontd7252cColor];
    
    _first_down_lable.text  = @"1h = 上班1小时";
    _first_down_lable.textAlignment = NSTextAlignmentCenter;

    [_first_down_lable markText:@"1h" withColor:AppFontd7252cColor];

    _second_up_lable.text   = @"1d = 加班1个工";
    
    _second_up_lable.textAlignment = NSTextAlignmentCenter;

    [_second_up_lable markText:@"1d" withColor:AppFont6487e0Color];

    _second_down_lable.text = @"1h = 加班1小时";
    
    _second_down_lable.textAlignment = NSTextAlignmentCenter;

    [_second_down_lable markText:@"1h" withColor:AppFont6487e0Color];

    _third_lable.text       = @"表示有差账";
}
@end
