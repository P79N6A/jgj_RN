//
//  JGJHeaderFooterPaddingView.m
//  mix
//
//  Created by yj on 2018/6/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJHeaderFooterPaddingView.h"

@interface JGJHeaderFooterPaddingView ()

@property (nonatomic, weak) UIView *lineView;

@end

@implementation JGJHeaderFooterPaddingView

+ (instancetype)headerFooterPaddingViewWithTableView:(UITableView *)tableView {
    
    static NSString *resueId = @"JGJHeaderFooterPaddingView";
    
    JGJHeaderFooterPaddingView *paddingiew = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
    if (!paddingiew) {
        
        paddingiew = [[self alloc] initWithReuseIdentifier:resueId];
    }
    
    return paddingiew;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *lineView = [[UIView alloc] init];
        
        lineView.backgroundColor = AppFontdbdbdbColor;
        
        [self.contentView addSubview:lineView];
        
        self.lineView = lineView;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).mas_offset(0);
        
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        
        make.top.mas_equalTo(9.5);
        
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void) setUpdateLineViewLayoutWithTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right isHidden:(BOOL)isHidden {
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(top);
        
        make.left.mas_equalTo(self.contentView).mas_offset(left);
        
        make.right.mas_equalTo(self.contentView).mas_offset(right);
    }];
    
    self.lineView.hidden = isHidden;
}

@end
