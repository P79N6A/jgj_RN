//
//  JGJHadReciveCollectionViewCell.m
//  test
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 test. All rights reserved.
//

#import "JGJHadReciveCollectionViewCell.h"
#import "UILabel+GNUtil.h"

@implementation JGJHadReciveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _hadRecive.selected = YES;
    _hadRecive.backgroundColor = [UIColor whiteColor];
    _DontReply.backgroundColor = [UIColor whiteColor];
    [_hadRecive setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
    [_hadRecive setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [_DontReply setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
    [_DontReply setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    _DontReply.titleLabel.textAlignment = NSTextAlignmentLeft;
   _leftlable = [[UILabel alloc]initWithFrame:CGRectMake(7, CGRectGetHeight(_hadRecive.frame)-2, 38, 2)];
    _leftlable.backgroundColor = AppFontEB4E4EColor;
    [_hadRecive addSubview:_leftlable];
    _rightlable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_hadRecive.frame)-2, 38, 2)];
    _rightlable.backgroundColor = AppFontEB4E4EColor;
    [_DontReply addSubview:_rightlable];
    _rightlable.hidden = YES;
    _lable = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, TYGetUIScreenWidth, .5)];
    _lable.backgroundColor = AppFontdbdbdbColor;
    [self.contentView addSubview:_lable];
    self.contentView.backgroundColor = [UIColor whiteColor];
    // Initialization code
}
-(void)setRecivepepole:(NSString *)recivepepole
{
    _recivepepole = recivepepole;
    if (_taskType) {
        
    }else{
        [_hadRecive setTitle:[recivepepole isEqualToString:@"0"]?@"已收到":[NSString stringWithFormat:@"已收到(%@)",recivepepole] forState:UIControlStateNormal];
        //此处是为了改变后面的颜色
        
        _DontReply.selected = NO;
        _hadRecive.selected = YES;
        _rightlable.hidden = YES;
        _leftlable.hidden = NO;
        
    }

}

-(void)setNumpepole:(NSString *)numpepole
{
    _numpepole = numpepole;

    if (_taskType) {
        
        [_DontReply setTitle:[numpepole isEqualToString:@"0"]?@"参与者":[NSString stringWithFormat:@"参与者(%@)",numpepole] forState:UIControlStateNormal];
        
        
    }else{
        [_DontReply setTitle:[numpepole isEqualToString:@"0"]?@"未反馈":[NSString stringWithFormat:@"未反馈(%@)",numpepole] forState:UIControlStateNormal];
        //此处是为了改变后面的颜色
        
        _DontReply.selected = NO;
        _hadRecive.selected = YES;
        _rightlable.hidden = YES;
        _leftlable.hidden = NO;

    }
}
-(void)setNormalStr:(NSString *)normalStr
{
    if ([NSString isEmpty:_numpepole]) {

    [_DontReply setTitle:[normalStr isEqualToString:@"0"]?@"未反馈":[NSString stringWithFormat:@"未反馈(%@)",normalStr] forState:UIControlStateNormal];
    //此处是为了改变后面的颜色
    
    _DontReply.selected = NO;
    _hadRecive.selected = YES;
    _rightlable.hidden = YES;
    _leftlable.hidden = NO;
}

}
-(void)setTaskTypeButton
{
    
    [_DontReply setTitle:@"待处理" forState:UIControlStateNormal];
    _DontReply.selected = NO;
    _hadRecive.selected = YES;
    _rightlable.hidden = YES;
    _leftlable.hidden = NO;
    CGSize size=[_DontReply.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    CGRect rect = _rightlable.frame;
    rect.size.width = size.width;
    [_rightlable setFrame:rect];
    
    
}

-(void)setModel:(JGJChatMsgListModel *)model
{
    _RightLable.text = @"";
    _LeftLable.text = @"";
    _RightLable.text = [NSString stringWithFormat:@"来自：%@",model.from_group_name];

}
-(void)setHadStr:(NSString *)HadStr
{
   
   _LeftLable.text = @"";
    _RightLable.text =@"";
   _LeftLable.text = @"他们已收到：";
}
- (IBAction)hadRecive:(id)sender {
    _DontReply.selected = NO;
    _hadRecive.selected = YES;
    _rightlable.hidden = YES;
    _leftlable.hidden = NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickDetailLeftButton:)]) {
        [self.delegate ClickDetailLeftButton:_hadRecive];
    }
    
 }

- (IBAction)dontReply:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    _hadRecive.selected = NO;
    _DontReply.selected = YES;
    _rightlable.hidden = NO;
    _leftlable.hidden = YES;
        
          });
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickDetailRightButton:)]) {
        [self.delegate ClickDetailRightButton:_DontReply];
    }
    

    

}
@end
