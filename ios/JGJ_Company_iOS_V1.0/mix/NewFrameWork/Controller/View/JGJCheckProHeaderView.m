//
//  JGJCheckProHeaderView.m
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckProHeaderView.h"

@interface JGJCheckProHeaderView ()

@property (nonatomic, weak) UIButton *expandButton;

@property (nonatomic, weak) UILabel *headerTitle;

@property (nonatomic, weak) UIView *toplineView;

@property (nonatomic, weak) UIView *containView;

@end

@implementation JGJCheckProHeaderView

+ (instancetype)checkProHeaderViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"CheckProHeaderView";
    
    JGJCheckProHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!headerView) {
        
        headerView = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *toplineView = [[UIView alloc] init];
        
        toplineView.backgroundColor = AppFontf1f1f1Color;
        
        [self.contentView addSubview:toplineView];
        
        self.toplineView = toplineView;
        
        UIView *containView = [[UIView alloc] init];
        
        containView.backgroundColor = AppFontfafafaColor;
        
        self.containView = containView;
        
        [self.contentView addSubview:containView];
        
        
        UILabel *headerTitle = [[UILabel alloc] init];
        
        headerTitle.textColor = AppFont999999Color;
        
        headerTitle.font = [UIFont boldSystemFontOfSize:AppFont28Size];
        
        
        [containView addSubview:headerTitle];
        
        self.headerTitle = headerTitle;
        
        UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [expandButton addTarget:self action:@selector(handleExpandButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [expandButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        
        // 设置按钮内部的imageView的内容模式为居中
        expandButton.imageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不需要裁剪
        expandButton.imageView.clipsToBounds = NO;
        
        [containView addSubview:expandButton];
        
        self.expandButton = expandButton;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpandButtonClicked)];
        
        tap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.top.right.mas_equalTo(self);
    //
    //        make.height.mas_equalTo(20);
    //    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.containView).mas_offset(12);
        
        make.centerY.mas_equalTo(self.containView);
        
        make.height.mas_equalTo(self.containView.mas_height);
        
        make.right.mas_equalTo(self.expandButton.mas_left).mas_offset(-12);
        
    }];
    
    
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.containView);
        
        make.height.width.mas_equalTo(self.containView.mas_height);
        
        make.right.mas_equalTo(self.containView).mas_offset(-6);
        
    }];
}

- (void)handleExpandButtonClicked {
    
    if ([self.delegate respondsToSelector:@selector(checkProHeaderView:)]) {
        
        [self.delegate checkProHeaderView:self];
    }
    
}

- (void)setIsUnflod:(BOOL)isUnflod {
    
    _isUnflod = isUnflod;
    if (self.isUnflod) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.expandButton.hidden = !proListModel.isClosedTeamVc;
    
    self.headerTitle.text = proListModel.headerTilte;
    
    self.headerTitle.textColor = self.titleColor;
    
    if (self.proListModel.isUnExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
}

- (void)setGroupModel:(JGJChatGroupListModel *)groupModel {
    
    _groupModel = groupModel;
    
    self.expandButton.hidden = !_groupModel.is_closed;
    
    self.headerTitle.text = _groupModel.headerTilte;
    
    self.headerTitle.textColor = self.titleColor;
}

@end

