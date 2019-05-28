//
//  JGJpeopleRecTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJpeopleRecTableViewCell.h"

@implementation JGJpeopleRecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNameLableAdnThisTag)];
    _nameLable.userInteractionEnabled = YES;
    [_nameLable addGestureRecognizer:tap];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(JGJRainCalenderDetailModel *)model
{
    _recordPeoplelable.text = @"记录员：";
    _nameLable.text = model.record_info.real_name;
    
    if ([model.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        _recordPeoplelable.textColor = AppFont333333Color;
//        _nameLable.textColor = AppFont333333Color;
    }else{
        
    }
}
-(void)tapNameLableAdnThisTag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSumerNameLableandTag:)]) {
        [self.delegate tapSumerNameLableandTag:_nameLable.tag];
    }

}
@end
