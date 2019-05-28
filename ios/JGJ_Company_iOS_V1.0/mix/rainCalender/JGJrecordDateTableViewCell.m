//
//  JGJrecordDateTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJrecordDateTableViewCell.h"

@implementation JGJrecordDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDateTimeLableText:(NSString *)time andProText:(NSString *)pro
{
    NSRange range = [time rangeOfString:@" "];
    
    NSString *replaceDay = [time substringWithRange:NSMakeRange(range.location, 5)];
    
    NSString *date = [time stringByReplacingOccurrencesOfString:replaceDay withString:@""];
    
    _dateTimeLable.text = date;
    
    _proLable.text = pro;

}
@end
