//
//  JGJdailyDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJdailyDetailTableViewCell.h"
#import "NSString+Extend.h"
@interface JGJdailyDetailTableViewCell()
{
    NSInteger tag;

}
@end
@implementation JGJdailyDetailTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _sendDailyModel = [JGJSendDailyModel new];
    [self.contentView addSubview:self.placeView];
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 119, TYGetUIScreenWidth , 8)];
//    lable.backgroundColor = AppFontf1f1f1Color;
//    [self.contentView addSubview:lable];
//    self.contentView.backgroundColor = AppFontc8c8c8Color;
}

-(UIView *)placeView
{
    if (!_placeView) {
        _placeView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, TYGetUIScreenWidth - 20, 102)];
        _placeView.backgroundColor = AppFontc8c8c8Color;
        _placeView.layer.masksToBounds = YES;
        _placeView.layer.cornerRadius = 5;
        _placeView.layer.borderColor= AppFontc8c8c8Color.CGColor;
        _placeView.layer.borderWidth = 1;
        [_placeView addSubview:self.weatherLable];
        [_placeView addSubview:self.sunylablem];
        [_placeView addSubview:self.sunylablea];
        [_placeView addSubview:self.templable];
        [_placeView addSubview:self.templablea];
        [_placeView addSubview:self.templablem];
        [_placeView addSubview:self.windlable];
        [_placeView addSubview:self.windlablem];
        [_placeView addSubview:self.windlablea];
        [_placeView addSubview:self.windPlace_m];
        [_placeView addSubview:self.windPlace_a];
        [_placeView addSubview:self.tempPlace_m];
        [_placeView addSubview:self.tempPlace_a];

//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame)- 5  , TYGetUIScreenWidth, 5)];
//        lable.textColor = AppFontdbdbdbColor;
//        [self.contentView addSubview:lable];
        [self contentSizeToFitWithTextView:self.windlablea];
        [self contentSizeToFitWithTextView:self.windlablem];
        [self contentSizeToFitWithTextView:self.templablea];
        [self contentSizeToFitWithTextView:self.templablem];

    }
    return _placeView;
}
-(UILabel *)weatherLable
{
    if (!_weatherLable) {
        _weatherLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46 * (TYGetUIScreenWidth - 20)/ 351, 102)];
        _weatherLable.textColor = AppFont666666Color;
//        _weatherLable.text = @"天气";
        _weatherLable.text = [NSString stringWithFormat:@"天\n气"];
        _weatherLable.numberOfLines = 0;
        _weatherLable.font = [UIFont systemFontOfSize:12];
        _weatherLable.textAlignment = NSTextAlignmentCenter;
        _weatherLable.backgroundColor = AppFontfafafaColor;
    }
    return _weatherLable;
}

-(UILabel *)sunylablea
{
    if (!_sunylablea) {
        _sunylablea = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weatherLable.frame) + 1, 51, 70 * (TYGetUIScreenWidth - 20)/ 351, 51)];
        _sunylablea.textColor = AppFontccccccColor;
        _sunylablea.text = @"下午";
        _sunylablea.font = [UIFont systemFontOfSize:12];
        _sunylablea.textAlignment = NSTextAlignmentCenter;
        _sunylablea.backgroundColor = AppFontfafafaColor;
        _sunylablea.tag = 2;
        _sunylablea.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectedWeather:)];
        [_sunylablea addGestureRecognizer:tap];
    }
    return _sunylablea;
}
-(UILabel *)sunylablem
{
    if (!_sunylablem) {
        _sunylablem = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weatherLable.frame) + 1, 0, 70 * (TYGetUIScreenWidth - 20)/ 351, 50)];
        _sunylablem.textColor = AppFontccccccColor;
        _sunylablem.font = [UIFont systemFontOfSize:12];
        _sunylablem.textAlignment = NSTextAlignmentCenter;
        _sunylablem.text = @"上午";
        _sunylablem.tag = 1;
        _sunylablem.backgroundColor = AppFontfafafaColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectedWeather:)];
        [_sunylablem addGestureRecognizer:tap];
        _sunylablem.userInteractionEnabled = YES;

    }
    return _sunylablem;
    
    
}
-(UILabel *)templable
{
    if (!_templable) {
        _templable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sunylablea.frame) +1, 0, 44 * (TYGetUIScreenWidth - 20)/ 351, 102)];
        _templable.textColor = AppFont666666Color;
        _templable.font = [UIFont systemFontOfSize:12];
        _templable.textAlignment = NSTextAlignmentCenter;
        //      _templable.text = @"温度℃";
