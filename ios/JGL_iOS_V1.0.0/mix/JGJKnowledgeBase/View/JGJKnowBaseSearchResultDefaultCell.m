//
//  JGJKnowBaseSearchResultDefaultCell.m
//  mix
//
//  Created by yj on 17/4/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowBaseSearchResultDefaultCell.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"

@interface JGJKnowBaseSearchResultDefaultCell ()

@property (weak, nonatomic) IBOutlet UILabel *searchValueLable;

@end

@implementation JGJKnowBaseSearchResultDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchValueLable.textColor = AppFont999999Color;
}

- (void)setSearchValue:(NSString *)searchValue {

    _searchValue = searchValue;
    
    self.hidden = [NSString isEmpty:_searchValue] || searchValue.length == 0;
    
    self.searchValueLable.text = [NSString stringWithFormat:@"搜索到”%@“", _searchValue];
    
}

- (void)setSearchResultDefaultCellType:(JGJKnowBaseSearchResultDefaultCellType)searchResultDefaultCellType {

    _searchResultDefaultCellType = searchResultDefaultCellType;
    
    if (_searchResultDefaultCellType == JGJKnowBaseSearchingResultDefaultCellType) {
        
        self.searchValueLable.text = [NSString stringWithFormat:@"搜索到“%@”", _searchValue];
        
        [self.searchValueLable markText:_searchValue withColor:AppFontd7252cColor];
        
        self.searchValueLable.textAlignment = NSTextAlignmentLeft;
        
    }else if (_searchResultDefaultCellType == JGJKnowBaseNoResultDefaultCellType) {
    
        self.searchValueLable.text = @"未搜索到相关内容";
        
        self.searchValueLable.textAlignment = NSTextAlignmentCenter;
    }

}

+ (CGFloat)knowBaseSearchResultDefaultCellHeight {

    return 50;
}

@end
