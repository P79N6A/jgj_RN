//
//  JGJTaskTypeCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/6/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskTypeCollectionViewCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@implementation JGJTaskTypeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    // Initialization code
}
-(void)setModel:(JGJChatMsgListModel *)model
{
    NSString *taskStr;
    UIColor *textColor ;
        if ([model.task_level isEqualToString:@"1"]) {
            taskStr = @"";
            textColor = AppFont333333Color;
        }else if ([model.task_level isEqualToString:@"2"])
        {
            taskStr = @"[紧急]";
            textColor = TYColorHex(0XF9A00F);;
        }else if ([model.task_level isEqualToString:@"3"]){
            
            taskStr = @"[非常紧急]";
            textColor = AppFontEB4E4EColor;
        }else{
            taskStr = @"";
            textColor = AppFont333333Color;
        }
    
    _taskLable.text = taskStr;
    _taskLable.textColor = textColor;
    _taskLable.font = [UIFont boldSystemFontOfSize:15];
    if (![NSString isEmpty: model.task_finish_time]) {
        _taskTypeLable.text = [@"完成期限：" stringByAppendingString: model.task_finish_time ]?:@"";
        _taskTypeLable.textColor = textColor;
        _taskTypeLable.font = [UIFont systemFontOfSize:15];
    }

    /*
        _taskTypeLable.textColor = AppFont333333Color;
        if (!model.task_finish_time.length && !taskStr.length) {
            
        }else if (!model.task_finish_time.length &&taskStr.length)
        {
            _taskTypeLable.text = [NSString stringWithFormat:@"%@",taskStr];
        }else if (model.task_finish_time.length &&!taskStr.length){
            _taskTypeLable.text = [NSString stringWithFormat:@"%@%@",@"  完成时间:",model.task_finish_time];
        }
        else{
            _taskTypeLable.text = [NSString stringWithFormat:@"%@%@%@",taskStr,@"  完成时间:",model.task_finish_time];
        }
        [_taskTypeLable markText:taskStr withFont:[UIFont boldSystemFontOfSize:15] color:textColor];
        [_taskTypeLable markText:[NSString stringWithFormat:@"%@%@",@"  完成时间:",model.task_finish_time] withFont:[UIFont systemFontOfSize:15] color:textColor];
        */
//        [_taskTypeLable markText:model.msg_text withFont:[UIFont systemFontOfSize:15] color:AppFont333333Color];
}
@end
