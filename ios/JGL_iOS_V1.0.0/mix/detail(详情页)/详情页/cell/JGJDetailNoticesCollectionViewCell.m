//
//  JGJDetailNoticesCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/12/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDetailNoticesCollectionViewCell.h"
#import "UILabel+GNUtil.h"
#import "JGJLableSize.h"
@implementation JGJDetailNoticesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    if ([dataDic[@"is_system_reply"]?:@"0" intValue]) {
        //处理系统消息
        _contentLable.userInteractionEnabled = NO;
        
        _contentLable.text = [NSString stringWithFormat:@"%@\n%@",dataDic[@"user_info"][@"real_name"],dataDic[@"reply_text"]];
        
        [_contentLable markText:dataDic[@"reply_text"]?:@"" withColor:AppFont999999Color];
        
//        [_contentLable markLineText:dataDic[@"reply_text"]?:@"" withLineFont:_contentLable.font withColor:AppFont999999Color lineSpace:1];
        
    }
    _timeLable.text =   dataDic[@"create_time"]?:@"";
    
    _widthConstance.constant = [JGJLableSize RowWidth:dataDic[@"create_time"]?:@"" andFont:[UIFont systemFontOfSize:13.1]];

}
@end
