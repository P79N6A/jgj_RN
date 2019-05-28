//
//  JGJConversationHeaderView.m
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJConversationHeaderView.h"

@interface JGJConversationHeaderView ()
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation JGJConversationHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = AppFont666666Color;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = title;
}

@end
