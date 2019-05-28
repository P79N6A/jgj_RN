//
//  JGJQuaSafeHomeTopCell.m
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeHomeTopCell.h"

#define LineTop TYIS_IPHONE_5 ? 23 : 26

@interface JGJQuaSafeHomeTopCell ()

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (strong, nonatomic)  NSMutableArray *typeLables;



@end

@implementation JGJQuaSafeHomeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
//    [self setTopCellUI];
    
}

- (void)setTopInfos:(NSMutableArray *)topInfos {
    
    _topInfos = topInfos;
    
    if (self.typeLables.count == 0) {
        
       [self setTopCellUI];
        
    }
    
    for (UILabel *typeLable in self.typeLables) {
        
        NSInteger index = typeLable.tag - 100;
        
        JGJQuaSafeHomeModel *topModel = topInfos[index];
        
        typeLable.text = topModel.title;
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopCellUI {
    
    CGFloat thumbnailImageViewW = TYGetUIScreenWidth * 1.0 / _topInfos.count;
    
    NSMutableArray *thumbnails = [NSMutableArray new];
    
    NSMutableArray *types = [NSMutableArray new];
    
    self.typeLables = types;
    
    NSMutableArray *lineViews = [NSMutableArray new];
    
    NSMutableArray *actionButtons = [NSMutableArray new];
    
    for (NSInteger indx = 0; indx < _topInfos.count; indx ++) {
        
        UIButton *actionButton = [[UIButton alloc] init];
                
        actionButton.tag = 200 + indx;
        
        [actionButton addTarget:self action:@selector(selTypeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [actionButtons addObject:actionButton];
        
        [self.containView addSubview:actionButton];
        
        JGJQuaSafeHomeModel *topModel = _topInfos[indx];
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] init];
        
        thumbnailImageView.image = [UIImage imageNamed:topModel.icon];
        
        thumbnailImageView.contentMode = UIViewContentModeCenter;
        
        [thumbnails addObject:thumbnailImageView];
        
        [self.containView addSubview:thumbnailImageView];
        
        UILabel *typeLable = [UILabel new];
        
        typeLable.tag = 100 + indx;
        
        typeLable.textAlignment = NSTextAlignmentCenter;
        
        typeLable.text = topModel.title;
        
        [types addObject:typeLable];
        
        typeLable.textColor = AppFont666666Color;
        
        typeLable.font = [UIFont systemFontOfSize:AppFont28Size];
        
        [self.containView addSubview:typeLable];
        
        if (indx < _topInfos.count - 1) {
            
            UIView *lineView = [UIView new];
            
            lineView.backgroundColor = AppFontdbdbdbColor;
            
            [lineViews addObject:lineView];
            
            [self.containView addSubview:lineView];
        }
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containView.mas_top).mas_offset(LineTop);
        
        make.height.mas_equalTo(30);
        
//        make.width.mas_equalTo(thumbnailImageViewW);
        
    }];
    
    [actionButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [actionButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containView.mas_top).mas_offset(LineTop);
        
        make.height.with.mas_equalTo(thumbnailImageViewW);
        
    }];
    
    [types mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [types mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containView.mas_top).mas_offset(59);
        
        make.height.mas_equalTo(30);
    
//        make.width.mas_equalTo(thumbnailImageViewW);
        
    }];
    
    CGFloat space = (TYGetUIScreenWidth - lineViews.count * 0.5)  / _topInfos.count;
    
    if (lineViews.count == 1) {
        
        [lineViews mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.containView.mas_centerX);
            
            make.top.equalTo(self.containView.mas_top).mas_offset(LineTop);
            
            make.height.mas_equalTo(55);
            
            make.width.mas_equalTo(0.5);
            
        }];
        
    }else {
      
        [lineViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:space tailSpacing:space];
        
        [lineViews mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.containView.mas_top).mas_offset(LineTop);
            
            make.height.mas_equalTo(55);
            
            make.width.mas_equalTo(0.5);
            
        }];
        
    }
    
}

#pragma mark - 类型按钮按下
- (void)selTypeButtonPressed:(UIButton *)sender {
    
    NSUInteger index = sender.tag - 200;
    
    if (self.quaSafeHomeTopCellBlock) {
        
        self.quaSafeHomeTopCellBlock(index);
    }
}

+(CGFloat)JGJQuaSafeHomeTopCellHeight {
    
    return TYIS_IPHONE_5 ? 110 : 140;
}

@end