//        _templable.numberOfLines = 2;
        _templable.numberOfLines = 0;

        _templable.text = [NSString stringWithFormat:@"%@",@"温\n度\n(℃)"];
        _templable.backgroundColor = AppFontfafafaColor;
        
    }
    return _templable;
    
}
-(UITextView *)templablem
{
    if (!_templablem) {
        _templablem = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templable.frame) + 1, 0, 70 * (TYGetUIScreenWidth - 20)/ 351, 50)];
//        _templablem.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        _templablem.textColor = AppFont333333Color;
        _templablem.font = [UIFont systemFontOfSize:12];
        _templablem.textAlignment = NSTextAlignmentCenter;
//        _templablem.placeholder = @"上午";
        _templablem.backgroundColor = AppFontfafafaColor;
        _templablem.tag = 1;
        _templablem.delegate = self;
//        [_templablem addSubview:self.tempPlace_m];
    }
    return _templablem;
    
    
}
-(UITextView *)templablea
{
    if (!_templablea) {
        _templablea = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templable.frame) + 1, 51, 70 * (TYGetUIScreenWidth - 20)/ 351, 51)];
        _templablea.textColor = AppFont333333Color;
        _templablea.font = [UIFont systemFontOfSize:AppFont24Size];
        _templablea.textAlignment = NSTextAlignmentCenter;
//        _templablea.placeholder = @"下午";
//        _templablea.keyboardType = UIKeyboardTypeASCIICapableNumberPad;

        _templablea.backgroundColor = AppFontfafafaColor;
        _templablea.tag = 2;
        _templablea.delegate = self;
//        [_templablea addSubview:self.tempPlace_a];
    }
    return _templablea;
    
}
-(UILabel *)windlable
{
    if (!_windlable) {
        _windlable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templablea.frame) +1, 0, 43* (TYGetUIScreenWidth - 20)/ 351, 102)];
        _windlable.textColor = AppFont666666Color;
        _windlable.font = [UIFont systemFontOfSize:12];
        _windlable.textAlignment = NSTextAlignmentCenter;
        _windlable.numberOfLines = 0;
        _windlable.text = [NSString stringWithFormat:@"%@",@"风\n力\n(级)"];
        _windlable.backgroundColor = AppFontfafafaColor;
        
    }
    return _windlable;
    
}
-(UITextView *)windlablea
{
    if (!_windlablea) {
        _windlablea = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 51, TYGetUIScreenWidth - 14 - CGRectGetMaxX(_windlable.frame) - 2, 51)];
        _windlablea.textColor = AppFont333333Color;
        _windlablea.font = [UIFont systemFontOfSize:12];
        _windlablea.textAlignment = NSTextAlignmentCenter;
//        _windlablea.placeholder = @"下午";
//        _windlablea.keyboardType = UIKeyboardTypeASCIICapableNumberPad;

        _windlablea.backgroundColor = AppFontfafafaColor;
//        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_windlablea.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
//        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
//        maskLayers.frame = _windlablea.bounds;
//        maskLayers.path = maskPaths.CGPath;
//        _windlablea.layer.mask = maskLayers;
        _windlablea.delegate = self;
        _windlablea.tag = 4;
//        [_windlablea addSubview:self.windPlace_a];
        

    }
    return _windlablea;
    
}
-(UITextView *)windlablem
{
    if (!_windlablem) {
//        _windlablem = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 0, 55 * (TYGetUIScreenWidth - 20)/ 351, 50)];
        _windlablem = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 0, TYGetUIScreenWidth - 14 - CGRectGetMaxX(_windlable.frame) - 2, 50)];
//        _windlablem.keyboardType = UIKeyboardTypeASCIICapableNumberPad;

        _windlablem.textColor = AppFont333333Color;
        _windlablem.font = [UIFont systemFontOfSize:12];
        _windlablem.textAlignment = NSTextAlignmentCenter;
