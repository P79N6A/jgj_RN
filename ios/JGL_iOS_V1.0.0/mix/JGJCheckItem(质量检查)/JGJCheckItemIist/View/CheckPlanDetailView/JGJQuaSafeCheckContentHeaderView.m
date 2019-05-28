//
//  JGJQuaSafeCheckContentHeaderView.m
//  JGJCompany
//
//  Created by yj on 2017/11/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckContentHeaderView.h"

@interface JGJQuaSafeCheckContentHeaderView ()

@property (nonatomic, weak) UIButton *expandButton;

@property (nonatomic, weak) UILabel *headerTitle;

@property (nonatomic, weak) UIView *toplineView;

@property (nonatomic, weak) UILabel *resultLable;

@property (nonatomic, weak) UIImageView *flagImageView;

@end

@implementation JGJQuaSafeCheckContentHeaderView

+ (instancetype)checkContentHeaderViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"JGJQuaSafeCheckContentHeaderView";
    
    JGJQuaSafeCheckContentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!headerView) {
        
        headerView = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
     if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
         
         UIView *toplineView = [[UIView alloc] init];
         
         toplineView.backgroundColor = AppFontdbdbdbColor;
         
         [self.contentView addSubview:toplineView];
         
         self.toplineView = toplineView;
         
         //检查结果
         UILabel *resultLable = [[UILabel alloc] init];
         
         resultLable.textAlignment = NSTextAlignmentRight;
         
         resultLable.backgroundColor = [UIColor whiteColor];
         
         resultLable.textColor = AppFont999999Color;
         
         resultLable.font = [UIFont systemFontOfSize:AppFont30Size];
         
         self.resultLable = resultLable;
         
         [self.contentView addSubview:resultLable];
         
         self.contentView.backgroundColor = [UIColor whiteColor];
         
         
         UILabel *headerTitle = [[UILabel alloc] init];
         
         headerTitle.textColor = AppFont333333Color;
         
         headerTitle.font = [UIFont boldSystemFontOfSize:AppFont30Size];
         
         [self.contentView addSubview:headerTitle];
         
         self.headerTitle = headerTitle;
         
         headerTitle.preferredMaxLayoutWidth = TYGetUIScreenWidth - 125;
         
         headerTitle.lineBreakMode = NSLineBreakByCharWrapping;
         
         headerTitle.numberOfLines = 0;
         
         //展开箭头
         UIImageView *flagImageView = [[UIImageView alloc] init];
         
         flagImageView.image = [UIImage imageNamed:@"check_list_tip_red"];
         
         // 设置内部的imageView的内容模式为居中
         flagImageView.contentMode = UIViewContentModeRight;
         
         self.flagImageView = flagImageView;
         
         [self.contentView addSubview:flagImageView];
         
         //展开箭头
         UIButton *expandButton = [[UIButton alloc] init];
         
         expandButton.backgroundColor = [UIColor clearColor];
         
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
         
     }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        
        make.right.mas_equalTo(self.contentView).mas_offset(10);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
    }];
    
    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        
        make.width.mas_equalTo(5);
        
        make.height.mas_equalTo(15);
    }];
    
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
        
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        
        make.height.mas_equalTo(30);
    }];
    
    [self.resultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.right.mas_equalTo(self.contentView).mas_offset(-35);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(15);
    }];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.flagImageView).mas_offset(15);
        
        make.width.mas_equalTo(TYGetUIScreenWidth - 125);
        
//        make.height.mas_equalTo(21);
    }];
    
}

- (void)setCheckItemModel:(JGJInspectPlanProInfoContentListModel *)checkItemModel {
    
    _checkItemModel =  checkItemModel;
    
    self.headerTitle.text = _checkItemModel.content_name;
    
    UIColor *statusColor = AppFont999999Color;
    
    NSString *status = @"";
    
    if ([checkItemModel.status isEqualToString:@"0"]) {
        
        status = @"[未检查]";
        
    }else if ([checkItemModel.status isEqualToString:@"1"]) {
        
        statusColor = AppFontFF0000Color;
        
        status = @"[待整改]";
        
    }else if ([checkItemModel.status isEqualToString:@"2"]) {
        
        status = @"[不用检查]";
        
    }else if ([checkItemModel.status isEqualToString:@"3"]) {
        
        statusColor = AppFont83C76EColor;
        
        status = @"[通过]";
    }
    
    self.resultLable.textColor = statusColor;
    
    self.resultLable.text = status;
 
    [self expandImageViewWithCheckItemModel:checkItemModel];
    
    
}

- (void)expandImageViewWithCheckItemModel:(JGJInspectPlanProInfoContentListModel *)checkItemModel {
    
    if (self.checkItemModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)expandButtonPressed:(UIButton *)sender {
    
    self.checkItemModel.isExpand = !self.checkItemModel.isExpand;
    
    if (self.checkItemModel.isExpand) {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    if ([self.delegate respondsToSelector:@selector(JGJQuaSafeCheckContentHeaderView:checkItemModel:)]) {
        
        [self.delegate JGJQuaSafeCheckContentHeaderView:self checkItemModel:self.checkItemModel];
    }
    
}

@end
