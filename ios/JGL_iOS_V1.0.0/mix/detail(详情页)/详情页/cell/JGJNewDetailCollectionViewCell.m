//
//  JGJNewDetailCollectionViewCell.m
//  test
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 test. All rights reserved.
//

#import "JGJNewDetailCollectionViewCell.h"
#import "JGJTime.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"

@implementation JGJNewDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JGJChatMsgListModel *)model
{



}
-(void)setDataArray:(NSMutableDictionary *)DataArray
{
    
    
    if ([DataArray[@"user_info"] isKindOfClass:[NSDictionary class]]) {
    
        _NameLbale.text = DataArray[@"user_info"][@"real_name"];
    }
    _NameLbale.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNameLable)];
    
    [_NameLbale addGestureRecognizer:tap];
    
    _Timelable.text =   DataArray[@"create_time"];
    
    if ([DataArray[@"is_system_reply"]?:@"0" intValue]) {
        //处理系统消息
        _NameLbale.userInteractionEnabled = NO;
        
        _systemNoticeImageview.hidden = NO;
        
        _NameLbale.text = [NSString stringWithFormat:@"%@ %@",DataArray[@"user_info"][@"real_name"],DataArray[@"reply_text"]];
        
        [_NameLbale markText:DataArray[@"reply_text"]?:@"" withColor:AppFont666666Color];
        
        _nameLableConstance.constant = 36;
        
    }else{
        
        _systemNoticeImageview.hidden = YES;
        
        _nameLableConstance.constant = 10;
        
        _ContentLable.text = DataArray[@"reply_text"]?:@"";
        
        _ContentLable.textColor = AppFont333333Color;
        
        [_ContentLable SetLinDepart:5];
        
        [_ContentLable creatInternetHyperlinks];
        
        if ([DataArray[@"operate_delete"] integerValue] == 1) {
            
            _ContentLable.userInteractionEnabled = NO;
        }else {
            
            _ContentLable.userInteractionEnabled = YES;
        }
        
        

    }
    if ([DataArray[@"reply_mode"] integerValue] == 1 ) {
        if ([DataArray[@"reply_text"] containsString:@"待处理"]) {
            [_ContentLable markText:@"[待处理]" withColor:AppFont333333Color];
        }
        if ([DataArray[@"reply_text"] containsString:@"已完成"]) {
            [_ContentLable markText:@"[已完成]" withColor:AppFont333333Color];
            
        }
    }
    _DepartLable.backgroundColor = AppFontdbdbdbColor;
}
-(void)clickNameLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:)]) {
        [self.delegate JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:_NameLbale.tag];
    }

}
@end
