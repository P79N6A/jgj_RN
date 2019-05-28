//
//  JGJFSCalendarCell.m
//  mix
//
//  Created by Tony on 2016/12/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFSCalendarCell.h"
#import "UILabel+GNUtil.h"

@interface JGJFSCalendarCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *recordWorkImageView;
@property (strong, nonatomic) IBOutlet UILabel *subDetailLable;
@property (strong ,nonatomic)UIImageView *imageview;
@end

@implementation JGJFSCalendarCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.recordWorkImageView.hidden = YES;
}

//父类方法不实现
- (void)setUpView{};

- (void)setUpBounds:(CGRect)bounds{};

- (void)setUpPrepareForReuse{};

- (void)configureCell
{
//    _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    [self.contentView addSubview:_imageview];
//    _imageview.backgroundColor = [UIColor orangeColor];
//    _imageview.alpha = .5;
//    self.backgroundColor = AppFontf1f1f1Color;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",@([self.calendar dayOfDate:self.date])];
    
    BOOL isNotRest = arc4random_uniform(2);
    
    if (isNotRest) {
        NSString *workTimeStr = @"20d";
        NSString *overTimeStr = @"2h";
        
        self.contentLabel.text = [NSString stringWithFormat:@"%@\n%@",workTimeStr,overTimeStr];
        UIFont *contentFont = self.contentLabel.font;//[UIFont systemFontOfSize:self.contentLabel.font.pointSize/2.0];
        [self.contentLabel markattributedTextArray:@[workTimeStr] color:JGJMainColor font:contentFont];
        [self.contentLabel markattributedTextArray:@[overTimeStr] color:[UIColor blueColor] font:contentFont];
//        _subDetailLable.text = @"2.5h";
    }else{
        self.contentLabel.text = @"休息";
        [self.contentLabel markattributedTextArray:@[self.contentLabel.text] color:[UIColor greenColor] font:self.contentLabel.font];
    }
    
    BOOL isPoorBill = arc4random_uniform(2);
    self.recordWorkImageView.hidden = isPoorBill;
}
-(void)setRecordStr:(NSString *)recordStr
{
    _subDetailLable.text = recordStr;


}

@end
