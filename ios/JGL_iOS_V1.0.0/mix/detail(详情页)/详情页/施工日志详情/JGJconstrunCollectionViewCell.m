//
//  JGJconstrunCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJconstrunCollectionViewCell.h"

@implementation JGJconstrunCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.placeView];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 81, TYGetUIScreenWidth - 20,0.5)];
    
    lable.backgroundColor = AppFontdbdbdbColor;
    [self.contentView addSubview:lable];
    
//    [_placeView addSubview:self.departLable];

    // Initialization code
}
-(void)setChatMsgListModel:(JGJChatMsgListModel *)ChatMsgListModel
{
    _ChatMsgListModel = [JGJChatMsgListModel new];
    
    _ChatMsgListModel = ChatMsgListModel;
    if (![NSString isEmpty: ChatMsgListModel.weat_pm ]) {
        _sunylablea.text = ChatMsgListModel.weat_pm ;
        _sunylablea.textColor = AppFont333333Color;
    }else{
        _sunylablea.text = @"   " ;

    }
    if (![NSString isEmpty: ChatMsgListModel.weat_am ]) {
        _sunylablem.text =ChatMsgListModel.weat_am;
        _sunylablem.textColor = AppFont333333Color;
        
    }else{
        _sunylablem.text =@"   ";

    
    }
    if (![NSString isEmpty: ChatMsgListModel.temp_pm ]) {
        _templablea.text = ChatMsgListModel.temp_pm;
        _templablea.textColor = AppFont333333Color;
        
    }else{
    
        _templablea.text = @"    ";

    }
    if (![NSString isEmpty: ChatMsgListModel.temp_am ]) {
        _templablem.text = ChatMsgListModel.temp_am;
        _templablem.textColor = AppFont333333Color;
        
    }else{
        _templablem.text = @"   ";

    
    }
    if (![NSString isEmpty: ChatMsgListModel.wind_pm ]) {
        _windlablea.text =ChatMsgListModel.wind_pm;
        _windlablea.textColor = AppFont333333Color;
        
    }else{
    
        _windlablea.text =@"    ";

    }
    if (![NSString isEmpty: ChatMsgListModel.wind_am ]) {
        _windlablem.text =ChatMsgListModel.wind_am;
        _windlablem.textColor = AppFont333333Color;
        
    }else{
        _windlablem.text =@"    ";

    
    }
    
}
-(UIView *)placeView
{
    if (!_placeView) {
        _placeView = [[UIView alloc]initWithFrame:CGRectMake(12, 1.5, TYGetUIScreenWidth - 24, 70)];
        _placeView.backgroundColor = [UIColor whiteColor];
        _placeView.layer.masksToBounds = YES;
        _placeView.layer.cornerRadius = 5;
        [_placeView addSubview:self.weatherLable];
        [_placeView addSubview:self.sunylablem];
        [_placeView addSubview:self.sunylablea];
        [_placeView addSubview:self.templable];
        [_placeView addSubview:self.templablea];
        [_placeView addSubview:self.templablem];
        [_placeView addSubview:self.windlable];
        [_placeView addSubview:self.windlablem];
        [_placeView addSubview:self.windlablea];
        
    }
    return _placeView;
}
- (UILabel *)departLable
{
    if (!_departLable) {
        _departLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sunylablea.frame), 0, 1, 70)];
        _departLable.backgroundColor = [UIColor whiteColor];
    }
    return _departLable;
}
-(UILabel *)weatherLable
{
    if (!_weatherLable) {
        _weatherLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 46 * (TYGetUIScreenWidth - 20)/ 351, 70)];
        _weatherLable.textColor = AppFont999999Color;
        _weatherLable.text = @"天气";
        _weatherLable.font = [UIFont systemFontOfSize:12];
        _weatherLable.textAlignment = NSTextAlignmentCenter;
        _weatherLable.backgroundColor = AppFontf1f1f1Color;
    }
    return _weatherLable;
}

