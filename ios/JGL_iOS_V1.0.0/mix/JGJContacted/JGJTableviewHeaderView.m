//
//  JGJTableviewHeaderView.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTableviewHeaderView.h"

@implementation JGJTableviewHeaderView
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

- (void)addHeaderView {
    
    self.contractorHeader.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 45, CGRectGetWidth(self.frame), 45);
    [self addSubview:self.contractorHeader];
}

- (void)initView
{
    
    [[[NSBundle mainBundle]loadNibNamed:@"JGJTableviewHeaderView" owner:self options:nil]firstObject];

    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-6, 44, 12, 12)];
    self.leftImageView.layer.cornerRadius = 6;
    self.leftImageView.layer.masksToBounds =YES;
    self.leftImageView.backgroundColor = AppFont3A3F4EColor;
    [self.contentView addSubview:self.leftImageView];
    self.rightmageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 6, 44, 12, 12)];
    self.rightmageView.backgroundColor = AppFont3A3F4EColor;
    self.rightmageView.layer.cornerRadius = 6;
    self.rightmageView.layer.masksToBounds =YES;
    [self.contentView addSubview:self.rightmageView];
//    [self.titleLable.layer addSublayer:shaplayer];

}

- (void)setContractorType:(NSInteger)contractorType {
    
    _contractorType = contractorType;
    if (_contractorType == 1) {
        
        if (JLGisLeaderBool) {
            
            self.amountLable.textColor = AppFont83C76EColor;
        }
        
    }
    
}

- (JGJRecordBillDetailContractorHeaderTypeView *)contractorHeader {
    
    if (!_contractorHeader) {
        
        _contractorHeader = [[JGJRecordBillDetailContractorHeaderTypeView alloc] init];
    }
    return _contractorHeader;
}
@end
