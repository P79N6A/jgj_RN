//
//  JGJPersonLastWageListView.m
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonLastWageListView.h"

@interface JGJPersonLastWageListView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftMonthLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightMonthLabel;

@end

@implementation JGJPersonLastWageListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    self.totalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.totalLabel.font.pointSize];
}

- (void)updateData:(NSDictionary *)dataDic{
    
    if (!dataDic) {
        return;
    }
    
    //收入
    CGFloat total = [dataDic[@"total"] floatValue];
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f",total];
    self.totalLabel.textColor = total >= 0?TYColorHex(0xd7252c):TYColorHex(0x82c76c);
    
    //标题
    NSString *titleMonthStr = dataDic[@"titleMonthStr"];
    self.titleLabel.text = titleMonthStr;
    
    NSInteger monthNum = [dataDic[@"monthNum"] integerValue];
    //左右的月份
    if (monthNum == 1) {
        self.leftMonthLabel.text = @"12月";
        self.rightMonthLabel.text = @"2月";
    }else if(monthNum == 12){
        self.leftMonthLabel.text = @"11月";
        self.rightMonthLabel.text = @"1月";
    }else{
        self.leftMonthLabel.text = [NSString stringWithFormat:@"%ld月",monthNum - 1];
        self.rightMonthLabel.text = [NSString stringWithFormat:@"%ld月",monthNum + 1];
    }
    
}
- (void)setDataDic:(NSMutableDictionary *)dataDic{
    _dataDic = dataDic;
    [self updateData:dataDic];
}


- (IBAction)leftBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PersonLastWageListLeftBtnClick:)]) {
        [self.delegate PersonLastWageListLeftBtnClick:self];
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PersonLastWageListRightBtnClick:)]) {
        [self.delegate PersonLastWageListRightBtnClick:self];
    }
}

@end