-(UILabel *)sunylablea
{
    if (!_sunylablea) {
        _sunylablea = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weatherLable.frame) + 1, 35, (int)(70 * (TYGetUIScreenWidth - 20)/ 351), 35)];
        _sunylablea.textColor = AppFont666666Color;
        _sunylablea.font = [UIFont systemFontOfSize:11];
        _sunylablea.textAlignment = NSTextAlignmentCenter;
        _sunylablea.backgroundColor = AppFontf1f1f1Color;
        
        
        
    }
    return _sunylablea;
    
}
- (void)deleteBlackLine
{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping ;
//    [paragraphStyle setLineSpacing:4];
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle.copy};
//    
//    CGSize size = [ des boundingRectWithSize:CGSizeMake(cellWidth, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil ].size ;
//    size.width = ceil(size.width);
//    size.height = ceil(height);
    
}
-(UILabel *)sunylablem
{
    if (!_sunylablem) {
        _sunylablem = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weatherLable.frame) + 1, 0, (int)(70 * (TYGetUIScreenWidth - 20)/ 351), 34)];
        _sunylablem.textColor = AppFont666666Color;
        _sunylablem.font = [UIFont systemFontOfSize:11];
        _sunylablem.textAlignment = NSTextAlignmentCenter;
        _sunylablem.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _sunylablem;
    
    
}
-(UILabel *)templable
{
    if (!_templable) {
        _templable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sunylablea.frame) +1, 0, 44 * (TYGetUIScreenWidth - 20)/ 351, 70)];
        _templable.textColor = AppFont999999Color;
        _templable.font = [UIFont systemFontOfSize:12];
        _templable.textAlignment = NSTextAlignmentCenter;
        //      _templable.text = @"温度℃";
        _templable.numberOfLines = 2;
        _templable.text = [NSString stringWithFormat:@"%@",@"温度\n℃"];
        _templable.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _templable;
    
}
-(UILabel *)templablem
{
    if (!_templablem) {
        _templablem = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templable.frame) + 1, 0,(int)( 66 * (TYGetUIScreenWidth - 20)/ 351), 34)];
        _templablem.textColor = AppFont666666Color;
        _templablem.numberOfLines = 2;
        _templablem.font = [UIFont systemFontOfSize:11];
        _templablem.textAlignment = NSTextAlignmentCenter;
        _templablem.text = @"";
        _templablem.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _templablem;
    
    
}
-(UILabel *)templablea
{
    if (!_templablea) {
        _templablea = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templable.frame) + 1, 35, (int)(66 * (TYGetUIScreenWidth - 20)/ 351), 35)];
        _templablea.textColor = AppFont666666Color;
        _templablea.font = [UIFont systemFontOfSize:11];
        _templablea.textAlignment = NSTextAlignmentCenter;
        _templablea.text = @"";
        _templablea.numberOfLines = 2;
        _templablea.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _templablea;
    
}
-(UILabel *)windlable
{
    if (!_windlable) {
        _windlable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_templablea.frame) +1, 0, 44* (TYGetUIScreenWidth - 20)/ 351, 70)];
        _windlable.textColor = AppFont999999Color;
        _windlable.font = [UIFont systemFontOfSize:12];
        _windlable.textAlignment = NSTextAlignmentCenter;
        _windlable.numberOfLines = 2;
        _windlable.text = [NSString stringWithFormat:@"%@",@"风力\n(级)"];
        _windlable.backgroundColor = AppFontf1f1f1Color;
    }
    return _windlable;
}
-(UILabel *)windlablea
{
    if (!_windlablea) {
        _windlablea = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 35,(int)( 65 * (TYGetUIScreenWidth - 20)/ 351), 35)];
        _windlablea.textColor = AppFont666666Color;
        _windlablea.font = [UIFont systemFontOfSize:11];
        _windlablea.textAlignment = NSTextAlignmentCenter;
        _windlablea.text = @"";
        _windlablea.numberOfLines = 2;
        
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_windlablea.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _windlablea.bounds;
        maskLayers.path = maskPaths.CGPath;
        _windlablea.layer.mask = maskLayers;
        
        _windlablea.backgroundColor = AppFontf1f1f1Color;
    }
    return _windlablea;
}
-(UILabel *)windlablem
{
    if (!_windlablem) {
        _windlablem = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_windlable.frame) + 1, 0, (int)(65 * (TYGetUIScreenWidth - 20)/ 351), 34)];
        UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:_windlablem.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
        maskLayers.frame = _windlablem.bounds;
        maskLayers.path = maskPaths.CGPath;
        _windlablem.layer.mask = maskLayers;
        
        _windlablem.textColor = AppFont666666Color;
        _windlablem.font = [UIFont systemFontOfSize:11];
        _windlablem.textAlignment = NSTextAlignmentCenter;
        _windlablem.text = @"";
        _windlablem.numberOfLines = 2;
        
        _windlablem.backgroundColor = AppFontf1f1f1Color;
        
    }
    return _windlablem;
    
}
@end
