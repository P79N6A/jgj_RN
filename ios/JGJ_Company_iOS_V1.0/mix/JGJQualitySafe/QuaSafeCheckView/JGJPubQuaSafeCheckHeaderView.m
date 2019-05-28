//
//  JGJPubQuaSafeCheckHeaderView.m
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPubQuaSafeCheckHeaderView.h"

@interface JGJPubQuaSafeCheckHeaderView ()

@property (nonatomic, weak) UILabel *headerTitle;

@property (nonatomic, weak) UIView *bottomlineView;

@property (nonatomic, weak) UIView *containView;

@end


@implementation JGJPubQuaSafeCheckHeaderView

+ (instancetype)checkProHeaderViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"JGJPubQuaSafeCheckHeaderView";
    
    JGJPubQuaSafeCheckHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!headerView) {
        
        headerView = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = AppFontf1f1f1Color;
        
        UIView *containView = [[UIView alloc] init];
        
        containView.backgroundColor = [UIColor whiteColor];
        
        self.containView = containView;
        
        [self.contentView addSubview:containView];
        
        
        UILabel *headerTitle = [[UILabel alloc] init];
        
        headerTitle.textColor = AppFont333333Color;
        
        headerTitle.text = @"请选择检查大项";
        
        headerTitle.font = [UIFont systemFontOfSize:AppFont30Size];
        
        
        [containView addSubview:headerTitle];
        
        self.headerTitle = headerTitle;
        
        UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        selButton.userInteractionEnabled = NO;
        
        [selButton setImage:[UIImage imageNamed:@"EllipseIcon"] forState:UIControlStateNormal];
        
        [selButton setImage:[UIImage imageNamed:@"MultiSelected"] forState:UIControlStateSelected];
        
        [containView addSubview:selButton];
        
        UIView *bottomlineView = [[UIView alloc] init];
        bottomlineView.backgroundColor = AppFontdbdbdbColor;
        
        self.bottomlineView = bottomlineView;
        
        [self.contentView addSubview:bottomlineView];
        
        self.selButton = selButton;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelButtonClicked)];
        
        tap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

+ (CGFloat)pubQuaSafeCheckHeaderView {

    return 65;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(45);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    [self.bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.containView);
        
        make.left.mas_equalTo(self.containView).mas_offset(10);
        
        make.right.mas_equalTo(self.containView.mas_right).mas_offset(-10);
        
        make.height.mas_equalTo(0.5);
    }];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.containView).mas_offset(10);
        
        make.centerY.mas_equalTo(self.containView);
        
        make.height.mas_equalTo(self.containView.mas_height);
        
        make.right.mas_equalTo(self.selButton.mas_left).mas_offset(-10);
        
    }];
    
    [self.selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.containView);
        
        make.height.mas_equalTo(self.containView.mas_height);
        
        make.width.mas_equalTo(40);
        
        make.right.mas_equalTo(self.containView);
        
    }];
}

- (void)handleSelButtonClicked {

    self.selButton.selected = !self.selButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(pubQuaSafeCheckHeaderView: selectedHeader:)]) {
        
        [self.delegate pubQuaSafeCheckHeaderView:self selectedHeader:self.selButton.selected];
    }

}

@end