//        _windlablem.placeholder = @"上午";
        _windlablem.backgroundColor = AppFontfafafaColor;
        
//        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_windlablem.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
//        maskLayers.frame = _windlablem.bounds;
//        maskLayers.path = maskPaths.CGPath;
//        _windlablem.layer.mask = maskLayers;
        _windlablem.tag =3;
        _windlablem.delegate = self;
//        [_windlablem addSubview:self.windPlace_m];
    }
    return _windlablem;
    
}
-(UILabel *)tempPlace_a
{
    if (!_tempPlace_a) {
        _tempPlace_a = [[UILabel alloc]initWithFrame:_templablea.frame];
        _tempPlace_a.textColor = AppFontccccccColor;
        _tempPlace_a.text = @"下午";
        _tempPlace_a.font = [UIFont systemFontOfSize:12];
        _tempPlace_a.textAlignment = NSTextAlignmentCenter;
    }
    return _tempPlace_a;
}
-(UILabel *)tempPlace_m
{
    if (!_tempPlace_m) {
        _tempPlace_m = [[UILabel alloc]initWithFrame:_templablem.frame];
        _tempPlace_m.textColor = AppFontccccccColor;
        _tempPlace_m.text = @"上午";
        _tempPlace_m.font = [UIFont systemFontOfSize:12];
        _tempPlace_m.textAlignment = NSTextAlignmentCenter;

    }
    return _tempPlace_m;

}
-(UILabel *)windPlace_a
{
    if (!_windPlace_a) {
        _windPlace_a = [[UILabel alloc]initWithFrame:_windlablea.frame];
        _windPlace_a.textColor = AppFontccccccColor;
        _windPlace_a.text = @"下午";
        _windPlace_a.font = [UIFont systemFontOfSize:12];
        _windPlace_a.textAlignment = NSTextAlignmentCenter;

    }
    return _windPlace_a;


}
-(UILabel *)windPlace_m
{
    if (!_windPlace_m) {
        _windPlace_m = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 0, TYGetUIScreenWidth - 20 - CGRectGetMaxX(_windlable.frame) - 2, 50)];
        _windPlace_m.textColor = AppFontccccccColor;
        _windPlace_m.text = @"上午";
        _windPlace_m.font = [UIFont systemFontOfSize:12];
        _windPlace_m.textAlignment = NSTextAlignmentCenter;

    }
    return _windPlace_m;


}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    [self contentSizeToFitWithTextView:textView];
//    [self contentSizeToFitWithTextView:self.windlablea];
//    [self contentSizeToFitWithTextView:self.windlablem];
//    [self contentSizeToFitWithTextView:self.templablea];
//    [self contentSizeToFitWithTextView:self.templablem];
    return YES;
}
- (void)contentSizeToFitWithTextView:(UITextView *)textView
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
//    if([textView.text length]>0)
//    {
        //textView的contentSize属性
        CGSize contentSize = textView.contentSize;
    if ([NSString isEmpty:textView.text]) {
        contentSize = CGSizeMake(contentSize.width, 30);
    }
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= textView.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = textView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 12;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > textView.frame.size.height)
            {
                [textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = textView.contentSize;
            }
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [textView setContentSize:newSize];
        [textView setContentInset:offset];
        
//    }
}
-(void)SelectedWeather:(UIGestureRecognizer *)state
{

    JGJWeatherPickerview *picker = [[JGJWeatherPickerview alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 260, TYGetUIScreenWidth, 260)];

    picker.delegate = self;
    picker.showCancel = YES;
    [picker showWeatherPickerView];
    picker.topname = @"选择天气";
    picker.titlearray = [NSMutableArray arrayWithObjects:@"晴",@"阴",@"多云",@"雨",@"雪",@"雾",@"霾",@"冰冻",@"风",@"停电", nil];
    picker.imagarray = [NSMutableArray arrayWithObjects:@"record_popup_claer",@"record_popup_overcast",@"record_popup_cloudy",@"record_popup_rain",@"record_popup_snow",@"record_popup_fog",@"record_popup_haze",@"record_popup_frost",@"record_popup_wind",@"record_popup_power-outage", nil];
    picker.allowsMultipleSelections = NO;
    
    tag = state.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clicKRecordWeatherlableAndtag:)]) {
        [self.delegate clicKRecordWeatherlableAndtag:state.view.tag];
    }

    if ([state.view isKindOfClass:[UILabel class]]) {
        
        UILabel *weaLable = (UILabel *)state.view;
        
        picker.selLable = weaLable;
        
        weaLable.backgroundColor = AppFontccccccColor;
        
        weaLable.textColor = AppFont000000Color;
        
    }

}
#pragma mark -选择天气
-(void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content
{
//    if (tag == 1) {
//        _sunylablem.text = content;
//    }else{
//    
//        _sunylablea.text = content;
//
//    }

}
-(void)didMoreselectweaterevent:(NSIndexPath *)indexpath andArr:(NSMutableArray *)selectArr andDelete:(BOOL)del
{
    if (tag == 1) {
        NSString *weatherStr;
        //_sunylablem.textColor = AppFont333333Color;

        if (selectArr.count==1) {
            
            weatherStr = selectArr.firstObject;
        }else if (selectArr.count == 2){
           weatherStr =   [NSString stringWithFormat:@"%@>%@",selectArr.firstObject,selectArr.lastObject];
        }else{
        
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWeatherAm:andtag:)]) {
            [self.delegate selectWeatherAm:weatherStr andtag:self.tag];
        }

        _morningArr = [[NSMutableArray alloc]initWithArray:selectArr];//上午的天气
        
//        _sendDailyModel.m_Arr = _morningArr;
        /*
        if (selectArr.count >= 2) {
            _sunylablem.text = [NSString stringWithFormat:@"%@>%@",selectArr.firstObject,selectArr[1]];

        }else{
            if (selectArr.count) {
                _sunylablem.text = selectArr.firstObject;
            }else{
                _sunylablem.text = @"上午";

            }
        }*/
    }else{
        
        //_sunylablea.textColor = AppFont333333Color;

        NSString *weatherStr;
        
        if (selectArr.count==1) {
            
            weatherStr = selectArr.firstObject;
        }else if (selectArr.count == 2){
            weatherStr =   [NSString stringWithFormat:@"%@>%@",selectArr.firstObject,selectArr.lastObject];
        }else{
            
            
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWeatherpm:andtag:)]) {
            [self.delegate selectWeatherpm:weatherStr andtag:self.tag];
        }

        
        _afterArr = [[NSMutableArray alloc]initWithArray:selectArr];//下午的天气
