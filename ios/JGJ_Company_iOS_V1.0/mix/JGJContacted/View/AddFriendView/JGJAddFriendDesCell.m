//
//  JGJAddFriendDesCell.m
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendDesCell.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJAddFriendDesCell ()
@property (weak, nonatomic) IBOutlet UILabel *searchResultLable;

@end

@implementation JGJAddFriendDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchResultLable.textColor = AppFont666666Color;
    self.searchResultLable.font = [UIFont systemFontOfSize:AppFont30Size];
}

- (void)setSearchTel:(NSString *)searchTel {
    _searchTel = searchTel;
    if (![NSString isEmpty:searchTel]) {
        self.searchResultLable.textAlignment = NSTextAlignmentLeft;
        NSString *searchInfo = [NSString stringWithFormat:@"“%@”", searchTel];
        self.searchResultLable.text = [NSString stringWithFormat:@"搜索%@",searchInfo];
        [self.searchResultLable markText:searchInfo withColor:AppFontd7252cColor];
    }else {
        self.searchResultLable.textAlignment = NSTextAlignmentCenter;
        self.searchResultLable.text = @"该用户不存在";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
