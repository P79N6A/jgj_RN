//
//  JGJOneLineTipView.m
//  mix
//
//  Created by Tony on 2017/10/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOneLineTipView.h"

@implementation JGJOneLineTipView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        _hourWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, TYGetUIScreenWidth/3, 21)];
        _hourWorkLable.textColor = AppFont333333Color;
        _hourWorkLable.text = @"1d=上班1个工";
        _hourWorkLable.font = [UIFont systemFontOfSize:12];
        _hourWorkLable.textAlignment = NSTextAlignmentCenter;
        
        
        _overWorkLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/3, 7, TYGetUIScreenWidth/3, 21)];
        _overWorkLable.textAlignment = NSTextAlignmentRight;
        _overWorkLable.textColor = AppFont333333Color;
        
        
        _overWorkLable.font = [UIFont systemFontOfSize:12];
        _overWorkLable.textAlignment = NSTextAlignmentCenter;
        
        _billLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/3*2, 7, TYGetUIScreenWidth/3, 21)];
        _billLable.textAlignment = NSTextAlignmentCenter;
        _billLable.font = [UIFont systemFontOfSize:12];
        _billLable.textColor = AppFont333333Color;
        _billLable.text = @"=有备注";
        
        _billLable.attributedText = [NSString setLabelImageWithLabel:_billLable type:@"6"];
        
        [self addSubview:_hourWorkLable];
        [self addSubview:_overWorkLable];
        [self addSubview:_billLable];
        
        [self initFrame];
 
    }

    return self;
}
- (void)initFrame
{
    
    
    _hourWorkLable.font = [UIFont systemFontOfSize:12];;
    NSMutableAttributedString *centerattrStrs = [[NSMutableAttributedString alloc] initWithString:@"1d=上班1个工"];
    [centerattrStrs addAttribute:NSForegroundColorAttributeName
                           value:AppFontd7252cColor
                           range:NSMakeRange(0,2)];
    _hourWorkLable.attributedText = centerattrStrs;
    
    _overWorkLable.font = [UIFont systemFontOfSize:12];;
    NSMutableAttributedString *centerattrStrss;
    
    if (JLGisLeaderBool) {

        centerattrStrss = [[NSMutableAttributedString alloc] initWithString:@"1d=加班1个工"];
        [centerattrStrss addAttribute:NSForegroundColorAttributeName
                                value:AppFont6487e0Color
                                range:NSMakeRange(0,2)];

    }else {

        centerattrStrss = [[NSMutableAttributedString alloc] initWithString:@"1h=加班1小时"];
        [centerattrStrss addAttribute:NSForegroundColorAttributeName
                                value:AppFont6487e0Color
                                range:NSMakeRange(0,2)];
    }
    
    _overWorkLable.attributedText = centerattrStrss;
    
    
}

@end