//        _sendDailyModel.a_Arr = _afterArr;
        /*
        if (selectArr.count >= 2) {
            _sunylablea.text = [NSString stringWithFormat:@"%@>%@",selectArr.firstObject,selectArr[1]];
            
        }else{
            if (selectArr.count) {
                _sunylablea.text = selectArr.firstObject;
            }else{
                _sunylablea.text = @"下午";

            
            }
        }*/
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 此处替换textview
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >10) {
        textView.text = [textView.text substringToIndex:9];
    }
    [self contentSizeToFitWithTextView:textView];
    
    switch (textView.tag) {
        case 1:
            if (textView.text.length <=0) {
                _tempPlace_m.hidden = NO;
            }else{
                _tempPlace_m.hidden = YES;

            }
            _sendDailyModel.temp_am = textView.text;
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectTempAm:andtag:)]) {
                [self.delegate selectTempAm:textView.text andtag:self.tag];
            }
            break;
        case 2:
            if (textView.text.length <=0) {
                _tempPlace_a.hidden = NO;
            }else{
                _tempPlace_a.hidden = YES;
            }

            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectTempPm:andtag:)]) {
                [self.delegate selectTempPm:textView.text andtag:self.tag];
            }
            _sendDailyModel.temp_pm = textView.text;
            break;
        case 3:
            if (textView.text.length <=0) {
                _windPlace_m.hidden = NO;
            }else{
                _windPlace_m.hidden = YES;
            }

            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWindAm:andtag:)]) {
                [self.delegate selectWindAm:textView.text andtag:self.tag];
            }
            _sendDailyModel.wind_am = textView.text;
            break;
        case 4:
            if (textView.text.length <=0) {
                _windPlace_a.hidden = NO;
            }else{
                _windPlace_a.hidden = YES;
            }

            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWindPm:andtag:)]) {
                [self.delegate selectWindPm:textView.text andtag:self.tag];
            }
            _sendDailyModel.wind_pm = textView.text;
            break;
        default:
            break;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 9 && ![NSString isEmpty:text]) {
        return NO;
    }
    return YES;

}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            _sendDailyModel.temp_am = textField.text;
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectTempAm:andtag:)]) {
                [self.delegate selectTempAm:textField.text andtag:self.tag];
            }
            break;
        case 2:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectTempPm:andtag:)]) {
                [self.delegate selectTempPm:textField.text andtag:self.tag];
            }
            _sendDailyModel.temp_pm = textField.text;
            break;
        case 3:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWindAm:andtag:)]) {
                [self.delegate selectWindAm:textField.text andtag:self.tag];
            }
            _sendDailyModel.wind_am = textField.text;
            break;
        case 4:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(selectWindPm:andtag:)]) {
                [self.delegate selectWindPm:textField.text andtag:self.tag];
            }

            _sendDailyModel.wind_pm = textField.text;
            break;
        default:
            break;
    }

}

