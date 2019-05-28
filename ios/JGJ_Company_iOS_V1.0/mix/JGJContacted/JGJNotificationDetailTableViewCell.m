//
//  JGJNotificationDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotificationDetailTableViewCell.h"

@implementation JGJNotificationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        label.backgroundColor = [UIColor grayColor];
        [self addSubview:label];
        _RealNameLable.textColor = [UIColor blueColor];

        _RealNameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 100, 20)];

        [self.contentView addSubview:_RealNameLable];
        
        [self.contentView addSubview:self.Timelable];
        _desLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _desLable.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_desLable];
        
    }

    return  self;
}
-(UILabel *)RealNameLable
{
    if (!_RealNameLable) {
    }
    return _RealNameLable;
}
-(UILabel *)Timelable
{

    if (!_Timelable) {
        _Timelable = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, [UIScreen mainScreen].bounds.size.width-120, 20)];
        _Timelable.font = [UIFont systemFontOfSize:12];
        _Timelable.textColor = [UIColor darkGrayColor];
        _Timelable.textAlignment = NSTextAlignmentRight;

    }

    return _Timelable;
}

-(float)getheight
{
    
    NSLog(@" === %f",_desLable.frame.size.height);
    
    return _desLable.frame.size.height+45;

}

-(NSString *)StringToTime:(NSString *)Timestr
{

//    NSString *string = @"20160707094106";
    NSString*str=@"1368082020";//时间戳
    
    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
      return currentDateStr;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setListModel:(JGJChatMsgListModel *)listModel
{





}
-(void)setDataArray:(NSMutableDictionary *)DataArray
{

    _DataArray = [NSMutableDictionary dictionary];
    _DataArray = DataArray;
    _RealNameLable.textColor = [UIColor blueColor];
    _RealNameLable.font = [UIFont systemFontOfSize:15];
    _RealNameLable.text = _DataArray[@"real_name"][@"real_name"];
    _Timelable.text = [self StringToTime:_DataArray[@"create_time"]];
//    _Timelable.text = _DataArray[@"create_time"];
    _desLable.font = [UIFont systemFontOfSize:14];
    _desLable.text = _DataArray[@"reply_text"];
    _desLable.backgroundColor = [UIColor clearColor];
    _desLable.numberOfLines = 0;
    _desLable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-10, 3000);
    CGSize expectSize = [_desLable sizeThatFits:maximumLabelSize];
    _desLable.frame = CGRectMake(5, 35, expectSize.width, expectSize.height);


}

@end
