//
//  JGJCheckAccountHeaderView.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckAccountHeaderView.h"

#import "JGJCustomLable.h"

@interface JGJCheckAccountHeaderView ()

@property (nonatomic, strong) JGJCustomLable *titleLable;

@property (nonatomic, strong) UIView *topLineView;

@end

@implementation JGJCheckAccountHeaderView

+ (instancetype)checkAccountHeaderViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"JGJCheckAccountHeaderView";
    
    JGJCheckAccountHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!headerView) {
        
        headerView = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = AppFontf7f7f7Color;
        
        JGJCustomLable *titleLable = [JGJCustomLable new];
        
        titleLable.textAlignment = NSTextAlignmentLeft;
        
        self.titleLable = titleLable;
        
        titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        titleLable.textColor = AppFont666666Color;
        
        titleLable.backgroundColor =AppFontf7f7f7Color;
        
        [self.contentView addSubview:titleLable];
        
        self.topLineView = [[UIView alloc] init];
        
        self.topLineView.backgroundColor = AppFontdbdbdbColor;
        
        [self.contentView addSubview:self.topLineView];

    }
    
    return self;
}

- (void)setTime:(NSString *)time {
    
    _time = time;
    
    self.titleLable.text = _time;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView);
        
        make.right.mas_equalTo(self.contentView);
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.height.mas_equalTo(30);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.contentView);
        
        make.height.mas_equalTo(0.5);
    }];
    
    self.titleLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
}
@end
