//
//  JGJSynRecordHeaderView.m
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynRecordHeaderView.h"

#import "UILabel+GNUtil.h"

@interface JGJSynRecordHeaderView ()

@property (nonatomic, weak) UIButton *expandButton;

@property (nonatomic, weak) UILabel *headerTitle;

@property (nonatomic, weak) UIView *toplineView;

@property (nonatomic, weak) UIView *bottomlineView;

@property (nonatomic, weak) UILabel *desLable;

@end

@implementation JGJSynRecordHeaderView

+ (instancetype)synRecordHeaderViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"JGJSynRecordHeaderView";
    
    JGJSynRecordHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!headerView) {
        
        headerView = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = AppFontfafafaColor;
        
        //展开箭头
        UIButton *expandButton = [[UIButton alloc] init];
        
        expandButton.backgroundColor = AppFontfafafaColor;
        
        [expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.expandButton = expandButton;
        
        [expandButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        
        // 设置内部的imageView的内容模式为居中
        expandButton.contentMode = UIViewContentModeRight;
        // 超出边框的内容不需要裁剪
        expandButton.clipsToBounds = NO;
        
        expandButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        self.expandButton = expandButton;
        
        [self.contentView addSubview:expandButton];
        
        //数量
        UILabel *desLable = [[UILabel alloc] init];
        
        desLable.textAlignment = NSTextAlignmentRight;
        
        desLable.backgroundColor = AppFontfafafaColor;
        
        desLable.textColor = AppFont333333Color;
        
        desLable.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        
        self.desLable = desLable;
        
        [self.contentView addSubview:desLable];
        
        UILabel *headerTitle = [[UILabel alloc] init];
        
        headerTitle.textColor = AppFont333333Color;
        
        headerTitle.backgroundColor = AppFontfafafaColor;
        
        headerTitle.font = [UIFont boldSystemFontOfSize:AppFont30Size];
                
        [self.contentView addSubview:headerTitle];
        
        self.headerTitle = headerTitle;
        
        UIView *toplineView = [[UIView alloc] init];
        
        toplineView.backgroundColor = AppFontdbdbdbColor;
        
        [self.contentView addSubview:toplineView];
        
        self.toplineView = toplineView;
        
        UIView *bottomlineView = [[UIView alloc] init];
        
        bottomlineView.backgroundColor = AppFontdbdbdbColor;
        
        [self.contentView addSubview:bottomlineView];
        
        self.bottomlineView = bottomlineView;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).mas_offset(0);
        
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        
        make.top.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).mas_offset(0);
        
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
    }];
    
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
        
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        
        make.height.mas_equalTo(30);
    }];
    
    [self.desLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.right.mas_equalTo(self.contentView).mas_offset(-35);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(15);
    }];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.contentView.mas_centerY);

        make.left.mas_equalTo(self.contentView).mas_offset(10);

        make.height.mas_equalTo(30);

        make.left.mas_equalTo(self.desLable).mas_offset(10);
    }];
    
}

- (void)setSynedProModel:(JGJSynedProModel *)synedProModel {
    
    _synedProModel = synedProModel;
    
    NSString *name = synedProModel.user_info.name;
    
    if (![NSString isEmpty:synedProModel.real_name]) {
        
        name = synedProModel.real_name;
    }
    
    if (![NSString isEmpty:synedProModel.user_info.name]) {
        
        name = synedProModel.user_info.name;
    }
    
    if (synedProModel.is_syn_me) {
        
        NSString *des = @"同步给我的记工";
        
        self.headerTitle.text = [NSString stringWithFormat:@"%@ %@", name, des];
        
        [self.headerTitle markText:des withColor:AppFont999999Color];
        
    }else {
        
        self.headerTitle.text = [NSString stringWithFormat:@"向 %@ 同步的记工", name];
        
    }
    
    self.desLable.text = synedProModel.synced_num?:@"";
    
    if (synedProModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
}

#pragma mark - 展开、收缩按钮
- (void)expandButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.synedProModel.isExpand = !self.synedProModel.isExpand;
    
    if (self.synedProModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    if ([self.delegate respondsToSelector:@selector(synRecordHeaderView:)]) {
        
        [self.delegate synRecordHeaderView:self];
    }
    
}

@end