- (void)clickTopbutton:(NSString *)buttonTitle
{
    if ([buttonTitle isEqualToString:@"确定"]) {
        if (tag == 1) {
            if (_morningArr.count >= 2) {
                _sunylablem.text = [NSString stringWithFormat:@"%@>%@",_morningArr.firstObject,_morningArr[1]];
                _sunylablem.textColor = AppFont333333Color;

            }else{
                if (_morningArr.count) {
                    _sunylablem.text = _morningArr.firstObject;
                    _sunylablem.textColor = AppFont333333Color;

                }else{
                    _sunylablem.text = @"上午";
                    _sunylablem.textColor = AppFontccccccColor;

                }
            }
        }else{
            if (_afterArr.count >= 2) {
                _sunylablea.text = [NSString stringWithFormat:@"%@>%@",_afterArr.firstObject,_afterArr[1]];
                _sunylablea.textColor = AppFont333333Color;

            }else{
                if (_afterArr.count) {
                    _sunylablea.text = _afterArr.firstObject;
                    _sunylablea.textColor = AppFont333333Color;

                }else{
                    _sunylablea.text = @"下午";
                    _sunylablea.textColor = AppFontccccccColor;

                }
            }
        }
    }else{
    
    
    }

    _sunylablem.backgroundColor = AppFontfafafaColor;
    
    _sunylablea.backgroundColor = AppFontfafafaColor;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 10 && ![NSString isEmpty:string]) {
        return NO;
    }
    return YES;

}
-(void)setweather_am:(NSString *)weather_am wether_pm:(NSString *)wether_pm tem_am:(NSString *)temp_am temp_pm:(NSString *)temp_pm wind_am:(NSString *)wind_am wimd_pm:(NSString *)wind_pm
{
    
    if (![NSString isEmpty:weather_am]) {
        _sunylablem.text = weather_am;
        _sunylablem.textColor = AppFont333333Color;
        
    }
    
    
    if (![NSString isEmpty:wether_pm]) {
        _sunylablea.text = wether_pm;
        _sunylablea.textColor = AppFont333333Color;
        
    }
    if (![NSString isEmpty:temp_am]) {
        _templablem.text = temp_am;
        _templablem.textColor = AppFont333333Color;
        _tempPlace_m.hidden = YES;
        [self contentSizeToFitWithTextView:_templablem];

    }
    if (![NSString isEmpty:temp_pm]) {
        _templablea.text = temp_pm;
        _templablea.textColor = AppFont333333Color;
        _tempPlace_a.hidden = YES;
        [self contentSizeToFitWithTextView:_templablea];


    }
    if (![NSString isEmpty:wind_am]) {
        _windlablem.text = wind_am;
        _sunylablem.textColor = AppFont333333Color;
        _windPlace_m.hidden = YES;
        [self contentSizeToFitWithTextView:_windlablem];

    }
    if (![NSString isEmpty:wind_pm]) {
        _windlablea.text = wind_pm;
        _sunylablem.textColor = AppFont333333Color;
        _windPlace_a.hidden = YES;
        [self contentSizeToFitWithTextView:_windlablea];

    }
    

}
@end
