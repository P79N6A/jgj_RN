//
//  JGJLeaderRecordButtonView.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLeaderRecordButtonView.h"

#import "UILabel+JGJCopyLable.h"
@implementation JGJLeaderRecordButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    
    return self;
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    
}
- (void)initView
{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJLeaderRecordButtonView" owner:self options:nil]firstObject];
    [self.contentView setFrame:self.bounds];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    self.recordMoreButton.layer.masksToBounds = YES;
    self.recordMoreButton.layer.cornerRadius = 5;
    self.recordMoreButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    self.recordMoreButton.layer.borderWidth = 1;

    self.recordSingerButton.backgroundColor = AppFontEB4E4EColor;
    self.recordSingerButton.layer.masksToBounds = YES;
    self.recordSingerButton.layer.cornerRadius = 5;
    [self addSubview:self.contentView];
    [self loadRecorSingerBuutonView];
    [self loadMoreButton];
    
}
- (void)loadRecorSingerBuutonView{
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-7, 0, (TYGetUIScreenWidth - 40)/4, 45)];
    titleLable.text = @"记一笔工";
    titleLable.textColor = AppFontffffffColor;
    titleLable.font = [UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment = NSTextAlignmentRight;
    [self.recordSingerButton addSubview:titleLable];
    
    UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake((TYGetUIScreenWidth - 40)/4 , 0, (TYGetUIScreenWidth - 40)/4, 45)];
    contentLable.text = [NSString stringWithFormat:@"%@\n%@",@"点工  包工",@"借支  结算"];
    contentLable.textColor = AppFontffffffColor;
    [contentLable SetLinDepart:2];
    contentLable.numberOfLines = 2;
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:10];
    [self.recordSingerButton addSubview:contentLable];
    
    
}
- (void)loadMoreButton{
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (TYGetUIScreenWidth - 40)/4, 45)];
    titleLable.text = @"批量记工";
    titleLable.textColor = AppFontEB4E4EColor;
    titleLable.font = [UIFont boldSystemFontOfSize:16];
    titleLable.textAlignment = NSTextAlignmentRight;
    [self.recordMoreButton addSubview:titleLable];
    
    UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake((TYGetUIScreenWidth - 40)/4 + 5 , 0, (TYGetUIScreenWidth - 40)/4, 45)];
    contentLable.text = @"点工 包工";
    contentLable.textColor = AppFontEB4E4EColor;
//    [contentLable SetLinDepart:5];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:10];
    [self.recordMoreButton addSubview:contentLable];
}
- (IBAction)clickRecordMoreButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJLeaderRecordButtonClickMoreButton)]) {
        [self.delegate JGJLeaderRecordButtonClickMoreButton];
    }
}
- (IBAction)clickRecordSingerButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJLeaderRecordButtonClicksingerButton)]) {
        [self.delegate JGJLeaderRecordButtonClicksingerButton];
    }
}

@end
